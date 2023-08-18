import 'package:nb_utils/nb_utils.dart';

double getShippingTotalCost({required double price, int? quantity, required String classId, bool isTotalCost = false, double totalAmount = 0.0}) {
  if (RegExp(r'\d+\.?\d*\s+\*\s+\[qty\]').hasMatch(classId) ||
      RegExp(r'\d+\.?\d*\*\[qty\]').hasMatch(classId) ||
      RegExp(r'\[qty\]\s+\*\s+\d+\.?\d*').hasMatch(classId) ||
      RegExp(r'\[qty\]\*\d+\.?\d*').hasMatch(classId)) {
    /// calculate cost per item e.g. 10(Base price) + 2(quantity) * 20(shipping class cost)
    return isTotalCost
        ? double.parse(classId.filterItemCost().validate(value: "0")) * quantity.validate()
        : price.validate() + double.parse(classId.filterItemCost().validate(value: "0"));
  } else if (RegExp(r'\d+\.?\d*\s+\*\s+\[cost\]').hasMatch(classId) ||
      RegExp(r'\d+\.?\d*\*\[cost\]').hasMatch(classId) ||
      RegExp(r'\[cost\]\s+\*\s+\d+\.?\d*').hasMatch(classId) ||
      RegExp(r'\[cost\]\*\d+\.?\d*').hasMatch(classId)) {
    /// calculate average cost e.g. 10(Base price) * 20(shipping class cost)
    return isTotalCost
        ? double.parse(classId.filterItemCost().validate(value: "0")) * quantity.validate()
        : price.validate() + (price.validate() * double.parse(classId.filterItemCost().validate(value: "0")));
  } else if (RegExp(r'[0-9]+\*\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\]').hasMatch(classId) ||
      RegExp(r'[0-9]+\s+\*\s+\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\]').hasMatch(classId) ||
      RegExp(r'[0-9]+\*\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\s+\max_fee=\"[0-9]+\"\]').hasMatch(classId) ||
      RegExp(r'[0-9]+\s+\*\s+\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\s+\max_fee=\"[0-9]+\"\]').hasMatch(classId) ||
      RegExp(r'[0-9]+\*\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\s+\max_fee=\"\"\]').hasMatch(classId) ||
      RegExp(r'[0-9]+\s+\*\s+\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\s+\max_fee=\"\"\]').hasMatch(classId) ||
      RegExp(r'\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\]\*[0-9]+').hasMatch(classId) ||
      RegExp(r'\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\]\s+\*\s+[0-9]+').hasMatch(classId) ||
      RegExp(r'\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\s+\max_fee=\"[0-9]+\"\]\*[0-9]+').hasMatch(classId) ||
      RegExp(r'\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\s+\max_fee=\"[0-9]+\"\]\s+\*\s+[0-9]+').hasMatch(classId) ||
      RegExp(r'\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\s+\max_fee=\"\"\]\*[0-9]+').hasMatch(classId) ||
      RegExp(r'\[fee\s+percent=\"[0-9]+\"\s+\min_fee=\"[0-9]+\"\s+\max_fee=\"\"\]\s+\*\s+[0-9]+').hasMatch(classId)) {
    /// calculate cost
    /// e.g. -
    /// if(min_fee is not empty && cost <= min_fee){
    ///   10(Base price) + 5(min_fee)
    /// }else if(max_fee is not empty && cost >= max_fee){
    ///   10(Base price) + 10(max_fee)
    /// }else{
    ///   10(Base price) + 7(average cost)
    /// }
    List<String> instanceSetting =
        classId.splitBetween("[", "]").replaceAll("[", '').replaceAll("]", '').replaceAll("\"", '').replaceAll("'", '').split(RegExp(r'(\s+)'));
    String percent = "";
    String minFee = "";
    String maxFee = "";
    String flatCost = classId.split("*").firstWhere((element) => element.isDigit());
    for (var e in instanceSetting) {
      if (e.contains("percent")) {
        percent = e.split("percent=").last;
      } else if (e.contains("min_fee")) {
        minFee = e.split("min_fee=").last;
      } else if (e.contains("max_fee")) {
        maxFee = e.split("max_fee=").last;
      }
    }
    double percentCost = (price.validate() * double.parse(percent.validate(value: "0"))) / 100;
    if (minFee.isNotEmpty && percentCost <= double.parse(minFee.validate(value: "0"))) {
      return price.validate() + double.parse(flatCost.validate(value: "0")) + double.parse(minFee.validate(value: "0"));
    } else if (maxFee.isNotEmpty && percentCost >= double.parse(maxFee.validate(value: "0"))) {
      log(double.parse(maxFee.validate(value: "0")));
      return price.validate() + double.parse(flatCost.validate(value: "0")) + double.parse(maxFee.validate(value: "0"));
    } else {
      return price.validate() + double.parse(flatCost.validate(value: "0")) + percentCost;
    }
  } else {
    return isTotalCost
        ? double.parse(classId.filterItemCost().validate(value: "0")) * quantity.validate()
        : price.validate() + double.parse(classId.filterItemCost().validate(value: "0"));
  }
}

extension Str on String? {
  String filterItemCost() {
    if (this.validate().isEmpty) {
      return this.validate();
    } else {
      return this
          .validate()
          .replaceAll(RegExp(r'(\s+)'), '')
          .replaceAll(RegExp(r'[a-zA-Z]'), '')
          .replaceAll(RegExp(r'\['), '')
          .replaceAll(RegExp(r'\]'), '')
          .replaceAll(RegExp(r'\*'), '')
          .replaceAll(RegExp(r'\='), '')
          .replaceAll(RegExp(r'\"'), '');
    }
  }
}
