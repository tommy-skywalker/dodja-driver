import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';
import 'package:dodjaerrands_driver/data/controller/dashboard/dashboard_controller.dart';
import 'package:dodjaerrands_driver/data/model/global/ride/ride_model.dart';
import 'package:dodjaerrands_driver/presentation/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:dodjaerrands_driver/presentation/components/buttons/rounded_button.dart';
import 'package:dodjaerrands_driver/presentation/components/divider/custom_spacer.dart';
import 'package:dodjaerrands_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:dodjaerrands_driver/presentation/components/text/header_text.dart';

import '../../../../../data/services/api_service.dart';

class OfferBidBottomSheet extends StatefulWidget {
  RideModel ride;
  OfferBidBottomSheet({super.key, required this.ride});

  @override
  State<OfferBidBottomSheet> createState() => _OfferBidBottomSheetState();
}

class _OfferBidBottomSheetState extends State<OfferBidBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(
      builder: (controller) => Container(
        color: MyColor.colorWhite,
        child: Column(
          children: [
            const BottomSheetHeaderRow(),
            HeaderText(text: MyStrings.yourOfferAmount, textStyle: boldLarge.copyWith(color: MyColor.getRideTitleColor(), fontWeight: FontWeight.bold, fontSize: Dimensions.fontOverLarge)),
            spaceDown(Dimensions.space15),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.space10),
                  decoration: BoxDecoration(color: MyColor.bodyTextBgColor, borderRadius: BorderRadius.circular(Dimensions.space5)),
                  child: Center(
                    child: Text(
                      MyStrings.recommendPrice.rKv({
                        "priceKey": "${'\$'}${StringConverter.formatDouble(widget.ride.recommendAmount.toString())}",
                        "distanceKey": "${widget.ride.distance}Km",
                      }).tr,
                      style: regularDefault.copyWith(color: MyColor.bodyText),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                spaceDown(Dimensions.space20),
                Container(
                  decoration: BoxDecoration(shape: BoxShape.rectangle, color: MyColor.primaryColor.withOpacity(0.05)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Get.find<ApiClient>().getCurrencyOrUsername(isSymbol: true),
                        style: mediumExtraLarge.copyWith(
                          fontSize: 50,
                          color: MyColor.primaryColor,
                        ),
                      ),
                      IntrinsicWidth(
                        child: TextFormField(
                          onChanged: (val) {},
                          expands: false,
                          controller: controller.amountController,
                          scrollPadding: EdgeInsets.zero,
                          inputFormatters: [LengthLimitingTextInputFormatter(8)],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.space20),
                            border: InputBorder.none,
                            hintText: controller.amountController.text.isNotEmpty ? '0' : '0.0',
                            hintStyle: mediumDefault.copyWith(
                              fontSize: 50,
                              color: controller.amountController.text.isNotEmpty ? MyColor.primaryColor : Colors.grey.shade500,
                            ),
                          ),
                          style: mediumDefault.copyWith(fontSize: 50, color: controller.amountController.text.isNotEmpty ? MyColor.primaryColor : Colors.grey.shade500),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          selectionHeightStyle: BoxHeightStyle.includeLineSpacingTop,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                spaceDown(Dimensions.space40),
                RoundedButton(
                  text: MyStrings.bidNOW.tr.toUpperCase(),
                  isLoading: controller.isSendLoading,
                  textStyle: boldDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge),
                  press: () {
                    double enterValue = StringConverter.formatDouble(controller.amountController.text);
                    double min = StringConverter.formatDouble(widget.ride.minAmount ?? '0.0');
                    double max = StringConverter.formatDouble(widget.ride.maxAmount ?? '0.0');

                    if (enterValue < max + 1 && enterValue >= min) {
                      controller.updateMainAmount(enterValue);
                      controller.sendBid(widget.ride.id ?? '');
                    } else {
                      CustomSnackBar.error(
                        errorList: ['${MyStrings.pleaseEnterMinimum.tr} ${controller.currencySym}${StringConverter.formatNumber(widget.ride.minAmount ?? '0')} to ${controller.currencySym}${StringConverter.formatNumber(widget.ride.maxAmount ?? '')}'],
                      );
                    }
                  },
                ),
                spaceDown(Dimensions.space20),
              ],
            )
          ],
        ),
      ),
    );
  }
}
