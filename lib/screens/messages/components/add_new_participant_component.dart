import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/cached_network_image.dart';
import '../../../models/messages/message_users.dart';
import '../../../network/messages_repository.dart';
import '../../../utils/app_constants.dart';

// ignore: must_be_immutable
class AddNewParticipantComponent extends StatefulWidget {
  final int threadId;
  final VoidCallback callback;

  AddNewParticipantComponent({required this.threadId, required this.callback});

  @override
  State<AddNewParticipantComponent> createState() => _AddNewParticipantComponentState();
}

class _AddNewParticipantComponentState extends State<AddNewParticipantComponent> {
  TextEditingController searchController = TextEditingController();
  List<MessagesUsers> selectedSuggestionList = [];
  List<MessagesUsers> suggestionList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> suggestions() async {
    isLoading = true;
    suggestionList.clear();
    await getSuggestions(searchText: searchController.text, threadId: widget.threadId).then((value) {
      isLoading = false;
      suggestionList.addAll(value);
      setState(() {});
    }).catchError((e) {
      isLoading = false;
      setState(() {});
    });
  }

  Future<void> addParticipantsInChat() async {
    List listOfParticipant = [];
    selectedSuggestionList.forEach((element) {
      listOfParticipant.add(element.id);
    });
    if (listOfParticipant.isNotEmpty) {
      isLoading = true;
      setState(() {});
      await addParticipant(listOfParticipant: listOfParticipant, threadId: widget.threadId).then((value) async {
        isLoading = false;
        setState(() {});
        widget.callback.call();
      }).catchError((e) {
        isLoading = false;
        setState(() {});
        toast(e.toString());
      });
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
            ),
            8.height,
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language.addNewParticipant, style: boldTextStyle(size: 18)),
                        IconButton(
                          onPressed: () {
                            finish(context);
                          },
                          icon: Icon(Icons.cancel_outlined, size: 24),
                        ),
                      ],
                    ),
                    8.height,
                    Text(language.addParticipantText, style: secondaryTextStyle()),
                    16.height,
                    AppTextField(
                      controller: searchController,
                      textFieldType: TextFieldType.USERNAME,
                      onFieldSubmitted: (text) {
                        if (searchController.text.trim().isNotEmpty) {
                          //isSearchPerformed = true;
                          suggestions();
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.scaffoldBackgroundColor,
                        border: InputBorder.none,
                        hintText: language.startTypingToSearch,
                        hintStyle: secondaryTextStyle(),
                        prefixIcon: Image.asset(
                          ic_search,
                          height: 16,
                          width: 16,
                          fit: BoxFit.cover,
                          color: appStore.isDarkMode ? bodyDark : bodyWhite,
                        ).paddingAll(16),
                      ),
                    ).cornerRadiusWithClipRRect(commonRadius),
                    if (isLoading) ThreeBounceLoadingWidget(),
                    if (suggestionList.isNotEmpty)
                      ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          MessagesUsers user = suggestionList[index];

                          return Container(
                            decoration: BoxDecoration(
                              color: context.scaffoldBackgroundColor,
                              border: Border.all(color: context.dividerColor, width: 1),
                              borderRadius: radius(4),
                            ),
                            padding: EdgeInsets.all(4),
                            child: Row(
                              children: [
                                cachedImage(user.avatar, height: 30, width: 30, fit: BoxFit.cover).cornerRadiusWithClipRRect(15),
                                16.width,
                                Text(user.name.validate(), style: secondaryTextStyle()),
                              ],
                            ),
                          ).onTap(() {
                            selectedSuggestionList.add(user);
                            suggestionList.clear();
                            searchController.clear();
                            setState(() {});
                          });
                        },
                        itemCount: suggestionList.length,
                      ),
                    if (selectedSuggestionList.isNotEmpty) Text("${language.participants}: ", style: boldTextStyle(size: 18)).paddingSymmetric(vertical: 16),
                    if (selectedSuggestionList.isNotEmpty)
                      Wrap(
                        children: selectedSuggestionList.map((e) {
                          return Container(
                            decoration: BoxDecoration(
                              color: context.scaffoldBackgroundColor,
                              border: Border.all(color: context.dividerColor, width: 1),
                              borderRadius: radius(4),
                            ),
                            padding: EdgeInsets.all(4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                cachedImage(e.avatar, height: 20, width: 20, fit: BoxFit.cover).cornerRadiusWithClipRRect(10),
                                8.width,
                                Text(e.name.validate(), style: secondaryTextStyle()),
                                8.width,
                                Icon(Icons.cancel_outlined, size: 16, color: appStore.isDarkMode ? bodyDark : bodyWhite).onTap(() {
                                  selectedSuggestionList.remove(e);
                                  setState(() {});
                                }, splashColor: Colors.transparent, hoverColor: Colors.transparent),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    if (selectedSuggestionList.isNotEmpty)
                      appButton(
                        text: language.addParticipants,
                        onTap: () {
                          addParticipantsInChat();
                        },
                        context: context,
                      ).paddingTop(16)
                  ],
                ),
              ),
            ).expand()
          ],
        );
      },
    );
  }
}
