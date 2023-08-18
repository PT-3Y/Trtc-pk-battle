import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models/common_message_response.dart';
import 'package:socialv/models/messages/delete_message_response.dart';
import 'package:socialv/models/messages/message_groups.dart';
import 'package:socialv/models/messages/message_settings_model.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/models/messages/private_thread_response.dart';
import 'package:socialv/models/messages/send_message_response.dart';
import 'package:socialv/models/messages/threads_list_model.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/models/messages/user_settings_model.dart';
import 'package:socialv/models/messages/search_message_response.dart';
import 'package:socialv/models/story/common_story_model.dart';
import 'package:socialv/network/network_utils.dart';
import 'package:socialv/utils/app_constants.dart';

import '../models/messages/emoji.dart';

Future<ThreadsListModel> getRecentMessages() async {
  return ThreadsListModel.fromJson(
    await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.threads}')),
  );
}

Future<List<MessagesUsers>> getFriends() async {
  Iterable it = await handleResponse(await buildHttpResponse(MessageAPIEndPoint.getFriends));

  return it.map((e) => MessagesUsers.fromJson(e)).toList();
}

Future<List<MessageGroups>> getGroups({int page = 1, String? searchText}) async {
  Iterable it = await handleResponse(await buildHttpResponse(MessageAPIEndPoint.getGroups));

  return it.map((e) => MessageGroups.fromJson(e)).toList();
}

Future<ThreadsListModel> getSpecificThread({required int threadId}) async {
  return ThreadsListModel.fromJson(
    await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId', method: HttpMethod.POST)),
  );
}

Future<SendMessageResponse> sendMessage({required int threadId, required String message, int? messageId, bool isFile = false, String? tmpId}) async {
  Map meta = messageId != null ? {"reply_to": messageId} : {};

  Map request = {"message": message.isNotEmpty ? message : null, "meta": meta, "files": isFile, "message_id": messageId, "tmpId": tmpId};

  return SendMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/send', method: HttpMethod.POST, request: request)),
  );
}

Future<void> muteThread({required int threadId}) async {
  await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/mute', method: HttpMethod.POST));
}

Future<void> unMuteThread({required int threadId}) async {
  await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/unmute', method: HttpMethod.POST));
}

Future<void> pinThread({required int threadId}) async {
  await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/makePinned', method: HttpMethod.POST));
}

Future<void> unPinThread({required int threadId}) async {
  await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/unmakePinned', method: HttpMethod.POST));
}

Future<void> deleteThread({required int threadId}) async {
  await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/delete', method: HttpMethod.POST);
}

Future<PrivateThreadResponse> privateThread({required int userId}) async {
  Map request = {"user_id": userId, "create": true, "subject": "", "uniqueKey": null};

  return PrivateThreadResponse.fromJson(
    await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.getPrivateThread}', method: HttpMethod.POST, request: request)),
  );
}

Future<UserSettingsModel> userSettings() async {
  return UserSettingsModel.fromJson(
    await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.userSettings}')),
  );
}

Future<CommonMessageResponse> saveUserSettings({required String option, required bool value}) async {
  Map request = {"option": option, "value": value.toString()};
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.userSettings}/save', method: HttpMethod.POST, request: request)),
  );
}

Future<void> unblockUser({required int userId}) async {
  Map request = {"user_id": userId};
  await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.unblockUser}', method: HttpMethod.POST, request: request));
}

Future<void> blockUser({required int userId}) async {
  Map request = {"user_id": userId};
  await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.blockUser}', method: HttpMethod.POST, request: request));
}

Future<void> starMessage({required int messageId, required String type, required int threadId}) async {
  Map request = {"messageId": messageId, "type": type};
  await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/${MessageAPIEndPoint.favorite}', method: HttpMethod.POST, request: request));
}

Future<ThreadsListModel> editMessage({required int messageId, required String message, required int threadId}) async {
  Map request = {"message_id": messageId, "message": message};

  return ThreadsListModel.fromJson(
    await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/save', method: HttpMethod.POST, request: request)),
  );
}

Future<DeleteMessageResponse> deleteMessage({required int messageId, required int threadId}) async {
  Map request = {
    "messageIds": [messageId]
  };

  return DeleteMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/deleteMessages', method: HttpMethod.POST, request: request)),
  );
}

Future<void> uploadMessageMedia({required int threadId, MediaSourceModel? media, required int messageId}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('${MessageAPIEndPoint.thread}/$threadId/upload/$messageId');

  multiPartRequest.headers.addAll(buildHeaderTokens(requiredNonce: false, requiredToken: true));

  if (media != null) {
    multiPartRequest.files.add(await MultipartFile.fromPath('file', media.mediaFile.path, contentType: MediaType(media.mediaType, media.extension)));
  }

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      log('data: ${data.toString()}');
    },
    onError: (error) {
      log('error: ${error.toString()}');
    },
  );
}

