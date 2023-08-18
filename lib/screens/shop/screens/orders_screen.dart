import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/models/woo_commerce/order_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/shop/components/price_widget.dart';
import 'package:socialv/screens/shop/screens/order_detail_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderModel> orderList = [];
  late Future<List<OrderModel>> future;

  List<FilterModel> filterOptions = getOrderStatus();
  FilterModel? dropDownValue;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getOrders();
    super.initState();
  }

  Future<List<OrderModel>> getOrders({String? status}) async {
    appStore.setLoading(true);

    await getOrderList(status: status == null ? OrderStatus.any : status).then((value) {
      if (mPage == 1) orderList.clear();

      value.forEach((element) {
        element.shippingLines!.forEach((e) {
          log(e.total);
        });
      });

      mIsLastPage = value.length != 20;
      orderList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return orderList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getOrders();
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
          title: Text(language.myOrders, style: boldTextStyle(size: 22)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            FutureBuilder<List<OrderModel>>(
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
                    return NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                      onRetry: () {
                        onRefresh();
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ).center();
                  } else {
                    return AnimatedListView(
                      shrinkWrap: true,
                      slideConfiguration: SlideConfiguration(
                        delay: 80.milliseconds,
                        verticalOffset: 300,
                      ),
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            OrderDetailScreen(orderDetails: orderList[index]).launch(context).then((value) {
                              if (value ?? false) {
                                mPage = 1;
                                getOrders();
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${language.orderNumber}: ', style: boldTextStyle(size: 14)),
                                        Text(orderList[index].id.validate().toString(), style: secondaryTextStyle()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('${language.date}: ', style: boldTextStyle(size: 14)),
                                        Text(formatDate(orderList[index].dateCreated.validate()), style: secondaryTextStyle()),
                                      ],
                                    ),
                                    10.height,
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: orderList[index].lineItems.validate().length,
                                      itemBuilder: (ctx, i) {
                                        LineItem orderItem = orderList[index].lineItems.validate()[i];
                                        return Row(
                                          children: [
                                            cachedImage(
                                              orderItem.image!.src.validate(),
                                              height: 30,
                                              width: 30,
                                              fit: BoxFit.cover,
                                            ).cornerRadiusWithClipRRect(commonRadius),
                                            10.width,
                                            Text('${orderItem.name.validate()}*${orderItem.quantity.validate()}', style: secondaryTextStyle()).expand(),
                                          ],
                                        ).paddingSymmetric(vertical: 4);
                                      },
                                    ),
                                    Divider(height: 28),
                                    Row(
                                      children: [
                                        Text('${language.total}: ', style: boldTextStyle()),
                                        PriceWidget(price: orderList[index].total),
                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                  child: Container(
                                    decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(4)),
                                    child: Text(orderList[index].status.validate().capitalizeFirstLetter(), style: secondaryTextStyle(color: Colors.white)),
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  ),
                                  alignment: Alignment.topRight,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      onNextPage: () {
                        if (!mIsLastPage) {
                          mPage++;
                          future = getOrderList();
                        }
                      },
                    ).paddingTop(80);
                  }
                }
                return Offstage();
              },
            ),
            Align(
              child: Container(
                decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<FilterModel>(
                      borderRadius: BorderRadius.circular(commonRadius),
                      icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                      elevation: 8,
                      style: primaryTextStyle(),
                      onChanged: (FilterModel? newValue) {
                        dropDownValue = newValue!;

                        mPage = 1;
                        future = getOrders(status: newValue.value);

                        setState(() {});
                      },
                      hint: Text(language.orderStatus, style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                      items: filterOptions.map<DropdownMenuItem<FilterModel>>((FilterModel value) {
                        return DropdownMenuItem<FilterModel>(
                          value: value,
                          child: Text(value.title.validate(), style: primaryTextStyle()),
                        );
                      }).toList(),
                      value: dropDownValue,
                    ),
                  ),
                ),
                margin: EdgeInsets.all(16),
              ),
              alignment: Alignment.topRight,
            ),
            Observer(
              builder: (_) {
                if (appStore.isLoading) {
                  return Positioned(
                    bottom: mPage != 1 ? 10 : null,
                    child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false),
                  );
                } else {
                  return Offstage();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
