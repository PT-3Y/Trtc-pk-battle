import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/file_picker_dialog_component.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/models/common_models/post_mdeia_model.dart';
import 'package:socialv/models/members/member_response.dart';
import 'package:socialv/models/posts/media_model.dart';
import 'package:socialv/models/posts/post_in_list_model.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/post/components/add_post_media_component.dart';
import 'package:socialv/screens/post/components/edit_post_media_component.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:socialv/screens/post/components/show_selected_media_component.dart';
import 'package:socialv/screens/post/screens/post_in_groups_screen.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/cached_network_image.dart';

// ignore: must_be_immutable
class AddPostScreen extends StatefulWidget {
  final String? component;
  final String? groupName;
  final int? groupId;
  PostModel? post;
  final VoidCallback? callback;
  final bool showMediaOptions;
  final String? parentPostId;

  AddPostScreen({this.component, this.post, this.callback, this.showMediaOptions = true, this.parentPostId, this.groupName, this.groupId});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<PostMedia> mediaList = [];
  List<PostMediaModel> postMedia = [];

  MediaModel? selectedMedia;

  GiphyGif? gif;

  List<MediaModel> mediaTypeList = [];
  List<PostInListModel> postInList = [];
  bool enableSelectMedia = true;
  List<MemberResponse> mentionsMemberList = [];
  List<Map<String, dynamic>> userNameForMention = [];
  PostInListModel dropdownValue = PostInListModel();
  GlobalKey<FlutterMentionsState> postContentTextKey = GlobalKey<FlutterMentionsState>();

  @override
  void initState() {
    super.initState();
    getMentionsMembers();
    afterBuildCreated(() async {
      setStatusBarColor(context.cardColor);
      if (widget.showMediaOptions.validate()) {
        await getMediaList();
      }
      await postIn();
      init();
    });
  }

  Future<void> init() async {
    if (widget.post != null) {
      if (mediaTypeList.isNotEmpty && widget.post!.mediaType != null) {
        selectedMedia = mediaTypeList.firstWhere((element) => element.type == widget.post!.mediaType);
        enableSelectMedia = false;
      } else {
        enableSelectMedia = true;
      }

      if (widget.post!.medias.validate().isNotEmpty) {
        postMedia.addAll(widget.post!.medias.validate());
      }

      postContentTextKey.currentState!.controller!.text = parseHtmlString(widget.post!.content.validate());
      setState(() {});
    }
  }

