import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/blog/screens/blog_list_screen.dart';
import 'package:socialv/screens/forums/screens/my_forums_screen.dart';
import 'package:socialv/screens/groups/screens/group_screen.dart';
import 'package:socialv/screens/lms/screens/course_list_screen.dart';
import 'package:socialv/screens/messages/components/friends_tab_component.dart';
import 'package:socialv/screens/messages/components/group_tab_component.dart';
import 'package:socialv/screens/messages/components/messages_tab_component.dart';
import 'package:socialv/screens/profile/screens/profile_friends_screen.dart';
import 'package:socialv/screens/settings/screens/settings_screen.dart';
import 'package:socialv/screens/shop/screens/cart_screen.dart';
import 'package:socialv/screens/shop/screens/orders_screen.dart';
import 'package:socialv/screens/shop/screens/shop_screen.dart';
import 'package:socialv/screens/shop/screens/wishlist_screen.dart';
import 'package:socialv/screens/stories/screen/user_story_screen.dart';

import '../screens/lms/screens/cource_orders_screen.dart';
import '../utils/app_constants.dart';

class DrawerModel {
  String? title;
  String? image;
  Widget? attachedScreen;
  bool isNew;

  DrawerModel({this.image, this.title, this.attachedScreen, this.isNew = false});
}

List<DrawerModel> getDrawerOptions() {
  List<DrawerModel> list = [];

  list.add(DrawerModel(image: ic_story, title: language.myStories, attachedScreen: UserStoryScreen()));
  list.add(DrawerModel(image: ic_two_user, title: language.friends, attachedScreen: ProfileFriendsScreen()));
  list.add(DrawerModel(image: ic_three_user, title: language.groups, attachedScreen: GroupScreen()));
  list.add(DrawerModel(image: ic_document, title: language.forums, attachedScreen: MyForumsScreen()));
  list.add(DrawerModel(image: ic_blog, title: language.blogs, attachedScreen: BlogListScreen()));
  if (appStore.isLMSEnable == 1 && appStore.isCourseEnable == 1) {
    list.add(DrawerModel(image: ic_book, title: language.courses, attachedScreen: CourseListScreen()));
    list.add(DrawerModel(image: ic_books, title: language.courseOrders, attachedScreen: CourseOrdersScreen()));
  }

  if (appStore.showWoocommerce == 1 && appStore.isShopEnable == 1) {
    list.add(DrawerModel(image: ic_store, title: language.shop, attachedScreen: ShopScreen()));
    list.add(DrawerModel(image: ic_buy, title: language.cart, attachedScreen: CartScreen(isFromHome: true)));
    list.add(DrawerModel(image: ic_heart, title: language.wishlist, attachedScreen: WishlistScreen()));
    list.add(DrawerModel(image: ic_bag, title: language.myOrders, attachedScreen: OrdersScreen()));
  }

  list.add(DrawerModel(image: ic_setting, title: language.settings, attachedScreen: SettingsScreen()));

  return list;
}

List<DrawerModel> getCourseTabs() {
  List<DrawerModel> list = [];

  list.add(DrawerModel(title: language.theCourseIncludes));
  list.add(DrawerModel(title: language.overview));
  list.add(DrawerModel(title: language.curriculum));
  list.add(DrawerModel(title: language.instructor));
  list.add(DrawerModel(title: language.faqs));
  list.add(DrawerModel(title: language.reviews));

  return list;
}

List<DrawerModel> messageTabs() {
  List<DrawerModel> list = [];
  list.add(DrawerModel(title: language.messages, image: ic_chat, attachedScreen: MessagesTabComponent()));
  list.add(DrawerModel(title: language.friends, image: ic_two_user, attachedScreen: FriendsTabComponent()));
  list.add(DrawerModel(title: language.groups, image: ic_three_user, attachedScreen: GroupTabComponent()));

  return list;
}

class FilterModel {
  String? title;
  String? value;

  FilterModel({this.value, this.title});
}

List<FilterModel> getProductFilters() {
  List<FilterModel> list = [];

  list.add(FilterModel(value: ProductFilters.date, title: language.latest));
  list.add(FilterModel(value: ProductFilters.rating, title: language.averageRating));
  list.add(FilterModel(value: ProductFilters.popularity, title: language.popularity));
  list.add(FilterModel(value: ProductFilters.price, title: language.price));

  return list;
}

List<FilterModel> getOrderStatus() {
  List<FilterModel> list = [];

  list.add(FilterModel(value: OrderStatus.any, title: language.any));
  list.add(FilterModel(value: OrderStatus.pending, title: language.pending));
  list.add(FilterModel(value: OrderStatus.processing, title: language.processing));
  list.add(FilterModel(value: OrderStatus.onHold, title: language.onHold));
  list.add(FilterModel(value: OrderStatus.completed, title: language.completed));
  list.add(FilterModel(value: OrderStatus.cancelled, title: language.cancelled));
  list.add(FilterModel(value: OrderStatus.refunded, title: language.refunded));
  list.add(FilterModel(value: OrderStatus.failed, title: language.failed));
  list.add(FilterModel(value: OrderStatus.trash, title: language.trash));

  return list;
}

class PostMedia {
  File? file;
  String? link;
  bool isLink;

  PostMedia({this.file, this.link, this.isLink = false});
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', subTitle: 'English', languageCode: 'en', fullLanguageCode: 'en_en-US', flag: 'assets/demo/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', subTitle: 'हिंदी', languageCode: 'hi', fullLanguageCode: 'hi_hi-IN', flag: 'assets/demo/flag/ic_hi.png'),
    LanguageDataModel(id: 3, name: 'Arabic', subTitle: 'عربي', languageCode: 'ar', fullLanguageCode: 'ar_ar-AR', flag: 'assets/demo/flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'French', subTitle: 'français', languageCode: 'fr', fullLanguageCode: 'fr_fr-FR', flag: 'assets/demo/flag/ic_fr.png'),
    LanguageDataModel(id: 5, name: 'Spanish', subTitle: 'español', languageCode: 'es', fullLanguageCode: 'es_es-ES', flag: 'assets/demo/flag/ic_es.png'),
    LanguageDataModel(id: 6, name: 'German', subTitle: 'Deutsch', languageCode: 'de', fullLanguageCode: 'de_de-De', flag: 'assets/demo/flag/ic_de.png'),
    LanguageDataModel(id: 6, name: 'Portuguese', subTitle: 'Português', languageCode: 'pt', fullLanguageCode: 'pt_pt-PT', flag: 'assets/demo/flag/ic_pt.jpg'),
  ];
}
