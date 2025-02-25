import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:get/get.dart';

import '../../../core/route/route.dart';
import '../../../core/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../model/deposit/deposit_insert_response_model.dart';
import '../../model/deposit/deposit_method_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../repo/deposit/deposit_repo.dart';

class AddNewDepositController extends GetxController {
  DepositRepo depositRepo;
  AddNewDepositController({required this.depositRepo});

  bool isLoading = true;

  String selectedValue = "";
  String depositLimit = "";
  String charge = "";
  String payable = "";
  String amount = "";
  String fixedCharge = "";
  String currency = '';
  String payableText = '';
  String conversionRate = '';
  String inLocal = '';

  List<Methods> methodList = [];
  Methods? paymentMethod = Methods(name: MyStrings.selectOne, id: -1);

  TextEditingController amountController = TextEditingController();

  double rate = 1;
  double mainAmount = 0;

  setPaymentMethod(Methods? method) {
    String amt = amountController.text.toString();
    mainAmount = amt.isEmpty ? 0 : double.tryParse(amt) ?? 0;
    paymentMethod = method;

    depositLimit = '${StringConverter.formatNumber(method?.minAmount?.toString() ?? '-1')} - ${StringConverter.formatNumber(method?.maxAmount?.toString() ?? '-1')} $currency';
    changeInfoWidgetValue(mainAmount);
    update();
  }

  Future<void> getDepositMethod() async {
    currency = depositRepo.apiClient.getCurrencyOrUsername();
    methodList.clear();
    methodList.add(paymentMethod!);

    ResponseModel responseModel = await depositRepo.getDepositMethods();

    if (responseModel.statusCode == 200) {
      DepositMethodResponseModel methodsModel = DepositMethodResponseModel.fromJson(jsonDecode(responseModel.responseJson));

      if (methodsModel.message != null && methodsModel.message != null) {
        List<Methods>? tempList = methodsModel.data?.methods;
        if (tempList != null && tempList.isNotEmpty) {
          methodList.addAll(tempList);
        }
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
      return;
    }

    isLoading = false;
    update();
  }

  bool submitLoading = false;
  Future<void> submitDeposit() async {
    if (paymentMethod?.id.toString() == '-1') {
      CustomSnackBar.error(errorList: [MyStrings.selectPaymentMethod]);
      return;
    }

    String amount = amountController.text.toString();
    if (amount.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await depositRepo.insertDeposit(amount: amount, methodCode: paymentMethod?.methodCode ?? "", currency: paymentMethod?.currency ?? "");

    if (responseModel.statusCode == 200) {
      DepositInsertResponseModel insertResponseModel = DepositInsertResponseModel.fromJson(jsonDecode(responseModel.responseJson));

      if (insertResponseModel.status.toString().toLowerCase() == "success") {
        showWebView(insertResponseModel.data ?? DepositInsertData());
      } else {
        CustomSnackBar.error(errorList: insertResponseModel.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(
        errorList: [responseModel.message],
      );
    }

    submitLoading = false;
    update();
  }

  void changeInfoWidgetValue(double amount) {
    if (paymentMethod?.id.toString() == '-1') {
      return;
    }

    mainAmount = amount;
    double percent = double.tryParse(paymentMethod?.percentCharge ?? '0') ?? 0;
    double percentCharge = (amount * percent) / 100;
    double temCharge = double.tryParse(paymentMethod?.fixedCharge ?? '0') ?? 0;
    double totalCharge = percentCharge + temCharge;
    charge = '${StringConverter.formatNumber('$totalCharge')} $currency';
    double payable = totalCharge + amount;
    payableText = '$payable $currency';

    rate = double.tryParse(paymentMethod?.rate ?? '0') ?? 0;
    conversionRate = '1 $currency = $rate ${paymentMethod?.currency ?? ''}';
    inLocal = StringConverter.formatNumber('${payable * rate}');

    update();
    return;
  }

  void clearData() {
    depositLimit = '';
    charge = '';
    amountController.text = '';
    isLoading = false;
    methodList.clear();
  }

  bool isShowRate() {
    if (rate > 1 && currency.toLowerCase() != paymentMethod?.currency?.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }

  void showWebView(DepositInsertData depositInsertData) {
    Get.offAndToNamed(RouteHelper.depositWebViewScreen, arguments: depositInsertData);
  }
}
