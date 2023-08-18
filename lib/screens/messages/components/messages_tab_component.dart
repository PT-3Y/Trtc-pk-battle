import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/models/messages/threads_model.dart';
import 'package:socialv/models/messages/threads_list_model.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/components/initial_message_component.dart';
import 'package:socialv/screens/messages/components/recent_message_component.dart';
import 'package:socialv/screens/messages/components/restore_component.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class MessagesTabComponent extends StatefulWidget {
  const MessagesTabComponent({Key? key}) : super(key: key);

  @override
  State<MessagesTabComponent> createState() => _MessagesTabComponentState();
}

class _MessagesTabComponentState extends State<MessagesTabComponent> {
  List<MessagesUsers> participantUsers = [];

  ThreadsListModel? threadsList;
  bool isError = false;
  bool isLoading = false;
  bool showRestore = false;
  int? deletedThreadId;

  @override
  void initState() {
    super.initState();

    recentMessages();
    messageStore.setRefreshRecentMessages(true);
    refreshRecentMessages();

    LiveStream().on(RefreshRecentMessage, (p0) {
      Threads thread = LiveStream().getValue(RefreshRecentMessage) as Threads;

      if (threadsList != null) {
        if (threadsList!.threads.validate().any((element) => element.threadId == thread.threadId)) {
          addMessage(messageId: thread.lastMessage.validate(), threadId: thread.threadId.validate());
        } else {
          recentMessages();
        }
      } else {
        recentMessages();
      }
    });

    LiveStream().on(RefreshRecentMessages, (p0) {
      recentMessages();
    });

    LiveStream().on(RecentThreadStatus, (p0) {
      Threads thread = LiveStream().getValue(RecentThreadStatus) as Threads;

      int? index;

      if (threadsList!.threads.validate().any((element) => element.threadId == thread.threadId)) {
        threadsList!.threads!.forEach((element) {
          if (element.threadId == thread.threadId) {
            if (thread.participantsCount != element.participantsCount) {
              recentMessages();
            } else if (thread.subject != element.subject) {
              index = threadsList!.threads!.indexOf(element);
            }
          }
        });

        if (index != null) {
          threadsList!.threads![index.validate()].subject = thread.subject;
          setState(() {});
        }
      } else {
        recentMessages();
      }
    });
  }

  Future<void> addMessage({required int messageId, required int threadId}) async {
    await getMessage(messageId: messageId).then((value) async {
      threadsList!.messages!.add(value);

      threadsList!.threads.validate().forEach((element) {
        if (element.threadId == threadId) {
          element.lastMessage = messageId;
        }
      });

      setState(() {});
    }).catchError((e) {
      log('Error: ${e.toString()}');
    });
  }

  sendSocketMessage(List<Threads> threads) {
    List<int> list = [];

    Future.forEach(threads, (Threads element) {
      list.add(element.threadId.validate());
    }).then((value) {
      String message = '42["${SocketEvents.subscribeToThreads}",$list]';
      log('Send Message : $message');
      if (messageStore.refreshRecentMessage) channel?.sink.add(message);
    });
  }

  Future<void> recentMessages({bool showLoader = true}) async {
    isError = false;
    if (showLoader) {
      isLoading = true;
      setState(() {});
    }

    await getRecentMessages().then((value) {
      sendSocketMessage(value.threads.validate());
      threadsList = value;
      isLoading = false;
      setState(() {});
    }).catchError((error) {
      isLoading = false;
      isError = true;
      setState(() {});
      log('Error: $error');
    });
  }

  Future<void> refreshRecentMessages() async {
    if (appStore.isWebsocketEnable != 1 && messageStore.refreshRecentMessage) {
      Future.delayed(Duration(seconds: 15), () {
        recentMessages(showLoader: false);
        refreshRecentMessages();
      });
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(RefreshRecentMessage);
    LiveStream().dispose(RecentThreadStatus);
    LiveStream().dispose(RefreshRecentMessages);
    messageStore.setRefreshRecentMessages(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (threadsList != null)
          if (threadsList!.threads.validate().isNotEmpty)
            AnimatedListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: threadsList!.threads.validate().length,
              slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
              itemBuilder: (context, index) {
                Threads thread = threadsList!.threads.validate()[index];
                MessagesUsers user = threadsList!.users.validate().firstWhere((element) => element.userId == thread.participants!.first);
                Messages message = threadsList!.messages.validate().firstWhere((element) => element.messageId.validate() == thread.lastMessage.validate());
                if (thread.participantsCount.validate() > 2 && thread.type != ThreadType.group) {
                  participantUsers.clear();
                  thread.participants.validate().forEach((val) {
                    if (threadsList!.users.validate().any((element) => element.userId == val)) {
                      participantUsers.add(threadsList!.users.validate().firstWhere((element) => element.userId == val));
                    }
                  });
                }

                return RecentMessageComponent(
                  user: user,
                  thread: thread,
                  message: message,
                  participantUsers: participantUsers,
                  callback: () {
                    setState(() {});
                  },
                  refreshThread: () {
                    recentMessages();
                  },
                  onDeleteConvo: () async {
                    deletedThreadId = thread.threadId.validate();
                    showRestore = true;
                    setState(() {});
                  },
                  doRefresh: () {
                    messageStore.setRefreshRecentMessages(true);
                    refreshRecentMessages();
                  },
                );
              },
              shrinkWrap: true,
            )
          else
            InitialMessageComponent(title: language.noConversationsYet, showButton: true),
        if (showRestore)
          Positioned(
            top: context.height() / 1.8,
            right: 16,
            child: RestoreComponent(
              threadId: deletedThreadId.validate(),
              callback: (bool value) {
                if (!value) {
                  recentMessages();
                }
                showRestore = false;
                deletedThreadId = null;
                setState(() {});
              },
            ),
          ),
        if (isError && !isLoading && threadsList == null)
          SizedBox(
            height: context.height() * 0.65,
            child: NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: language.somethingWentWrong,
              onRetry: () {
                recentMessages();
              },
              retryText: '   ${language.clickToRefresh}   ',
            ).center(),
          ),
        SizedBox(
          height: context.height() * 0.65,
          child: ThreeBounceLoadingWidget(),
        ).visible(isLoading),
      ],
    );
  }
}