Future<SearchMessageResponse?> searchMessage({required String searchText}) async {
  Map request = {"search": searchText};
  Response response = await buildHttpResponse(MessageAPIEndPoint.search, method: HttpMethod.POST, request: request);

  if (jsonDecode(response.body).toString() != '[]') {
    return SearchMessageResponse.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<List<MessagesUsers>> getSuggestions({String? searchText, int? threadId}) async {
  String request = threadId == null ? "?search=$searchText" : "?search=$searchText&threadId=$threadId";
  Iterable it = await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.suggestions}$request'));

  return it.map((e) => MessagesUsers.fromJson(e)).toList();
}

Future<ThreadsListModel> getFavorites() async {
  return ThreadsListModel.fromJson(
    await handleResponse(await buildHttpResponse(MessageAPIEndPoint.getFavorited)),
  );
}

Future<void> addParticipant({required List listOfParticipant, required int threadId}) async {
  Map request = {"user_id": listOfParticipant};
  await buildHttpResponse("${MessageAPIEndPoint.thread}/$threadId/${MessageAPIEndPoint.addParticipant}", method: HttpMethod.POST, request: request);
}

Future<void> removeParticipant({required int userId, required int threadId}) async {
  Map request = {"user_id": userId};
  await buildHttpResponse("${MessageAPIEndPoint.thread}/$threadId/${MessageAPIEndPoint.removeParticipant}", method: HttpMethod.POST, request: request);
}

Future<void> allowOtherToInviteMembers({required bool canInvite, required int threadId}) async {
  String invite = (canInvite) ? "yes" : "no";
  Map request = {"key": "allow_invite", "value": invite};
  await buildHttpResponse("${MessageAPIEndPoint.thread}/$threadId/${MessageAPIEndPoint.changeMeta}", method: HttpMethod.POST, request: request);
}

Future<void> changeSubjectOfParticipants({required String subject, required int threadId}) async {
  Map request = {"subject": subject};
  await buildHttpResponse("${MessageAPIEndPoint.thread}/$threadId/${MessageAPIEndPoint.changeSubject}", method: HttpMethod.POST, request: request);
}

Future<void> leaveFromParticipants({required int threadId}) async {
  await buildHttpResponse("${MessageAPIEndPoint.thread}/$threadId/${MessageAPIEndPoint.leaveThread}", method: HttpMethod.POST);
}

Future<Messages> getMessage({required int messageId}) async {
  return Messages.fromJson(await handleResponse(await buildHttpResponse("${MessageAPIEndPoint.message}?id=$messageId")));
}

Future<ThreadsListModel> saveReaction({required int messageId, required String emoji}) async {
  Map request = {"message_id": messageId, "emoji": emoji};
  return ThreadsListModel.fromJson(
    await handleResponse(await buildHttpResponse("${MessageAPIEndPoint.saveThread}", method: HttpMethod.POST, request: request)),
  );
}

Future<List<Emojis>> getChatReactionList() async {
  Iterable it = await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.getEmojiList}'));
  return it.map((e) => Emojis.fromJson(e)).toList();
}

Future<ThreadsListModel> loadMoreMessages({required int threadId, required List<int> messageIds}) async {
  Map request = {"mode": "more", "loaded": messageIds};
  return ThreadsListModel.fromJson(
    await handleResponse(await buildHttpResponse('${MessageAPIEndPoint.thread}/$threadId/${MessageAPIEndPoint.loadMore}', request: request, method: HttpMethod.POST)),
  );
}

Future<dynamic> searchMentions({required String text, required int threadId}) async {
  Map request = {"search": text};
  return handleResponse(await buildHttpResponse("${MessageAPIEndPoint.thread}/$threadId/${MessageAPIEndPoint.mentionsSuggestions}", method: HttpMethod.POST, request: request));
}

Future<dynamic> restoreThread({required int threadId}) async {
  return handleResponse(await buildHttpResponse("${MessageAPIEndPoint.thread}/$threadId/${MessageAPIEndPoint.restore}", method: HttpMethod.POST));
}

Future<void> saveChatBackground({required String id, required File image, required String type}) async {
  appStore.setLoading(true);

  MultipartRequest multiPartRequest = await getMultiPartRequest(MessageAPIEndPoint.chatBackground);

  multiPartRequest.headers['authorization'] = 'Bearer ${appStore.token}';

  multiPartRequest.fields['id'] = id;
  multiPartRequest.fields['type'] = type.validate();
  multiPartRequest.files.add(await MultipartFile.fromPath('file', image.path));

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      appStore.setLoading(false);
    },
    onError: (error) {
      appStore.setLoading(false);
      log('error: ${error.toString()}');
    },
  );
}

Future<Messages> deleteChatBackground({required Map request}) async {
  return Messages.fromJson(await handleResponse(await buildHttpResponse(MessageAPIEndPoint.chatBackground, request: request, method: HttpMethod.DELETE)));
}

Future<MessageSettingsModel> messageSettings() async {
  return MessageSettingsModel.fromJson(await handleResponse(await buildHttpResponse(MessageAPIEndPoint.messagesSettings)));
}
