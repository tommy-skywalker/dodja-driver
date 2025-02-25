import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';
import 'package:dodjaerrands_driver/presentation/components/app-bar/action_button_icon_widget.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/deposit/add_new_deposit_controller.dart';
import '../../../../data/model/deposit/deposit_method_response_model.dart';
import '../../../../data/repo/deposit/deposit_repo.dart';
import '../../../../data/services/api_service.dart';
import '../../../components/app-bar/custom_appbar.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/text-form-field/custom_amount_text_field.dart';
import '../../../components/text-form-field/custom_drop_down_text_field.dart';
import 'info_widget.dart';

class NewDepositScreen extends StatefulWidget {
  const NewDepositScreen({super.key});

  @override
  State<NewDepositScreen> createState() => _NewDepositScreenState();
}

class _NewDepositScreenState extends State<NewDepositScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(DepositRepo(apiClient: Get.find()));
    final controller = Get.put(AddNewDepositController(
      depositRepo: Get.find(),
    ));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getDepositMethod();
    });
  }

  @override
  void dispose() {
    Get.find<AddNewDepositController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewDepositController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          title: MyStrings.deposit,
          actionsWidget: [
            ActionButtonIconWidget(
              pressed: () {
                Get.toNamed(RouteHelper.depositsScreen);
              },
              icon: Icons.history,
            ),
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: MyColor.getScreenBgColor(),
                    borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                  ),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropDownTextField(
                            labelText: MyStrings.paymentMethod.tr,
                            selectedValue: controller.paymentMethod,
                            onChanged: (newValue) {
                              controller.setPaymentMethod(newValue);
                            },
                            items: controller.methodList.map((Methods bank) {
                              return DropdownMenuItem<Methods>(
                                value: bank,
                                child: Text((bank.name ?? '').tr, style: regularDefault),
                              );
                            }).toList()),
                        const SizedBox(height: Dimensions.space15),
                        CustomAmountTextField(
                          labelText: MyStrings.amount.tr,
                          hintText: MyStrings.enterAmount.tr,
                          inputAction: TextInputAction.done,
                          currency: controller.currency,
                          controller: controller.amountController,
                          onChanged: (value) {
                            if (value.toString().isEmpty) {
                              controller.changeInfoWidgetValue(0);
                            } else {
                              double amount = double.tryParse(value.toString()) ?? 0;
                              controller.changeInfoWidgetValue(amount);
                            }
                            return;
                          },
                        ),
                        controller.paymentMethod?.name != MyStrings.selectOne ? const InfoWidget() : const SizedBox(),
                        const SizedBox(height: 35),
                        RoundedButton(
                          isLoading: controller.submitLoading,
                          text: MyStrings.submit,
                          textColor: MyColor.getTextColor(),
                          width: double.infinity,
                          press: () {
                            controller.submitDeposit();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