  Future<void> getMediaList() async {
    appStore.setLoading(true);
    await getMediaTypes(type: widget.component.validate()).then((value) {
      mediaTypeList.addAll(value);

      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
    setState(() {});
  }

  Future<void> postIn() async {
    postInList.add(PostInListModel(id: 0, title: language.myProfile));
    postInList.add(PostInListModel(title: language.selectGroups));

    if (widget.groupId != null && widget.parentPostId == null) {
      postInList.insert(postInList.length - 1, PostInListModel(id: widget.groupId, title: widget.groupName));
      dropdownValue = postInList.firstWhere((element) => element.id == widget.groupId.validate());
    } else {
      dropdownValue = postInList.first;
    }

    setState(() {});
  }

  Future<void> onSelectMedia() async {
    FileTypes? file = await showInDialog(
      context,
      contentPadding: EdgeInsets.symmetric(vertical: 16),
      title: Text(language.chooseAnAction, style: boldTextStyle()),
      builder: (p0) {
        return FilePickerDialog(isSelected: true);
      },
    );

    if (file != null) {
      if (file == FileTypes.CAMERA) {
        appStore.setLoading(true);
        await getImageSource(isCamera: true, isVideo: selectedMedia!.type == MediaTypes.video).then((value) {
          appStore.setLoading(false);
          mediaList.add(PostMedia(file: value));
          setState(() {});
        }).catchError((e) {
          log('Error: ${e.toString()}');
          appStore.setLoading(false);
        });
      } else {
        appStore.setLoading(true);

        getMultipleFiles(mediaType: selectedMedia!).then((value) {
          value.forEach((element) {
            mediaList.add(PostMedia(file: element));
          });
        }).catchError((e) {
          log('Error: ${e.toString()}');
        }).whenComplete(() {
          setState(() {});
          appStore.setLoading(false);
        });
        log('MediaList: ${mediaList.length}');
      }
    }
  }

  Future<List<MemberResponse>> getMentionsMembers({String? mentionText}) async {
    await getAllMembers(searchText: mentionText).then((value) {
      mentionsMemberList = value;
      mentionsMemberList.forEach((element) {
        userNameForMention.add({"full_name": element.name, "display": element.userLogin, "photo": element.avatarUrls!.full});
      });
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
    return mentionsMemberList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    setStatusBarColorBasedOnTheme();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        title: Text(widget.post != null ? language.editPost : language.newPost, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
        actions: [
          AppButton(
            enabled: true,
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
            text: widget.post != null ? language.edit : language.post,
            textStyle: primaryTextStyle(color: Colors.white, size: 12),
            onTap: () async {
              hideKeyboard(context);
              ifNotTester(() async {
                if (mediaList.isEmpty && postContentTextKey.currentState!.controller!.text.isEmpty && gif == null) {
                  toast(language.addPostContent);
                } else {
                  appStore.setLoading(true);
                  await uploadPost(
                    id: widget.post != null ? widget.post!.activityId : null,
                    postMedia: mediaList,
                    content: postContentTextKey.currentState!.controller!.text.replaceAll("\n", "</br>"),
                    mediaType: selectedMedia != null ? selectedMedia!.type : null,
                    isMedia: selectedMedia == null ? false : true,
                    postIn: dropdownValue.id.validate().toString(),
                    gif: gif != null ? gif!.images!.original!.url.validate() : null,
                    parentPostId: widget.parentPostId,
                    type: widget.parentPostId != null ? PostActivityType.activityShare : null,
                    mediaId: gif != null ? gif!.id.validate() : "",
                  ).then((value) async {
                    appStore.setLoading(false);
                    LiveStream().emit(OnAddPost);
                    if (widget.parentPostId.validate().isEmpty) LiveStream().emit(OnAddPostProfile);
                    widget.callback?.call();
                    finish(context, true);
                  }).catchError((e) {
                    toast(language.somethingWentWrong, print: true);
                    appStore.setLoading(false);
                  });
                }
              });
            },
            color: context.primaryColor,
            width: 60,
            padding: EdgeInsets.all(0),
            elevation: 0,
          ).paddingSymmetric(horizontal: 16, vertical: 12),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showMediaOptions.validate())
                  Container(
                    width: context.width(),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(borderRadius: radius(), color: context.scaffoldBackgroundColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: mediaTypeList.map((e) {
                        if (e.isActive.validate()) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: selectedMedia == e ? context.primaryColor : Colors.transparent,
                              borderRadius: radius(defaultRadius),
                            ),
                            child: Text(
                              e.title.validate(),
                              style: boldTextStyle(size: 12, color: selectedMedia == e ? white : Colors.grey.shade500),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ).onTap(() {
                            if (enableSelectMedia && e.isActive.validate()) {
                              mediaList.clear();
                              selectedMedia = e;

                              if (e.type == MediaTypes.gif) {
                                selectGif(context: context).then((value) {
                                  if (value != null) {
                                    gif = value;
                                    setState(() {});
                                    log('Gif Url: ${gif!.images!.original!.url.validate()}');
                                  }
                                });
                              }

                              setState(() {});
                            } else {
                              toast(language.youCanNotSelect);
                            }
                          }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand();
                        } else {
                          return Offstage();
                        }
                      }).toList(),
                    ),
                  ),
                FlutterMentions(
                  key: postContentTextKey,
                  suggestionPosition: SuggestionPosition.Top,
                  maxLines: 10,
                  decoration: inputDecorationFilled(
                    context,
                    fillColor: context.scaffoldBackgroundColor,
                    label: language.whatsOnYourMind,
                  ),
                  suggestionListDecoration: BoxDecoration(color: context.cardColor, border: Border.all(color: context.dividerColor)),
                  mentions: [
                    Mention(
                      trigger: "@",
                      matchAll: true,
                      data: userNameForMention,
                      suggestionBuilder: (data) {
                        return Container(
                          constraints: BoxConstraints(maxHeight: 200),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                          child: Row(
                            children: [
                              Text('@' + data["display"], style: boldTextStyle(size: 14, color: context.primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                              TextIcon(
                                text: data["full_name"],
                                textStyle: secondaryTextStyle(),
                                suffix: cachedImage(data["photo"], height: 20, width: 20, fit: BoxFit.cover).cornerRadiusWithClipRRect(4),
                                maxLine: 1,
                                expandedText: true,
                              ).expand(),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16, vertical: 8),
                if (selectedMedia != null && selectedMedia!.type != MediaTypes.gif)
                  AddPostMediaComponent(
                    enableSelectMedia: enableSelectMedia,
                    selectedMedia: selectedMedia!,
                    onSelectMedia: () {
                      onSelectMedia();
                    },
                    mediaListAdd: () async {
                      appStore.setLoading(true);
                      getMultipleFiles(mediaType: selectedMedia!).then((value) {
                        value.forEach((element) {
                          mediaList.add(PostMedia(file: element));
                        });
                      }).catchError((e) {
                        log('Error: ${e.toString()}');
                      });

                      setState(() {});
                      log('MediaList: ${mediaList.length}');
                    },
                    clearMediaList: () {
                      mediaList.clear();
                      selectedMedia = null;
                      setState(() {});
                    },
                    linkListAdd: (link) {
                      if (link.isNotEmpty) {
                        mediaList.add(PostMedia(isLink: true, link: link));
                      } else {
                        toast(language.enterValidUrl);
                      }
                      FocusScope.of(context).unfocus();
                    },
                  ).paddingAll(16),
                if (mediaList.isNotEmpty)
                  ShowSelectedMediaComponent(
                    mediaList: mediaList,
                    mediaType: selectedMedia!,
                    videoController: List.generate(
                      mediaList.length,
                      (index) {
                        PostMedia media = mediaList[index];
                        if (media.isLink)
                          return VideoPlayerController.network(mediaList[index].link.validate());
                        else
                          return VideoPlayerController.network(mediaList[index].file!.path.validate());
                      },
                    ),
                  ),
                if (postMedia.isNotEmpty)
                  EditPostMediaComponent(
                    mediaList: postMedia,
                    mediaType: selectedMedia!,
                    callback: () {
                      enableSelectMedia = true;
                      setState(() {});
                    },
                  ),
                if (gif != null)
                  Stack(
                    children: [
                      Loader(),
                      Image.network(
                        gif!.images!.original!.url.validate(),
                        headers: {'accept': 'image/*'},
                        width: context.width() - 32,
                        fit: BoxFit.fitWidth,
                      ).cornerRadiusWithClipRRect(defaultAppButtonRadius),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            gif = null;
                            setState(() {});
                          },
                          icon: Icon(Icons.cancel_outlined, color: context.primaryColor),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.postIn, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
                    if (dropdownValue.id != null)
                      Container(
                        height: 40,
                        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<PostInListModel>(
                              borderRadius: BorderRadius.circular(commonRadius),
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                              elevation: 8,
                              isExpanded: true,
                              style: primaryTextStyle(),
                              underline: Container(height: 2, color: appColorPrimary),
                              alignment: Alignment.bottomCenter,
                              onChanged: (PostInListModel? newValue) {
                                if (newValue!.id == null) {
                                  PostInGroupsScreen().launch(context).then((value) {
                                    if (value != null) {
                                      dropdownValue = value;
                                      postInList.insert(postInList.length - 1, value);
                                      setState(() {});
                                    }
                                  });
                                } else {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                }
                              },
                              items: postInList.map<DropdownMenuItem<PostInListModel>>((e) {
                                return DropdownMenuItem<PostInListModel>(
                                  value: e,
                                  child: Text('${e.title.validate()}', overflow: TextOverflow.ellipsis, maxLines: 1),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ).expand(),
                  ],
                ),
                50.height,
              ],
            ),
          ),
          Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
