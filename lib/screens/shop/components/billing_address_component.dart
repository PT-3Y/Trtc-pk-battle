import 'package:flutter/material.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/woo_commerce/billing_address_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/woo_commerce/country_model.dart';
import 'package:socialv/screens/settings/screens/edit_shop_details_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class BillingAddressComponent extends StatefulWidget {
  final BillingAddressModel? data;
  final bool isBilling;

  const BillingAddressComponent({this.data, this.isBilling = false});

  @override
  State<BillingAddressComponent> createState() => _BillingAddressComponentState();
}

class _BillingAddressComponentState extends State<BillingAddressComponent> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController addOne = TextEditingController();
  TextEditingController addTwo = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController postCode = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode companyFocus = FocusNode();
  FocusNode addOneFocus = FocusNode();
  FocusNode addTwoFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode postCodeFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  CountryModel? selectedCountry;
  StateModel? selectedState;

  void init() {
    firstName.text = widget.data!.firstName.validate();
    lastName.text = widget.data!.lastName.validate();
    company.text = widget.data!.company.validate();
    country.text = widget.data!.country.validate();
    addOne.text = widget.data!.address_1.validate();
    addTwo.text = widget.data!.address_2.validate();
    city.text = widget.data!.city.validate();
    state.text = widget.data!.state.validate();
    postCode.text = widget.data!.postcode.validate();
    phone.text = widget.data!.phone.validate();
    email.text = widget.data!.email.validate();

    if (widget.data!.country.validate().isNotEmpty) {
      selectedCountry = countriesList.firstWhere((element) => element.code == widget.data!.country.validate());
      if (widget.data!.state.validate().isNotEmpty) {
        selectedState = selectedCountry!.states!.firstWhere((element) => element.code == widget.data!.state.validate());
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Column(
      children: [
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: context.width() / 2 - 20,
              decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
              child: AppTextField(
                focus: firstNameFocus,
                nextFocus: lastNameFocus,
                enabled: !appStore.isLoading,
                controller: firstName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textFieldType: TextFieldType.NAME,
                textStyle: primaryTextStyle(),
                maxLines: 1,
                decoration: inputDecorationFilled(context, label: language.firstName, fillColor: context.scaffoldBackgroundColor),
                onChanged: (text) {
                  if (widget.isBilling) {
                    billingAddress.firstName = text;
                  } else {
                    shippingAddress.firstName = text;
                  }
                },
                onFieldSubmitted: (text) {
                  if (widget.isBilling) {
                    billingAddress.firstName = text;
                  } else {
                    shippingAddress.firstName = text;
                  }
                },
              ),
            ),
            Container(
              width: context.width() / 2 - 20,
              decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
              child: AppTextField(
                focus: lastNameFocus,
                nextFocus: companyFocus,
                enabled: !appStore.isLoading,
                controller: lastName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textFieldType: TextFieldType.NAME,
                textStyle: primaryTextStyle(),
                maxLines: 1,
                decoration: inputDecorationFilled(context, label: language.lastName, fillColor: context.scaffoldBackgroundColor),
                onChanged: (text) {
                  if (widget.isBilling) {
                    billingAddress.lastName = text;
                  } else {
                    shippingAddress.lastName = text;
                  }
                },
                onFieldSubmitted: (text) {
                  if (widget.isBilling) {
                    billingAddress.lastName = text;
                  } else {
                    shippingAddress.lastName = text;
                  }
                },
              ),
            ),
          ],
        ),
        16.height,
        Container(
          decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
          child: AppTextField(
            enabled: !appStore.isLoading,
            controller: company,
            focus: companyFocus,
            nextFocus: addOneFocus,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            textFieldType: TextFieldType.NAME,
            textStyle: primaryTextStyle(),
            maxLines: 1,
            decoration: inputDecorationFilled(context, label: language.company, fillColor: context.scaffoldBackgroundColor),
            onChanged: (text) {
              if (widget.isBilling) {
                billingAddress.company = text;
              } else {
                shippingAddress.company = text;
              }
            },
            onFieldSubmitted: (text) {
              if (widget.isBilling) {
                billingAddress.company = text;
              } else {
                shippingAddress.company = text;
              }
            },
          ),
        ),
        16.height,
        Container(
          decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
          child: AppTextField(
            enabled: !appStore.isLoading,
            controller: addOne,
            focus: addOneFocus,
            nextFocus: addTwoFocus,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            textFieldType: TextFieldType.NAME,
            textStyle: primaryTextStyle(),
            maxLines: 1,
            decoration: inputDecorationFilled(context, label: '${language.address} 1', fillColor: context.scaffoldBackgroundColor),
            onChanged: (text) {
              if (widget.isBilling) {
                billingAddress.address_1 = text;
              } else {
                shippingAddress.address_1 = text;
              }
            },
            onFieldSubmitted: (text) {
              if (widget.isBilling) {
                billingAddress.address_1 = text;
              } else {
                shippingAddress.address_1 = text;
              }
            },
          ),
        ),
        16.height,
        Container(
          decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
          child: AppTextField(
            enabled: !appStore.isLoading,
            controller: addTwo,
            focus: addTwoFocus,
            nextFocus: cityFocus,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            textFieldType: TextFieldType.NAME,
            textStyle: primaryTextStyle(),
            maxLines: 1,
            decoration: inputDecorationFilled(context, label: '${language.address} 2', fillColor: context.scaffoldBackgroundColor),
            onChanged: (text) {
              if (widget.isBilling) {
                billingAddress.address_2 = text;
              } else {
                shippingAddress.address_2 = text;
              }
            },
            onFieldSubmitted: (text) {
              if (widget.isBilling) {
                billingAddress.address_2 = text;
              } else {
                shippingAddress.address_2 = text;
              }
            },
          ),
        ),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: context.width() / 2 - 20,
              decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
              child: AppTextField(
                enabled: !appStore.isLoading,
                controller: city,
                focus: cityFocus,
                nextFocus: postCodeFocus,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textFieldType: TextFieldType.NAME,
                textStyle: primaryTextStyle(),
                maxLines: 1,
                decoration: inputDecorationFilled(context, label: language.city, fillColor: context.scaffoldBackgroundColor),
                onChanged: (text) {
                  if (widget.isBilling) {
                    billingAddress.city = text;
                  } else {
                    shippingAddress.city = text;
                  }
                },
                onFieldSubmitted: (text) {
                  if (widget.isBilling) {
                    billingAddress.city = text;
                  } else {
                    shippingAddress.city = text;
                  }
                },
              ),
            ),
            Container(
              width: context.width() / 2 - 20,
              decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
              child: AppTextField(
                enabled: !appStore.isLoading,
                controller: postCode,
                focus: postCodeFocus,
                nextFocus: phoneFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                textFieldType: TextFieldType.NUMBER,
                textStyle: primaryTextStyle(),
                maxLines: 1,
                decoration: inputDecorationFilled(context, label: language.postCode, fillColor: context.scaffoldBackgroundColor),
                onChanged: (text) {
                  if (widget.isBilling) {
                    billingAddress.postcode = text;
                  } else {
                    shippingAddress.postcode = text;
                  }
                },
                onFieldSubmitted: (text) {
                  if (widget.isBilling) {
                    billingAddress.postcode = text;
                  } else {
                    shippingAddress.postcode = text;
                  }
                },
              ),
            ),
          ],
        ),
        16.height,
        Container(
          decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
          child: AppTextField(
            enabled: !appStore.isLoading,
            controller: phone,
            focus: phoneFocus,
            readOnly: false,
            nextFocus: emailFocus,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            textFieldType: TextFieldType.PHONE,
            textStyle: primaryTextStyle(),
            maxLines: 1,
            decoration: inputDecorationFilled(context, label: language.phone, fillColor: context.scaffoldBackgroundColor),
            onChanged: (text) {
              if (widget.isBilling) {
                billingAddress.phone = text;
              } else {
                shippingAddress.phone = text;
              }
            },
            onFieldSubmitted: (text) {
              if (widget.isBilling) {
                billingAddress.phone = text;
              } else {
                shippingAddress.phone = text;
              }
            },
          ),
        ),
        16.height,
        Container(
          decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
          child: AppTextField(
            enabled: !appStore.isLoading,
            controller: email,
            focus: emailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            textFieldType: TextFieldType.EMAIL,
            textStyle: primaryTextStyle(),
            maxLines: 1,
            decoration: inputDecorationFilled(context, label: language.email, fillColor: context.scaffoldBackgroundColor),
            onChanged: (text) {
              if (widget.isBilling) {
                billingAddress.email = text;
              } else {
                shippingAddress.email = text;
              }
            },
            onFieldSubmitted: (text) {
              if (widget.isBilling) {
                billingAddress.email = text;
              } else {
                shippingAddress.email = text;
              }
            },
          ),
        ).visible(widget.isBilling),
        16.height,
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CountryModel>(
              borderRadius: BorderRadius.circular(commonRadius),
              icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
              elevation: 8,
              isExpanded: true,
              onChanged: (CountryModel? newValue) {
                selectedCountry = newValue!;
                if (widget.isBilling) {
                  billingAddress.country = newValue.code;
                } else {
                  shippingAddress.company = newValue.code;
                }

                setState(() {});
              },
              hint: Text(language.country, style: secondaryTextStyle(weight: FontWeight.w600)),
              items: countriesList.validate().map<DropdownMenuItem<CountryModel>>((CountryModel value) {
                return DropdownMenuItem<CountryModel>(
                  value: value,
                  child: Text(value.name.validate(), style: primaryTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 1),
                );
              }).toList(),
              value: selectedCountry,
            ),
          ),
        ),
        16.height,
        InkWell(
          borderRadius: radius(commonRadius),
          onTap: () {
            if (selectedCountry == null) {
              toast(language.pleaseSelectCountry);
            } else if (selectedCountry!.states.validate().isEmpty) {
              toast(language.noStatesToSelect);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<StateModel>(
                borderRadius: BorderRadius.circular(commonRadius),
                icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                elevation: 8,
                isExpanded: true,
                onChanged: (StateModel? newValue) {
                  selectedState = newValue!;

                  if (widget.isBilling) {
                    billingAddress.state = newValue.code;
                  } else {
                    shippingAddress.state = newValue.code;
                  }
                  setState(() {});
                },
                hint: Text(language.state, style: secondaryTextStyle(weight: FontWeight.w600)),
                items: selectedCountry == null
                    ? []
                    : selectedCountry!.states.validate().isNotEmpty
                        ? selectedCountry!.states.validate().map<DropdownMenuItem<StateModel>>((StateModel value) {
                            return DropdownMenuItem<StateModel>(
                              value: value,
                              child: Text(value.name.validate(), style: primaryTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 1),
                            );
                          }).toList()
                        : [],
                value: selectedState,
              ),
            ),
          ),
        ),
        16.height,
      ],
    );
  }
}
