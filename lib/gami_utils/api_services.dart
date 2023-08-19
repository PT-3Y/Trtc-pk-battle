import 'dart:convert';
import 'package:socialv/main.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:socialv/screens/fragments/profile_fragment.dart';
import 'package:socialv/gami_utils/model.dart';
import 'package:socialv/debug/GenerateTestUserSig.dart';

String token =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2ludG9vbmVkd2Vla2x5LmNvbSIsImlhdCI6MTY4OTUyMTQ0NCwibmJmIjoxNjg5NTIxNDQ0LCJleHAiOjE2OTAxMjYyNDQsImRhdGEiOnsidXNlciI6eyJpZCI6IjEyMzUyIn19fQ.azxdJQOdt66_WzWhU6UDY0LoyvOKDnbKMIoAgk6ytW0';

Future<void> deductPoints(String userId, String pointsType, int amount) async {
  final url =
      'https://intoonedweekly.com/wp-json/wp/v2/gamipress/deduct-points';

  final Map<String, dynamic> requestBody = {
    'user_id': userId,
    'points_type': pointsType,
    'points': amount,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode(requestBody),
  );

  print(response.body);

  if (response.statusCode == 200) {
    // Request was successful
    print('Points deducted successfully');
  } else {
    // Request failed
    print('Failed to deduct points');
  }
}

Future<void> awardPoints(String userId, String pointsType, int amount) async {
  final url = 'https://intoonedweekly.com/wp-json/wp/v2/gamipress/award-points';

  final Map<String, dynamic> requestBody = {
    'user_id': userId,
    'points_type': pointsType,
    'points': amount,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode(requestBody),
  );

  print(response.body);

  if (response.statusCode == 200) {
    // Request was successful
    print('Points award successfully');
  } else {
    // Request failed
    print('Failed to award points');
  }
}

Future<int> fetchDiamondPoints(String pointsType, String userId) async {
  print('Token: =----> $token');

  final url =
      'https://intoonedweekly.com/wp-json/wp/v2/gamipress/get-points?points_type=$pointsType&user_id=$userId';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print(response.body);

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['raw'];
  } else {
    return 0;
  }
}

Future<void> sendRoomMessage(String fromUserId, String roomId, String message,
    String extendedData) async {
  // Set up the request URL and headers

  String sdkAppId = GenerateTestUserSig.sdkAppId.toString();
  String signatureVersion = '2.0';
  String signatureNonce = '12344321';
  // Get the current local time
  DateTime localTime = DateTime.now();

  // Convert the local time to UTC
  DateTime utcTime = localTime.toUtc();

  // Get the Unix timestamp in seconds
  int timestamp = utcTime.millisecondsSinceEpoch ~/ 1000 + 9000;

  String uri = 'https://zim-api.zego.im/?Action=SendRoomMessage'
      '&AppId=${sdkAppId}'
      '&Signature=${generateSignature(sdkAppId, signatureNonce, GenerateTestUserSig.secretKey, timestamp)}'
      '&SignatureVersion=${signatureVersion}'
      '&SignatureNonce=${signatureNonce}'
      '&Timestamp=${timestamp}';

  print(uri);

  Uri apiUrl = Uri.parse(uri);
  Map<String, String> headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> requestBody = {
    'FromUserId': fromUserId,
    'RoomId': roomId,
    'MessageType': 1,
    'Priority': 1,
    'MessageBody': {'Message': message, 'ExtendedData': extendedData}
  };
  String requestBodyJson = jsonEncode(requestBody);

  print('Sending ====>' + requestBodyJson);

  try {
    // Send the POST request
    http.Response response =
        await http.post(apiUrl, headers: headers, body: requestBodyJson);

    if (response.statusCode == 200) {
      print('Message sent successfully!');
    } else {
      print('Failed to send message. Error code: ${response.body.toString()}');
    }
  } catch (e) {
    print('An error occurred while sending the request: $e');
  }
}

