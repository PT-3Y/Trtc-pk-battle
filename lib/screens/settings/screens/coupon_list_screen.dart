import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/woo_commerce/coupon_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';

class CouponListScreen extends StatefulWidget {
  const CouponListScreen({Key? key}) : super(key: key);

  @override
  State<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  List<CouponModel> couponsList = [];
  late Future<List<CouponModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = couponssList();

    setStatusBarColor(Colors.transparent);
    super.initState();
  }

  Future<List<CouponModel>> couponssList() async {
    appStore.setLoading(true);

    await getCouponsList().then((value) {
      if (mPage == 1) couponsList.clear();

      mIsLastPage = value.length != 20;
      couponsList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return couponsList;
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
        isError = false;
        mPage = 1;
        future = couponssList();
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
          title: Text(language.coupons, style: boldTextStyle(size: 22)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            FutureBuilder<List<CouponModel>>(
              future: future,
              builder: (ctx, snap) {
                if (snap.hasError) {
                  return NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      isError = false;
                      mPage = 1;
                      future = couponssList();
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
                        isError = false;
                        mPage = 1;
                        future = couponssList();
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
                      itemCount: couponsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(commonRadius)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('\$${couponsList[index].amount.toDouble().round()} ${language.off}', style: boldTextStyle(size: 18, color: context.primaryColor)),
                                  InkWell(
                                    child: DottedBorderWidget(
                                      child: Container(
                                        decoration: BoxDecoration(color: context.primaryColor.withAlpha(30), borderRadius: radius(commonRadius)),
                                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                        child: Text(couponsList[index].code.validate(), style: boldTextStyle(color: context.primaryColor)),
                                      ),
                                      radius: commonRadius,
                                      color: context.primaryColor,
                                    ),
                                    onTap: () {
                                      toast(language.copiedToClipboard);
                                      Clipboard.setData(new ClipboardData(text: couponsList[index].code.validate()));
                                    },
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              Text(couponsList[index].description.validate(), style: primaryTextStyle()),
                              8.height,
                              Text('${language.expiresOn} ${formatDate(couponsList[index].dateExpires.validate())}', style: secondaryTextStyle())
                            ],
                          ),
                        );
                      },
                      onNextPage: () {
                        if (!mIsLastPage) {
                          mPage++;
                          future = couponssList();
                        }
                      },
                    );
                  }
                }
                return Offstage();
              },
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
