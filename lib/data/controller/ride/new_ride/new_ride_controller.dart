import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/data/model/authorization/authorization_response_model.dart';
import 'package:dodjaerrands_driver/data/model/global/response_model/response_model.dart';
import 'package:dodjaerrands_driver/data/model/global/ride/ride_model.dart';
import 'package:dodjaerrands_driver/data/model/ride/new_ride_response_model.dart';
import 'package:dodjaerrands_driver/data/repo/ride/ride_repo.dart';
import 'package:dodjaerrands_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

class NewRideController extends GetxController {
  RideRepo repo;
  NewRideController({required this.repo});

  bool isLoading = true;

  String imagePath = "";
  String defaultCurrency = "";
  String defaultCurrencySymbol = "";
  String username = "";
  int page = 0;
  double mainAmount = 0;
  TextEditingController amountController = TextEditingController();
  bool isInterCity = false;

  Future<void> initialData(bool isICity) async {
    page = 0;
    mainAmount = 0;
    defaultCurrency = repo.apiClient.getCurrencyOrUsername();
    defaultCurrencySymbol = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    username = repo.apiClient.getCurrencyOrUsername(isCurrency: false);
    rideList = [];
    amountController.text = '';
    isInterCity = isICity;

    rideId = "-1";
    isSubmitLoading = false;
    update();
    getNewRideList();
  }

  List<RideModel> rideList = [];
  String? nextPageUrl;
  Future<void> getNewRideList({int? p, bool shouldLoading = true}) async {
    page = p ?? page + 1;
    if (page == 1) {
      rideList.clear();
      isLoading = shouldLoading;
      update();
    }

    isLoading = shouldLoading;
    update();

    try {
      ResponseModel responseModel = await repo.getNewRide(isICity: isInterCity);
      if (responseModel.statusCode == 200) {
        NewRideListResponseModel model = NewRideListResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          nextPageUrl = model.data?.rides?.nextPageUrl;
          rideList.addAll(model.data?.rides?.data ?? []);
          update();
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e);
    }
    isLoading = false;
    update();
  }

  String rideId = "-1";
  bool isSubmitLoading = false;
  Future<void> createBid(String id) async {
    rideId = id;
    isSubmitLoading = true;
    update();
    try {
      ResponseModel responseModel = await repo.createBid(rideId: id, amount: mainAmount.toString());
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          rideId = "-1";
          Get.back();
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx("error on catch $e");
    }
    isSubmitLoading = false;
    rideId = "-1";
    update();
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  updateMainAmount(double amount) {
    mainAmount = amount;
    amountController.text = StringConverter.formatNumber(mainAmount.toString(), precision: 0);
    update();
  }

  addMainAmount(double amount) {
    mainAmount += amount;
    amountController.text = StringConverter.formatNumber(mainAmount.toString());
    update();
  }

  removeMainAmount(double amount) {
    if (mainAmount > 0) {
      mainAmount -= amount;
      amountController.text = StringConverter.formatNumber(mainAmount.toString());
      update();
    }
  }
}