Future<void> destroyRoom(String roomId) async {
  // Set up the request URL and headers

  String appId = GenerateTestUserSig.sdkAppId.toString();
  String signatureVersion = '2.0';
  String signatureNonce = '12344321';
  // Get the current local time
  DateTime localTime = DateTime.now();

  // Convert the local time to UTC
  DateTime utcTime = localTime.toUtc();

  // Get the Unix timestamp in seconds
  int timestamp = utcTime.millisecondsSinceEpoch ~/ 1000;

  String uri = 'https://zim-api.zego.im/?Action=DestroyRoom'
      '&AppId=${appId}'
      '&Signature=${generateSignature(appId, signatureNonce, GenerateTestUserSig.secretKey, timestamp)}'
      '&SignatureVersion=${signatureVersion}'
      '&SignatureNonce=${signatureNonce}'
      '&Timestamp=${timestamp}'
      '&RoomId=${roomId}';

  print(uri);

  Uri apiUrl = Uri.parse(uri);
  Map<String, String> headers = {'Content-Type': 'application/json'};

  Map<String, dynamic> requestBody = {
    'RoomId': roomId,
  };
  String requestBodyJson = jsonEncode(requestBody);

  print('Sending ====>' + requestBodyJson);

  try {
    // Send the POST request
    http.Response response =
        await http.post(apiUrl, headers: headers, body: requestBodyJson);

    if (response.statusCode == 201) {
      print('Room destroyed successfully!');
    } else {
      print('Failed to destroy room. Error code: ${response.body.toString()}');
    }
  } catch (e) {
    print('An error occurred while sending the request: $e');
  }
}

Future<UserModel> fetchUser(String userId) async {
  final url = 'https://intoonedweekly.com/wp-json/wp/v2/users/$userId';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print("fetch user:: " + response.body);

  if (response.statusCode == 201) {
    return UserModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch user');
  }
}

Future<List<EarningModel>> fetchUserEarnings(String userId) async {
  final url =
      'https://intoonedweekly.com/wp-json/wp/v2/gamipress-user-earnings?user_id=$userId';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print(response.body);

  if (response.statusCode == 201) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new EarningModel.fromJson(data)).toList();
  } else {
    throw Exception('Failed to fetch user earnings');
  }
}

String generateSignature(
    String appId, String signatureNonce, String serverSecret, int timestamp) {
  String concatenatedString = '$appId$signatureNonce$serverSecret$timestamp';
  List<int> bytes = utf8.encode(concatenatedString);
  Digest digest = md5.convert(bytes);
  String signature = digest.toString();
  return signature;
}

Future<List<dynamic>> getAllLiveRooms() async {
  final url = Uri.parse('https://intoonedweekly.com/api/get_all_rooms.php');
  final response = await http.get(url);

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    // Process the response data
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>room lists'+data["data"]);

    if (data["status"] == "error" || data["msg"] == "no stream found!") {
      return [];
    } else if (data["data"] != null) {
      return data["data"];
    } else {
      return [];
    }
  } else {
    // Handle the error
    print('Error: ${response.statusCode}');
    return [];
  }
}

Future<Map<String, dynamic>?> startLiveRoom(String userId, String userName,
    String liveId, int isHost, int liveStatus, String descriptions) async {
  final url = Uri.parse('https://intoonedweekly.com/api/start_live.php');
  final response = await http.post(
    url,
    body: {
      'userId': userId,
      'userName': userName,
      'liveId': liveId,
      'isHost': isHost.toString(),
      'liveStatus': liveStatus.toString(),
      'descriptions': descriptions,
    },
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    // Process the response data
    print(data);
    return data;
  } else {
    // Handle the error
    print('Error: ${response.statusCode}');
    return null;
  }
}

Future<Map<String, dynamic>?> endLiveRoom(String liveId) async {
  final url = Uri.parse('https://intoonedweekly.com/api/end_live.php');
  final response = await http.post(
    url,
    body: {
      'liveId': liveId,
    },
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    // Process the response data
    print(data);
    return data;
  } else {
    // Handle the error
    print('Error: ${response.statusCode}');
    return null;
  }
}
