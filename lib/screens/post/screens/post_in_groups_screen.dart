import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/groups/group_model.dart';
import 'package:socialv/models/posts/post_in_list_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/gallery/components/create_album_component.dart';
import 'package:socialv/screens/groups/components/initial_no_group_component.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class PostInGroupsScreen extends StatefulWidget {
  const PostInGroupsScreen({Key? key}) : super(key: key);

  @override
  State<PostInGroupsScreen> createState() => _PostInGroupsScreenState();
}

class _PostInGroupsScreenState extends State<PostInGroupsScreen> {
  List<GroupModel> groupList = [];
  late Future<List<GroupModel>> future;
  int? selectedIndex;

  int mPage = 1;
  bool mIsLastPage = false;

  bool isChange = false;
  bool isError = false;

  @override
  void initState() {
    future = getGroups();
    super.initState();
  }

  Future<List<GroupModel>> getGroups() async {
    appStore.setLoading(true);

    await getGroupList(groupType: GroupRequestType.myGroup, page: mPage).then((value) {
      if (mPage == 1) groupList.clear();
      mIsLastPage = value.length != PER_PAGE;
      groupList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return groupList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getGroups();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.selectGroups,
      actions: [
        TextButton(
          onPressed: () {
            if (selectedIndex != null) {
              finish(
                context,
                PostInListModel(title: groupList[selectedIndex.validate()].name, id: groupList[selectedIndex.validate()].id),
              );
            } else {
              finish(context);
            }
          },
          child: Text(language.done.capitalizeFirstLetter(), style: primaryTextStyle(color: context.primaryColor)),
        ),
      ],
      child: FutureBuilder<List<GroupModel>>(
        future: future,
        builder: (ctx, snap) {
          if (snap.hasError) {
            return NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: isError ? language.somethingWentWrong : language.noDataFound,
              onRetry: () {
                onRefresh();
              },
              retryText: '   ${language.clickToRefresh}   ',
            ).center();
          }

          if (snap.hasData) {
            if (snap.data.validate().isEmpty) {
              return InitialNoGroupComponent(callback: onRefresh).center();
            } else {
              return AnimatedListView(
                slideConfiguration: SlideConfiguration(
                  delay: 80.milliseconds,
                  verticalOffset: 300,
                ),
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  GroupModel data = groupList[index];
                  return InkWell(
                    onTap: () {
                      selectedIndex = index;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      color: selectedIndex == index ? context.primaryColor.withAlpha(20) : context.scaffoldBackgroundColor,
                      child: TextIcon(
                        prefix: cachedImage(data.groupAvatarImage.validate(), height: 32, width: 32, fit: BoxFit.cover).cornerRadiusWithClipRRect(16),
                        text: data.name.validate(),
                        textStyle: primaryTextStyle(),
                        spacing: 16,
                        expandedText: true,
                        suffix: selectedIndex == index ? Icon(Icons.check, color: context.primaryColor) : Offstage(),
                      ).paddingSymmetric(vertical: 8),
                    ),
                  );
                },
                onNextPage: () {
                  if (!mIsLastPage) {
                    mPage++;
                    future = getGroups();
                  }
                },
              );
            }
          }
          return Offstage();
        },
      ),
    );
  }
}
