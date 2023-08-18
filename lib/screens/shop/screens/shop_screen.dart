import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/models/woo_commerce/category_model.dart';
import 'package:socialv/models/woo_commerce/product_list_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/shop/components/product_card_component.dart';
import 'package:socialv/screens/shop/screens/wishlist_screen.dart';

import '../../../utils/app_constants.dart';
import '../components/cached_image_widget.dart';
import '../components/sort_by_bottom_sheet.dart';
import 'cart_screen.dart';

class ShopScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const ShopScreen({this.categoryId, this.categoryName});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ScrollController _scrollController = ScrollController();

  List<ProductListModel> productList = [];
  List<CategoryModel> categoryList = [];
  late Future<List<ProductListModel>> future;

  List<FilterModel> filterOptions = getProductFilters();

  TextEditingController searchCont = TextEditingController();

  FilterModel? dropDownValue;
  CategoryModel? selectedCategory;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getProducts(categoryId: widget.categoryId != null ? widget.categoryId.validate() : null);
    super.initState();

    _scrollController.addListener(() {
      /// scroll down
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (appStore.showShopBottom) appStore.setShopBottom(false);
      }

      /// scroll up
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!appStore.showShopBottom) appStore.setShopBottom(true);
      }

      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          setState(() {});
          appStore.setLoading(true);
          future = getProducts(categoryId: widget.categoryId != null ? widget.categoryId.validate() : null);
        }
      }
    });

    getCategories();

    LiveStream().on(STREAM_FILTER_ORDER_BY, (p0) {
      mPage = 1;
      FilterModel filterModel = p0 as FilterModel;

      future = getProducts(orderBy: filterModel.value);
      setState(() {});
    });

    afterBuildCreated(() async {
      appStore.setShopBottom(true);
    });
  }

  Future<List<ProductListModel>> getProducts({String? orderBy, int? categoryId}) async {
    if (mPage == 1) productList.clear();
    appStore.setLoading(true);

    await getProductsList(page: mPage, categoryId: categoryId, orderBy: orderBy == null ? ProductFilters.date : orderBy, searchText: searchCont.text).then((value) {
      mIsLastPage = value.length != PER_PAGE;
      productList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return productList;
  }

  Future<void> getCategories() async {
    await getCategoryList().then((value) {
      categoryList.add(CategoryModel(name: 'All', id: -1));

      categoryList.addAll(value);
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getProducts(categoryId: widget.categoryId != null ? widget.categoryId.validate() : null);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    appStore.setLoading(false);
    LiveStream().dispose(STREAM_FILTER_ORDER_BY);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      color: context.primaryColor,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
          titleSpacing: 0,
          title: Text(widget.categoryName != null ? widget.categoryName.validate() : language.shop, style: boldTextStyle(size: 22)),
          elevation: 0,
          centerTitle: true,
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    WishlistScreen().launch(context);
                  },
                  icon: Image.asset(ic_heart, height: 22, width: 22, color: context.primaryColor, fit: BoxFit.fill),
                ),
                IconButton(
                  onPressed: () {
                    CartScreen().launch(context);
                  },
                  icon: Image.asset(ic_cart, height: 24, width: 24, color: context.primaryColor, fit: BoxFit.cover),
                ),
                16.width,
              ],
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            FutureBuilder<List<ProductListModel>>(
              future: future,
              builder: (ctx, snap) {
                if (snap.hasError && !appStore.isLoading) {
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
                  if (snap.data.validate().isEmpty && !appStore.isLoading) {
                    return NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                      onRetry: () {
                        onRefresh();
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ).center();
                  } else {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60),
                      controller: _scrollController,
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            suffix: searchCont.text.isNotEmpty
                                ? CloseButton(
                                    color: context.primaryColor,
                                    onPressed: () {
                                      searchCont.clear();
                                      hideKeyboard(context);

                                      mPage = 1;
                                      onRefresh();
                                    })
                                : null,
                            textFieldType: TextFieldType.OTHER,
                            controller: searchCont,
                            onChanged: (s) async {
                              if (s.isEmpty) {
                                hideKeyboard(context);
                                mPage = 1;

                                categoryList.clear();
                                onRefresh();
                                setState(() {});
                                return await 2.seconds.delay;
                              }
                            },
                            onFieldSubmitted: (s) async {
                              onRefresh();
                            },
                            decoration: InputDecoration(
                              hintText: language.searchHere,
                              prefixIcon: Icon(Icons.search, color: context.iconColor, size: 20),
                              hintStyle: secondaryTextStyle(),
                              border: OutlineInputBorder(
                                borderRadius: radius(),
                                borderSide: BorderSide(width: 0, style: BorderStyle.none),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(16),
                              fillColor: context.cardColor,
                            ),
                          ).paddingSymmetric(horizontal: 16),
                          16.height,
                          HorizontalList(
                            itemCount: categoryList.length,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              CategoryModel item = categoryList[index];

                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: item.isSelected.validate() ? context.primaryColor : context.cardColor,
                                  borderRadius: BorderRadius.all(radiusCircular()),
                                ),
                                child: Row(
                                  children: [
                                    if (item.image != null)
                                      CachedImageWidget(
                                        url: item.image!.src.validate(),
                                        fit: BoxFit.cover,
                                        width: 14,
                                        height: 14,
                                        circle: true,
                                      ),
                                    Text(item.name.validate(), style: boldTextStyle(size: 14, color: item.isSelected.validate() ? context.cardColor : context.primaryColor), maxLines: 1),
                                  ],
                                ),
                              ).onTap(
                                () {
                                  categoryList.forEach((element) {
                                    element.isSelected = false;
                                  });
                                  item.isSelected = true;
                                  mPage = 1;
                                  selectedCategory = item;

                                  if (item.id == -1) {
                                    future = getProducts();
                                  } else {
                                    future = getProducts(categoryId: selectedCategory!.id.validate());
                                  }

                                  setState(() {});
                                },
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              );
                            },
                          ),
                          16.height,
                          AnimatedWrap(
                            alignment: WrapAlignment.start,
                            itemCount: productList.length,
                            spacing: 16,
                            runSpacing: 16,
                            slideConfiguration: SlideConfiguration(delay: 120.milliseconds),
                            itemBuilder: (ctx, index) {
                              return ProductCardComponent(product: productList[index]);
                            },
                          ).paddingSymmetric(horizontal: 16),
                          16.height,
                        ],
                      ),
                    );
                  }
                }
                return LoadingWidget().visible(!appStore.isLoading);
              },
            ),
            Positioned(
              bottom: mPage != 1 ? context.navigationBarHeight + 8 : null,
              child: Observer(builder: (context) {
                return LoadingWidget(isBlurBackground: mPage == 1 ? true : false).visible(appStore.isLoading);
              }),
            ),
          ],
        ),
        floatingActionButton: Observer(
          builder: (_) => AnimatedSlide(
            offset: appStore.showShopBottom ? Offset.zero : Offset(0, 1),
            duration: Duration(milliseconds: 350),
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: boxDecorationDefault(color: context.primaryColor, borderRadius: radius(8)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextIcon(
                    text: language.sortBy,
                    textStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : Colors.white, size: 12),
                    prefix: Image.asset(ic_sort_by, height: 18, width: 18, color: appStore.isDarkMode ? bodyDark : Colors.white, fit: BoxFit.cover),
                    onTap: () async {
                      FilterModel? data = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
                        builder: (_) {
                          return SortByBottomSheet(getProductFilters());
                        },
                      );

                      if (data != null) {
                        LiveStream().emit(STREAM_FILTER_ORDER_BY, data);
                        //getProducts(orderBy: data.value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
