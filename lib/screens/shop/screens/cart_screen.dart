import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/woo_commerce/cart_item_model.dart';
import 'package:socialv/models/woo_commerce/cart_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/shop/components/cart_coupons_component.dart';
import 'package:socialv/screens/shop/components/empty_cart_component.dart';
import 'package:socialv/screens/shop/components/price_widget.dart';
import 'package:socialv/screens/shop/screens/checkout_screen.dart';
import 'package:socialv/screens/shop/screens/product_detail_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class CartScreen extends StatefulWidget {
  final bool isFromHome;

  CartScreen({this.isFromHome = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

List<CartItemModel> cartItemList = [];

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItemModel>> future;
  CartModel? cart;

  bool mIsLastPage = false;
  bool isError = false;

  int total = 0;

  TextEditingController couponController = TextEditingController();

  @override
  void initState() {
    future = getCart();
    super.initState();
  }

  Future<List<CartItemModel>> getCart({String? orderBy}) async {
    appStore.setLoading(true);
    cartItemList.clear();

    await getCartDetails().then((value) {
      cart = value;
      cartItemList.addAll(value.items.validate());
      total = value.totals!.totalPrice.validate().toInt();

      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return cartItemList;
  }

  Future<void> applyCouponToCart() async {
    if (couponController.text.isNotEmpty) {
      ifNotTester(() async {
        appStore.setLoading(true);
        await Future.forEach<CartItemModel>(cart!.items.validate(), (element) async {
          if (element.isQuantityChanged.validate()) {
            appStore.setLoading(true);
            await updateCartItem(productKey: element.key.validate(), quantity: element.quantity.validate()).then((value) async {
              log('item updated successfully');
            }).catchError((e) {
              appStore.setLoading(false);

              toast(e.toString(), print: true);
            });
          }
        }).then((value) async {
          appStore.setLoading(true);

          await applyCoupon(code: couponController.text).then((value) {
            cart = value;
            couponController.clear();
            total = value.totals!.totalPrice.validate().toInt();
            log('Total: $total');
            //future = getCart();
            setState(() {});
            appStore.setLoading(false);
          }).catchError((e) {
            couponController.clear();
            appStore.setLoading(false);
            toast(e.toString());
          });
        });
      });
    } else {
      toast(language.enterValidCouponCode);
    }
  }

  Future<void> onRefresh() async {
    isError = false;
    future = getCart();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);
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
          title: Text(language.cart, style: boldTextStyle(size: 22)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Observer(
          builder: (_) {
            if (appStore.isLoading) {
              return LoadingWidget();
            } else {
              return FutureBuilder<List<CartItemModel>>(
                future: future,
                builder: (ctx, snap) {
                  if (snap.hasError && !appStore.isLoading) {
                    return NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                    ).center();
                  }
                  if (snap.hasData) {
                    if (snap.data.validate().isEmpty && !appStore.isLoading) {
                      return EmptyCartComponent(isFromHome: widget.isFromHome);
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            AnimatedListView(
                              shrinkWrap: true,
                              listAnimationType: ListAnimationType.FadeIn,
                              slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: cartItemList.length,
                              itemBuilder: (context, index) {
                                CartItemModel cartItem = cartItemList[index];

                                return Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          cachedImage(
                                            cartItem.images.validate().isNotEmpty ? cartItem.images!.first.src.validate() : '',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ).cornerRadiusWithClipRRect(defaultAppButtonRadius),
                                          16.width,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(cartItem.name.validate().capitalizeFirstLetter(), style: boldTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                                                  Image.asset(ic_close_square, color: context.primaryColor, height: 20, width: 20, fit: BoxFit.cover).onTap(() {
                                                    showConfirmDialogCustom(
                                                      context,
                                                      onAccept: (c) {
                                                        cartItem.isQuantityChanged = true;

                                                        product.isAddedCart = false;

                                                        total = total - (cartItem.prices!.price.validate().toInt() * cartItem.quantity!.toInt());

                                                        cartItemList.remove(cartItem);
                                                        setState(() {});
                                                        toast(language.itemRemovedSuccessfully);

                                                        removeCartItem(productKey: cartItem.key.validate()).then((value) {
                                                          getCart();
                                                        }).catchError((e) {
                                                          toast(e.toString(), print: true);
                                                        });
                                                      },
                                                      dialogType: DialogType.CONFIRMATION,
                                                      title: language.removeFromCartConfirmation,
                                                      positiveText: language.remove,
                                                    );
                                                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                                                ],
                                              ),
                                              4.height,
                                              PriceWidget(
                                                price: getPrice(cartItem.prices!.price.validate()),
                                                salePrice: getPrice(cartItem.prices!.salePrice.validate()),
                                                regularPrice: getPrice(cartItem.prices!.regularPrice.validate()),
                                              ),
                                              8.height,
                                              Row(
                                                children: [
                                                  Text('${language.qty}: ', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 12)),
                                                  Icon(
                                                    Icons.remove,
                                                    color: appStore.isDarkMode ? bodyDark : bodyWhite,
                                                    size: 18,
                                                  ).paddingOnly(left: 8, right: 6, top: 8, bottom: 8).onTap(() {
                                                    if (cartItem.quantity.validate() > 1) {
                                                      cartItem.quantity = cartItem.quantity.validate() - 1;
                                                      cartItem.isQuantityChanged = true;

                                                      total = total - cartItem.prices!.price.validate().toInt();
                                                      setState(() {});
                                                    }
                                                  }),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                                    margin: EdgeInsets.only(top: 8, bottom: 8),
                                                    decoration: BoxDecoration(borderRadius: radius(4), border: Border.all(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                                                    child: Text(cartItem.quantity.toString(), style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 12)),
                                                  ),
                                                  Icon(
                                                    Icons.add,
                                                    color: appStore.isDarkMode ? bodyDark : bodyWhite,
                                                    size: 18,
                                                  ).paddingOnly(left: 6, right: 12, top: 8, bottom: 8).onTap(() {
                                                    cartItem.quantity = cartItem.quantity.validate() + 1;
                                                    cartItem.isQuantityChanged = true;
                                                    total = total + cartItem.prices!.price.validate().toInt();

                                                    setState(() {});
                                                  }),
                                                ],
                                              ),
                                            ],
                                          ).onTap(() {
                                            ProductDetailScreen(id: cartItem.id.validate()).launch(context);
                                          }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            16.height,
                            if (cart!.coupons.validate().isNotEmpty)
                              CartCouponsComponent(
                                couponsList: cart!.coupons.validate(),
                                onCouponRemoved: (value) {
                                  cart = value;
                                  total = value.totals!.totalPrice.validate().toInt();

                                  setState(() {});
                                },
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: context.width() / 2 - 32,
                                  child: TextField(
                                    enabled: !appStore.isLoading,
                                    controller: couponController,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 1,
                                    decoration: inputDecorationFilled(
                                      context,
                                      label: language.couponCode,
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                      fillColor: context.cardColor,
                                    ),
                                    onSubmitted: (text) async {
                                      await applyCouponToCart();
                                    },
                                  ),
                                ),
                                TextButton(
                                  child: Text(language.applyCoupon, style: primaryTextStyle(color: context.primaryColor)),
                                  onPressed: () async {
                                    await applyCouponToCart();
                                  },
                                ).expand(),
                              ],
                            ).paddingSymmetric(horizontal: 16),
                            16.height,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.productDetails, style: boldTextStyle()),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(language.subTotal, style: secondaryTextStyle(size: 16)),
                                          PriceWidget(price: getPrice((total + cart!.totals!.totalDiscount.validate().toInt()).toString()), size: 16),
                                        ],
                                      ),
                                      8.height,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            language.discount,
                                            style: secondaryTextStyle(size: 16),
                                          ),
                                          Text(
                                            '-${cart!.totals!.currencySymbol}${getPrice(cart!.totals!.totalDiscount.validate())}',
                                            style: primaryTextStyle(color: appStore.isDarkMode ? Colors.green : Colors.green),
                                          ),
                                        ],
                                      ),
                                      8.height,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(language.totalAmount, style: secondaryTextStyle(size: 16)),
                                          PriceWidget(price: getPrice(total.toString()), size: 16),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ).paddingAll(16),
                            cart!.items.validate().isNotEmpty
                                ? AppButton(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(commonRadius)),
                                    text: language.lblContinue,
                                    textStyle: boldTextStyle(color: Colors.white),
                                    elevation: 0,
                                    color: context.primaryColor,
                                    width: context.width() - 32,
                                    onTap: () async {
                                      if (!appStore.isLoading)
                                        ifNotTester(() async {
                                          await Future.forEach<CartItemModel>(cart!.items.validate(), (element) async {
                                            if (element.isQuantityChanged.validate()) {
                                              appStore.setLoading(true);
                                              await updateCartItem(productKey: element.key.validate(), quantity: element.quantity.validate()).then((value) async {
                                                log('item updated successfully');
                                                await getCart();
                                              }).catchError((e) {
                                                appStore.setLoading(false);
                                                log(e.toString());
                                              });
                                            }
                                          }).then((value) {
                                            CheckoutScreen(cartDetails: cart!).launch(context).then((value) async {
                                              if (value ?? false) {
                                                await getCart();
                                              }
                                            });
                                          });
                                        });
                                    },
                                  )
                                : Offstage(),
                            100.height,
                          ],
                        ),
                      );
                    }
                  }

                  return LoadingWidget();
                },
              );
            }
          },
        ),
      ),
    );
  }
}
