import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';

import '../../../utils/constants.dart';

class SortByBottomSheet extends StatelessWidget {
  final List<FilterModel> filterOptions;

  const SortByBottomSheet(this.filterOptions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(language.sortBy, style: boldTextStyle()),
              TextButton(
                  onPressed: () {
                    finish(context, FilterModel(value: ProductFilters.date, title: 'Clear'));
                  },
                  child: Text(language.clearAll, style: boldTextStyle())),
            ],
          ).paddingSymmetric(horizontal: 16),
          AnimatedListView(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: filterOptions.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              FilterModel data = filterOptions[index];

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(data.title!, style: primaryTextStyle()),
              ).onTap(() {
                finish(context, data);
              });
            },
          ),
        ],
      ),
    );
  }
}
