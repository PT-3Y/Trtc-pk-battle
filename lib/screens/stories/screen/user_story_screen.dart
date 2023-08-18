import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/file_picker_dialog_component.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/story/highlight_category_list_model.dart';
import 'package:socialv/models/story/highlight_stories_model.dart';
import 'package:socialv/models/story/story_response_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/stories/component/highlight_component.dart';
import 'package:socialv/screens/stories/component/my_story_component.dart';
import 'package:socialv/screens/stories/component/new_story_highlight_dialog.dart';
import 'package:socialv/screens/stories/screen/create_story_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class UserStoryScreen extends StatefulWidget {
  const UserStoryScreen({Key? key}) : super(key: key);

  @override
  State<UserStoryScreen> createState() => _UserStoryScreenState();
}

class _UserStoryScreenState extends State<UserStoryScreen> with SingleTickerProviderStateMixin {
  List<StoryResponseModel> list = [];
  late AnimationController _animationController;
  List<HighlightStoriesModel> highlightList = [];
  String status = StoryHighlightOptions.publish;
  List<HighlightCategoryListModel> categoryList = [];

  int currentValue = 1;
  bool showHighlightStory = false;

  @override
  void initState() {
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 300);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));

    super.initState();
    getStories();
    getCategoryList();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> getCategoryList() async {
    appStore.setLoading(true);
    await getHighlightList().then((value) {
      categoryList = value;
      appStore.setLoading(false);
    }).catchError((e) {
      log(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<void> getStories() async {
    if (showHighlightStory) {
      appStore.setLoading(true);
      highlightList.clear();
      await getHighlightStories(status: status).then((value) {
        highlightList.addAll(value);
        setState(() {});
        appStore.setLoading(false);
      }).catchError((e) {
        log('error : ${e.toString()}');
        appStore.setLoading(false);
      });
    } else {
      appStore.setLoading(true);
      list.clear();
      await getUserStories(userId: appStore.loginUserId.toInt()).then((value) {
        list.addAll(value);
        setState(() {});
        appStore.setLoading(false);
      }).catchError((e) {
        log('error : ${e.toString()}');
        appStore.setLoading(false);
      });
    }
  }

  Future<void> addStory() async {
    if (showHighlightStory) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return NewStoryHighlightDialog(
            highlightList: categoryList.validate(),
            callback: () {
              getStories();
            },
          );
        },
      );
    } else {
      FileTypes? file = await showInDialog(
        context,
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        title: Text(language.chooseAnAction, style: boldTextStyle()),
        builder: (p0) {
          return FilePickerDialog(isSelected: true);
        },
      );

      if (file == FileTypes.CAMERA) {
        await getImageSource(isCamera: true).then((value) {
          appStore.setLoading(false);
          CreateStoryScreen(cameraImage: value).launch(context, duration: 500.milliseconds).then((value) {
            if (value ?? false) {
              getStories();
              LiveStream().emit(GetUserStories);
            }
          });
        }).catchError((e) {
          appStore.setLoading(false);
        });
      } else {
        await getMultipleImages().then((value) {
          appStore.setLoading(false);

          if (value.isNotEmpty)
            CreateStoryScreen(mediaList: value).launch(context, duration: 500.milliseconds).then((value) {
              if (value ?? false) {
                getStories();
                LiveStream().emit(GetUserStories);
              }
            });
        }).catchError((e) {
          appStore.setLoading(false);
        });
      }
    }
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(useMaterial3: false),
            child: PopupMenuButton(
              enabled: !appStore.isLoading,
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
              onSelected: (val) async {
                if (val == 1) {
                  showHighlightStory = false;
                } else if (val == 2) {
                  showHighlightStory = true;
                  status = StoryHighlightOptions.publish;
                } else if (val == 3) {
                  showHighlightStory = true;
                  status = StoryHighlightOptions.draft;
                } else {
                  showHighlightStory = true;
                  status = StoryHighlightOptions.trash;
                }

                currentValue = val.toString().toInt();
                getStories();
              },
              icon: Icon(Icons.more_horiz, color: context.iconColor),
              itemBuilder: (context) => <PopupMenuEntry>[
                if (currentValue != 1)
                  PopupMenuItem(
                    value: 1,
                    child: Text(language.myStories, style: primaryTextStyle()),
                  ),
                if (currentValue != 2 && appStore.showStoryHighlight==1)
                  PopupMenuItem(
                    value: 2,
                    child: Text(language.highlightStories, style: primaryTextStyle()),
                  ),
                if (currentValue != 3 && storyActions.validate().any((element) => element.action == StoryHighlightOptions.trash))
                  PopupMenuItem(
                    value: 3,
                    child: Text(language.draftStories, style: primaryTextStyle()),
                  ),
                if (currentValue != 4 && storyActions.validate().any((element) => element.action == StoryHighlightOptions.trash))
                  PopupMenuItem(
                    value: 4,
                    child: Text(language.trashStories, style: primaryTextStyle()),
                  ),
              ],
            ),
          ),
        ],
        title: Text(language.myStories, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Builder(
        builder: (_) {
          if (showHighlightStory) {
            return HighlightComponent(
              highlightList: highlightList,
              status: status,
              addStory: () {
                addStory();
              },
              callback: () {
                getStories();
              },
            );
          } else {
            return MyStoryComponent(
              animationController: _animationController,
              list: list,
              callback: () {
                getStories();
              },
              addStory: () {
                addStory();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColorPrimary,
        onPressed: () {
          addStory();
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
