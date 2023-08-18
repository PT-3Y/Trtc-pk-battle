import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/woo_commerce/billing_address_model.dart';
import 'package:socialv/models/woo_commerce/country_model.dart';
import 'package:socialv/models/woo_commerce/customer_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/shop/components/billing_address_component.dart';
import 'package:socialv/utils/app_constants.dart';

BillingAddressModel billingAddress = BillingAddressModel();
BillingAddressModel shippingAddress = BillingAddressModel();

List<CountryModel> countriesList = [];

class EditShopDetailsScreen extends StatefulWidget {
  const EditShopDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EditShopDetailsScreen> createState() => _EditShopDetailsScreenState();
}

class _EditShopDetailsScreenState extends State<EditShopDetailsScreen> {
  CustomerModel details = CustomerModel();

  bool isSame = false;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    appStore.setLoading(true);
    await getCustomer().then((value) {
      details = value;

      billingAddress = value.billing!;
      shippingAddress = value.shipping!;

      setState(() {});

      getCountries().then((value) {
        countriesList.addAll(value);
        setState(() {});

        appStore.setLoading(false);
      }).catchError((e) {
        appStore.setLoading(false);
        log('e.toString(): ${e.toString()}');
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(language.editShopDetails, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context, true);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionTile(
                  title: Text(language.billingAddress, style: boldTextStyle()),
                  children: <Widget>[
                    BillingAddressComponent(data: billingAddress, isBilling: true),
                  ],
                  backgroundColor: context.cardColor,
                  collapsedBackgroundColor: context.cardColor,
                  iconColor: appStore.isDarkMode ? bodyDark : bodyWhite,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                16.height,
                Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(borderRadius: radius(4)),
                      activeColor: context.primaryColor,
                      side: BorderSide(color: context.primaryColor),
                      value: isSame,
                      onChanged: (val) {
                        isSame = val.validate();
                        if (val.validate()) {
                          shippingAddress = billingAddress;
                        } else {
                          shippingAddress = BillingAddressModel();
                        }
                        setState(() {});
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        isSame = !isSame;
                        if (isSame) {
                          shippingAddress = billingAddress;
                        } else {
                          shippingAddress = BillingAddressModel();
                        }
                        setState(() {});
                      },
                      child: Text(language.billingAndShippingAddresses, style: secondaryTextStyle()),
                    ),
                  ],
                ),
                16.height,
                ExpansionTile(
                  childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: context.cardColor,
                  collapsedBackgroundColor: context.cardColor,
                  iconColor: appStore.isDarkMode ? bodyDark : bodyWhite,
                  title: Text(language.shippingAddress, style: boldTextStyle()),
                  children: <Widget>[
                    BillingAddressComponent(data: shippingAddress),
                  ],
                ),
              ],
            ),
          ),
          Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading))
        ],
      ),
      bottomNavigationBar: Observer(
        builder: (_) => appButton(
          context: context,
          text: language.update,
          onTap: () async {
            appStore.setLoading(true);
            Map request = {"billing": billingAddress, "shipping": shippingAddress};

            updateCustomer(request: request).then((value) {
              details = value;
              setState(() {});
              toast(language.updatedSuccessfully, print: true);
              finish(context, true);
              appStore.setLoading(false);
            }).catchError((e) {
              appStore.setLoading(false);

              if (e.toString() == "Invalid parameter(s): billing") {
                toast(language.enterValidDetails);
              } else {
                log(e.toString());
                toast(language.somethingWentWrong, print: true);
              }
            });
          },
        ).paddingAll(16).visible(!appStore.isLoading),
      ),
    );
  }
}
