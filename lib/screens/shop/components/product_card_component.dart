import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/woo_commerce/product_detail_model.dart';
import 'package:socialv/models/woo_commerce/product_list_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/shop/components/price_widget.dart';
import 'package:socialv/screens/shop/screens/product_detail_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:socialv/utils/constants.dart';

import '../../../models/woo_commerce/wishlist_model.dart';

class ProductCardComponent extends StatefulWidget {
  final ProductListModel product;

  const ProductCardComponent({required this.product});

  @override
  State<ProductCardComponent> createState() => _ProductCardComponentState();
}

class _ProductCardComponentState extends State<ProductCardComponent> {
  late ProductListModel product;
  List<WishlistModel> orderList = [];

  @override
  void initState() {
    product = widget.product;

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ProductDetailScreen(id: product.id.validate()).launch(context);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
        width: context.width() / 2 - 24,
        child: Column(
          children: [
            Stack(
              children: [
                cachedImage(
                  product.images.validate().isNotEmpty ? product.images.validate().first.src : '',
                  height: 150,
                  width: context.width() / 2 - 24,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRectOnly(topRight: defaultAppButtonRadius.toInt(), topLeft: defaultAppButtonRadius.toInt()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: context.primaryColor, borderRadius: radiusOnly(topLeft: defaultAppButtonRadius, bottomRight: 4)),
                  child: Text(language.sale, style: secondaryTextStyle(size: 10, color: Colors.white)),
                ).visible(product.onSale.validate()),
              ],
            ),
            16.height,
            Text(product.name.validate().capitalizeFirstLetter(), style: boldTextStyle()).paddingSymmetric(horizontal: 10),
            4.height,
            PriceWidget(
              price: product.price,
              priceHtml: product.priceHtml,
              salePrice: product.salePrice,
              regularPrice: product.regularPrice,
              showDiscountPercentage: false,
            ).paddingSymmetric(horizontal: 10),
            8.height,
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
            if (product.type != ProductTypes.variable && product.type != ProductTypes.grouped)
              TextButton(
                onPressed: () {
                  toast(language.successfullyAddedToCart);

                  addItemToCart(productId: product.id.validate(), quantity: 1).then((value) {
                    // toast(language.successfullyAddedToCart);
                  }).catchError((e) {
                    log(e.toString());
                  });
                },
                child: Text(language.addToCart, style: secondaryTextStyle(color: context.primaryColor)),
              ),
          ],
        ),
      ),
    );
  }
}

class RelatedProductCardComponent extends StatefulWidget {
  final RelatedProductModel product;

  const RelatedProductCardComponent({required this.product});

  @override
  State<RelatedProductCardComponent> createState() => _RelatedProductCardComponentState();
}

class _RelatedProductCardComponentState extends State<RelatedProductCardComponent> {
  late RelatedProductModel product;

  @override
  void initState() {
    product = widget.product;

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ProductDetailScreen(id: product.id.validate()).launch(context);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
        width: context.width() / 2 - 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                cachedImage(
                  product.images!.first.src,
                  height: 150,
                  width: context.width() / 2 - 24,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRectOnly(topRight: defaultAppButtonRadius.toInt(), topLeft: defaultAppButtonRadius.toInt()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: context.primaryColor, borderRadius: radiusOnly(topLeft: defaultAppButtonRadius, bottomRight: defaultAppButtonRadius)),
                  child: Text(language.sale, style: secondaryTextStyle(size: 10, color: Colors.white)),
                ).visible(product.salePrice.validate().isNotEmpty),
              ],
            ),
            14.height,
            Text(product.name.validate().capitalizeFirstLetter(), style: boldTextStyle(size: 14)).paddingSymmetric(horizontal: 10),
            4.height,
            PriceWidget(
              price: product.price,
              salePrice: product.salePrice,
              regularPrice: product.regularPrice,
              showDiscountPercentage: false,
            ).paddingSymmetric(horizontal: 10),
            14.height,
          ],
        ),
      ),
    );
  }
}
