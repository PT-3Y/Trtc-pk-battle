import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/activity_response.dart';
import 'package:socialv/models/groups/group_response.dart';
import 'package:socialv/models/members/member_response.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/search/components/search_group_component.dart';
import 'package:socialv/screens/search/components/search_member_component.dart';
import 'package:socialv/screens/search/components/search_post_component.dart';

import '../../utils/app_constants.dart';

class SearchFragment extends StatefulWidget {
  final ScrollController controller;

  const SearchFragment({required this.controller});

  @override
  State<SearchFragment> createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> with SingleTickerProviderStateMixin {
  List<MemberResponse> memberList = [];
  List<GroupResponse> groupList = [];
  List<ActivityResponse> postList = [];

  List<String> searchOptions = [language.members, language.groups, language.posts];

  TextEditingController searchController = TextEditingController();

  String dropdownValue = '';

  int mPage = 1;
  bool mIsLastPage = false;

  bool hasShowClearTextIcon = false;

  @override
  void initState() {
    super.initState();

    dropdownValue = searchOptions.first;

    widget.controller.addListener(() {
      if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          setState(() {});

          if (dropdownValue == searchOptions.first) {
            getMembersList(text: searchController.text.trim(), page: mPage);
          } else if (dropdownValue == searchOptions[1]) {
            getGroups(text: searchController.text.trim(), page: mPage);
          } else {
            getPosts(text: searchController.text.trim(), page: mPage);
          }
        }
      }
    });

    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        showClearTextIcon();
      } else {
        hasShowClearTextIcon = false;
        setState(() {});
      }
    });
  }

  Future<void> getMembersList({String? text, int page = 1}) async {
    if (text!.isEmpty) {
      memberList.clear();
    } else {
      appStore.setLoading(true);
      await getAllMembers(searchText: text, page: page).then((value) {
        mIsLastPage = value.length != 20;
        if (page == 1) memberList.clear();
        memberList.addAll(value);

        appStore.setLoading(false);
      }).catchError((e) {
        toast(e.toString());
        appStore.setLoading(false);
      });
    }
    setState(() {});
  }

  Future<void> getGroups({String? text, int page = 1}) async {
    if (text!.isEmpty) {
      groupList.clear();
    } else {
      appStore.setLoading(true);

      await getUserGroups(searchText: text, page: page).then((value) {
        mIsLastPage = value.length != 20;
        if (page == 1) groupList.clear();
        groupList.addAll(value);
        appStore.setLoading(false);
      }).catchError((e) {
        toast(e.toString());
        appStore.setLoading(false);
      });
    }
    setState(() {});
  }

  Future<void> getPosts({String? text, int page = 1}) async {
    if (text!.isEmpty) {
      groupList.clear();
    } else {
      appStore.setLoading(true);
      await searchPost(searchText: text, page: page).then((value) {
        if (mPage == 1) postList.clear();
        mIsLastPage = value.length != PER_PAGE;
        postList.addAll(value);
        setState(() {});

        appStore.setLoading(false);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }
  }

  void showClearTextIcon() {
    if (!hasShowClearTextIcon) {
      hasShowClearTextIcon = true;
      setState(() {});
    } else {
      return;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            16.height,
            Row(
              children: [
                Container(
                  width: context.width() * 0.54,
                  margin: EdgeInsets.only(left: 16, right: 8),
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                  child: AppTextField(
                    controller: searchController,
                    onChanged: (val) {
                      if (dropdownValue == searchOptions.first) {
                        getMembersList(text: val);
                      } else if (dropdownValue == searchOptions[1]) {
                        getGroups(text: val);
                      } else {
                        getPosts(text: val);
                      }
                    },
                    textFieldType: TextFieldType.USERNAME,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: language.searchHere,
                      hintStyle: secondaryTextStyle(),
                      prefixIcon: Image.asset(
                        ic_search,
                        height: 16,
                        width: 16,
                        fit: BoxFit.cover,
                        color: appStore.isDarkMode ? bodyDark : bodyWhite,
                      ).paddingAll(16),
                      suffixIcon: hasShowClearTextIcon
                          ? IconButton(
                              icon: Icon(Icons.cancel, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18),
                              onPressed: () {
                                hideKeyboard(context);
                                mPage = 1;
                                memberList.clear();
                                groupList.clear();
                                searchController.clear();
                                hasShowClearTextIcon = false;
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: context.width() * 0.32,
                    margin: EdgeInsets.only(right: 16, left: 8),
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(commonRadius),
                          icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                          elevation: 8,
                          isExpanded: true,
                          style: primaryTextStyle(),
                          onChanged: (String? newValue) {
                            mPage = 1;
                            dropdownValue = newValue.validate();
                            setState(() {});
                            if (newValue == searchOptions.first) {
                              getMembersList(text: searchController.text);
                            } else if (newValue == searchOptions[1]) {
                              getGroups(text: searchController.text);
                            } else {
                              getPosts(text: searchController.text);
                            }
                          },
                          items: searchOptions.validate().map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: primaryTextStyle(), overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          value: dropdownValue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            16.height,
            if (dropdownValue == searchOptions.first)
              SearchMemberComponent(
                memberList: memberList.isEmpty ? appStore.recentMemberSearchList : memberList,
                showRecent: memberList.isEmpty,
                callback: () {
                  setState(() {});
                },
              )
            else if (dropdownValue == searchOptions[1])
              SearchGroupComponent(
                showRecent: groupList.isEmpty,
                groupList: groupList.isEmpty ? appStore.recentGroupsSearchList : groupList,
                callback: () {
                  setState(() {});
                },
              )
            else
              SearchPostComponent(postList: postList),
          ],
        ),
        Positioned(
          bottom: mPage != 1 ? 10 : null,
          child: Observer(
            builder: (_) => SizedBox(
              height: mPage == 1 ? context.height() * 0.5 : null,
              child: LoadingWidget(isBlurBackground: false).center().visible(appStore.isLoading),
            ),
          ),
        )
      ],
    );
  }
}
