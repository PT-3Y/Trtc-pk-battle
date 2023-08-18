import 'dart:collection';
import 'dart:convert';
import "dart:core";
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/configs.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/common.dart';
import 'package:socialv/utils/constants.dart';
import 'package:socialv/utils/woo_commerce/query_string.dart';

Map<String, String> buildHeaderTokens({required bool requiredNonce, required bool requiredToken}) {
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
  if (appStore.token.isNotEmpty && requiredToken) header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
  header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
  if (requiredNonce) header.putIfAbsent('Nonce', () => appStore.nonce);

  log(jsonEncode(header));
  return header;
}

/// for passing woo commerce parameters
String _getOAuthURL(String requestMethod, String endpoint) {
  var consumerKey = CONSUMER_KEY;
  var consumerSecret = CONSUMER_SECRET;

  var tokenSecret = "";
  var url = BASE_URL + endpoint;

  var containsQueryParams = url.contains("?");

  if (url.startsWith("https")) {
    return url + (containsQueryParams == true ? "&consumer_key=" + consumerKey + "&consumer_secret=" + consumerSecret : "?consumer_key=" + consumerKey + "&consumer_secret=" + consumerSecret);
  } else {
    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = new DateTime.now().millisecondsSinceEpoch ~/ 1000;

    var method = requestMethod;
    var parameters = "oauth_consumer_key=$consumerKey" + "&oauth_nonce=$nonce" + "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timestamp" + "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString + Uri.encodeQueryComponent(key) + "=" + treeMap[key] + "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method + "&" + Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url) + "&" + Uri.encodeQueryComponent(parameterString);

    var signingKey = consumerSecret + "&" + tokenSecret;
    var hmacSha1 = new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    var finalSignature = base64Encode(signature.bytes);

    var requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl = url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
    } else {
      requestUrl = url + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
    }

    return requestUrl;
  }
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethod method = HttpMethod.GET,
  Map? request,
  bool isStripePayment = false,
  bool isAuth = false,
  List<dynamic>? requestList,
  bool passParameters = false,
  bool requiredNonce = false,
  bool passHeaders = true,
  bool passToken = true,
}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens(requiredNonce: requiredNonce, requiredToken: passToken);

    late String url;
    if (endPoint.startsWith("http")) {
      url = endPoint;
    } else if (passParameters) {
      url = _getOAuthURL(method.toString(), endPoint);
    } else {
      url = '$BASE_URL$endPoint';
    }

    log('Request Url : $url');
    log('Request : $request');

    Response response;

    if (method == HttpMethod.POST) {
      response = await post(Uri.parse(url),
          body: requestList.validate().isNotEmpty
              ? jsonEncode(requestList)
              : isAuth
                  ? request
                  : jsonEncode(request),
          headers: isAuth ? null : headers);
    } else if (method == HttpMethod.DELETE) {
      response = await delete(Uri.parse(url), headers: passHeaders ? headers : {}, body: jsonEncode(request));
    } else if (method == HttpMethod.PUT) {
      response = await put(Uri.parse(url), body: jsonEncode(request), headers: headers);
    } else {
      response = await get(Uri.parse(url), headers: passHeaders ? headers : {});
    }

    log('Response ($method): ${response.statusCode} ${response.body}');

    return response;
  } else {
    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response, [bool? avoidTokenError]) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 401) {
    if (!avoidTokenError.validate()) LiveStream().emit(tokenStream, true);
    throw 'Token Expired';
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    try {
      var body = jsonDecode(response.body);
      log('body: $body');
      throw body['message'] is String ? parseHtmlString(body['message']) : body['message'];
    } on Exception catch (e) {
      log(e);
      throw errorSomethingWentWrong;
    }
  }
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  late String url;
  if (endPoint.startsWith("http")) {
    url = endPoint;
  } else {
    url = '$BASE_URL$endPoint';
  }

  log('Url: $url');

  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  Response response = await Response.fromStream(await multiPartRequest.send());
  print("statusCode: ${response.statusCode}");
  print("body: ${response.body}");

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    onError?.call(errorSomethingWentWrong);
  }
}

enum HttpMethod { GET, POST, DELETE, PUT }
