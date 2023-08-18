import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/woo_commerce/common_models.dart';
import 'package:socialv/models/woo_commerce/product_detail_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/shop/components/price_widget.dart';
import 'package:socialv/screens/shop/components/product_card_component.dart';
import 'package:socialv/screens/shop/components/product_review_component.dart';
import 'package:socialv/screens/shop/screens/cart_screen.dart';
import 'package:socialv/screens/shop/screens/shop_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class ProductDetailScreen extends StatefulWidget {
  final int id;

  const ProductDetailScreen({required this.id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

ProductDetailModel product = ProductDetailModel();
ProductDetailModel mainProduct = ProductDetailModel();

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isError = false;
  bool isFetched = false;
  bool isLoading = false;

  bool isWishListed = false;

  PageController pageController = PageController();
  List<GroupProductModel> groupProductList = [];

  int count = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      setStatusBarColor(Colors.transparent);
    });

    appStore.setLoading(true);

    await getProductDetail(productId: widget.id.validate()).then((value) {
      isFetched = true;
      isWishListed = value.first.isAddedWishlist.validate();
      setState(() {});

      value.forEach((element) {
        int index = value.indexOf(element);

        if (index == 0) {
          product = value.first;
          if (value.first.type == ProductTypes.variable) {
            mainProduct = value.first;
            value.first.attributes!.forEach((attribute) {
              attribute.options!.insert(0, '${language.chooseAnOption}');
            });
          }
          setState(() {});
        } else {
          groupProductList.add(GroupProductModel(id: element.id.validate(), product: element));
          setState(() {});
        }
      });
      appStore.setLoading(false);
    }).catchError((e) {
      log('Error: ${e.toString()}');
      isError = true;
      setState(() {});
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          if (isFetched) {
            return Stack(
              children: [
                NestedScrollView(
                  headerSliverBuilder: ((BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: context.height() * 0.5,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: SizedBox(
                            height: context.height() * 0.5,
                            width: context.width(),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                PageView.builder(
                                  controller: pageController,
                                  itemCount: product.images.validate().length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return cachedImage(
                                      product.images![index].src.validate(),
                                      height: context.height() * 0.5,
                                      width: context.width(),
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 76,
                                  right: 16,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(4)),
                                    child: Text(language.sale, style: secondaryTextStyle(size: 10, color: Colors.white)),
                                  ).visible(product.onSale.validate()),
                                ),
                                Positioned(
                                  bottom: 8,
                                  child: DotIndicator(
                                    indicatorColor: context.primaryColor,
                                    pageController: pageController,
                                    pages: product.images.validate(),
                                  ),
                                ).visible(product.images.validate().length > 1),
                              ],
                            ),
                          ),
                          collapseMode: CollapseMode.parallax,
                        ),
                        backgroundColor: context.scaffoldBackgroundColor,
                        leading: BackButton(
                          color: context.iconColor,
                          onPressed: () async {
                            finish(context);
                          },
                        ),
                        title: Text(product.name.validate().capitalizeFirstLetter(), style: boldTextStyle(size: 22)).visible(innerBoxIsScrolled),
                        actions: [
                          IconButton(
                            onPressed: () {
                              CartScreen().launch(context);
                            },
                            icon: Image.asset(ic_cart, width: 24, height: 24, color: context.primaryColor, fit: BoxFit.cover),
                          ).visible(innerBoxIsScrolled),
                        ],
                      ),
                    ];
                  }),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name.validate().capitalizeFirstLetter(), style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16, vertical: 8),
                        PriceWidget(
                          price: product.price,
                          priceHtml: product.priceHtml,
                          salePrice: product.salePrice,
                          regularPrice: product.regularPrice,
                          showDiscountPercentage: true,
                          size: 16,
                        ).paddingSymmetric(horizontal: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBarWidget(
                              onRatingChanged: (rating) {
                                //
                              },
                              activeColor: Colors.amber,
                              inActiveColor: Colors.amber,
                              rating: product.averageRating.validate().toDouble(),
                              size: 18,
                              disable: true,
                            ),
                            16.width,
                            Text('(${product.ratingCount} ${language.reviews.toLowerCase()})', style: secondaryTextStyle(color: context.primaryColor)),
                          ],
                        ).paddingOnly(left: 16, right: 16, top: 8).visible(product.averageRating.validate().toDouble() != 0.0),
                        16.height,
                        if (product.shortDescription.validate().isNotEmpty) Text(parseHtmlString(product.shortDescription), style: secondaryTextStyle()).paddingSymmetric(horizontal: 16),
                        if (mainProduct.type == ProductTypes.variable)
                          Column(
                            children: mainProduct.attributes.validate().map((e) {
                              return Row(
                                children: [
                                  Text(e.name.validate(), style: boldTextStyle()),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          borderRadius: BorderRadius.circular(commonRadius),
                                          icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                          elevation: 8,
                                          style: primaryTextStyle(),
                                          underline: Container(height: 2, color: appColorPrimary),
                                          onChanged: (String? newValue) {
                                            /// variation logic
                                            e.dropDownValue = newValue!;

                                            if (newValue == 'Choose an option') {
                                              product = mainProduct;
                                            } else {
                                              groupProductList.forEach((element) {
                                                log('element: $element');

                                                element.product.attributes.validate().forEach((attribute) {
                                                  if (attribute.optionString == newValue) {
                                                    product = element.product;
                                                  }
                                                });
                                              });
                                            }

                                            setState(() {});
                                          },
                                          hint: Text(language.chooseAnOption, style: secondaryTextStyle()),
                                          items: e.options.validate().map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value, style: primaryTextStyle()),
                                            );
                                          }).toList(),
                                          value: e.dropDownValue,
                                        ),
                                      ),
                                    ),
                                  ).expand(),
                                ],
                              );
                            }).toList(),
                          ).paddingSymmetric(horizontal: 16),
                        if (product.type.validate() != ProductTypes.grouped)
                          Row(
                            children: [
                              Text('${language.qty}: ', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 12)),
                              Icon(
                                Icons.remove,
                                color: appStore.isDarkMode ? bodyDark : bodyWhite,
                                size: 18,
                              ).paddingOnly(left: 8, right: 6, top: 8, bottom: 8).onTap(() {
                                if (count > 0) {
                                  count = count - 1;
                                  setState(() {});
                                }
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                margin: EdgeInsets.only(top: 8, bottom: 8),
                                decoration: BoxDecoration(borderRadius: radius(4), border: Border.all(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                                child: Text(count.toString(), style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 12)),
                              ),
                              Icon(
                                Icons.add,
                                color: appStore.isDarkMode ? bodyDark : bodyWhite,
                                size: 18,
                              ).paddingOnly(left: 6, right: 12, top: 8, bottom: 8).onTap(() {
                                count = count + 1;
                                setState(() {});
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                            ],
                          ).paddingSymmetric(horizontal: 16),
                        RichText(
                          text: TextSpan(
                            text: '${language.sku}:',
                            style: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' ${product.sku}',
                                style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ).paddingOnly(top: 16, left: 16, right: 16),
                        if (product.categories.validate().isNotEmpty)
                          Row(
                            children: [
                              Text('${language.category}: ', style: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 14)),
                              Wrap(
                                  children: product.categories!.map((e) {
                                return Text(e.name.validate(), style: primaryTextStyle(color: context.primaryColor, size: 14)).onTap(() {
                                  ShopScreen(categoryName: e.name, categoryId: e.id).launch(context);
                                });
                              }).toList()),
                            ],
                          ).paddingSymmetric(horizontal: 16),
                        16.height,
                        if (groupProductList.validate().isNotEmpty && product.type == ProductTypes.grouped)
                          Column(
                            children: groupProductList.map((e) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  cachedImage(
                                    e.product.images!.first.src.validate(),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(commonRadius),
                                  16.width,
                                  Text(e.product.name.validate(), style: primaryTextStyle(size: 14), overflow: TextOverflow.ellipsis, maxLines: 1).expand(),
                                  PriceWidget(
                                    price: e.product.price,
                                    priceHtml: e.product.priceHtml,
                                    salePrice: e.product.salePrice,
                                    regularPrice: e.product.regularPrice,
                                    showDiscountPercentage: false,
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 16, vertical: 6).onTap(() {
                                ProductDetailScreen(id: e.id).launch(context);
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
                            }).toList(),
                          ),
                        24.height,
                        Text(language.description, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
                        16.height,
                        ReadMoreText(
                          parseHtmlString(product.description),
                          style: secondaryTextStyle(),
                          trimLines: 5,
                          textAlign: TextAlign.start,
                        ).paddingSymmetric(horizontal: 16),
                        16.height,
                        if (product.attributes.validate().isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.additionalInformation, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
                              Table(
                                columnWidths: {
                                  0: FractionColumnWidth(0.3),
                                  1: FractionColumnWidth(0.7),
                                },
                                border: TableBorder.all(
                                  color: appStore.isDarkMode ? bodyDark.withOpacity(0.2) : bodyWhite.withOpacity(0.2),
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                                children: product.attributes.validate().map((e) {
                                  return TableRow(
                                    children: [
                                      Text(
                                        e.name.validate(),
                                        style: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 14),
                                        textAlign: TextAlign.center,
                                      ).paddingSymmetric(vertical: 8),
                                      product.type == ProductTypes.variation
                                          ? Text(e.optionString.validate(), style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)).paddingAll(8)
                                          : Wrap(
                                              children: e.options.validate().map((option) {
                                                if (option != 'Choose an option') {
                                                  return Text(
                                                    option.validate(),
                                                    style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                                  ).paddingAll(8);
                                                } else {
                                                  return Offstage();
                                                }
                                              }).toList(),
                                            ),
                                    ],
                                  );
                                }).toList(),
                              ).paddingAll(16),
                              8.height,
                            ],
                          ),
                        ProductReviewComponent(productId: widget.id),
                        if (product.relatedIds.validate().isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              16.height,
                              Text(language.relatedProducts, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 18),
                              8.height,
                              ThreeBounceLoadingWidget().paddingSymmetric(vertical: 16).visible(isLoading),
                              HorizontalList(
                                padding: EdgeInsets.all(16),
                                spacing: 16,
                                itemCount: product.relatedProductList!.length,
                                itemBuilder: (ctx, index) {
                                  return RelatedProductCardComponent(product: product.relatedProductList![index]);
                                },
                              ).visible(!isLoading),
                            ],
                          ),
                        32.height,
                      ],
                    ),
                  ),
                ),
                LoadingWidget().center().visible(appStore.isLoading),
              ],
            );
          } else if (isError) {
            return NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: isError ? language.somethingWentWrong : language.noDataFound,
            ).center();
          } else {
            return LoadingWidget().center();
          }
        },
      ),
      bottomNavigationBar: isFetched && product.type != ProductTypes.variable
          ? Container(
              color: context.cardColor,
              padding: EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (isWishListed) {
                        isWishListed = !isWishListed;
                        setState(() {});

                        toast(language.removedFromWishlist);

                        removeFromWishlist(productId: product.id.validate()).then((value) {
                          //
                        }).catchError((e) {
                          isWishListed = true;
                          setState(() {});

                          log(e.toString());
                        });
                      } else {
                        isWishListed = !isWishListed;
                        setState(() {});

                        toast(language.addedToWishlist);

                        addToWishlist(productId: product.id.validate()).then((value) {
                          //
                        }).catchError((e) {
                          isWishListed = false;
                          setState(() {});
                          log(e.toString());
                        });
                      }
                    },
                    icon: Image.asset(
                      isWishListed ? ic_heart_filled : ic_heart,
                      height: 22,
                      width: 22,
                      color: context.primaryColor,
                      fit: BoxFit.fill,
                    ),
                  ),
                  16.width.visible(product.type != ProductTypes.grouped),
                  AppButton(
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(0)),
                    child: TextIcon(
                      text: product.isAddedCart.validate()
                          ? language.goToCart
                          : product.inStock.validate()
                              ? language.addToCart
                              : language.outOfStock,
                      textStyle: boldTextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    onTap: () async {
                      if (count == 0) {
                        toast(language.yourQtyShouldNotBeEmpty);
                      } else {
                        if (product.isAddedCart.validate()) {
                          CartScreen().launch(context).then((_) => setState(() {}));
                        } else {
                          if (product.inStock.validate()) {
                            appStore.setLoading(true);
                            addItemToCart(productId: product.id.validate(), quantity: count).then((value) {
                              toast(language.successfullyAddedToCart);
                              appStore.setLoading(false);
                              product.isAddedCart = true;
                              setState(() {});
                            }).catchError((e) {
                              appStore.setLoading(false);
                              toast(e.toString(), print: true);
                            });
                          }
                        }
                      }
                    },
                    elevation: 0,
                    color: product.inStock.validate() ? context.primaryColor : Colors.grey.withOpacity(0.5),
                  ).expand().visible(product.type != ProductTypes.grouped),
                ],
              ),
            )
          : Offstage(),
    );
  }
}
