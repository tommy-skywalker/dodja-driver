import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/data/controller/map/ride_map_controller.dart';
import 'package:dodjaerrands_driver/data/model/authorization/authorization_response_model.dart';
import 'package:dodjaerrands_driver/data/model/global/response_model/response_model.dart';
import 'package:dodjaerrands_driver/data/model/global/ride/ride_model.dart';
import 'package:dodjaerrands_driver/data/model/ride/ride_details_response_model.dart';
import 'package:dodjaerrands_driver/data/repo/ride/ride_repo.dart';
import 'package:dodjaerrands_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

import '../../../../presentation/screens/ride_details/widgets/payment_receive_dialog.dart';

class RideDetailsController extends GetxController {
  RideRepo repo;
  RideMapController mapController;
  RideDetailsController({required this.repo, required this.mapController});

  RideModel ride = RideModel(id: '-1');

  bool isCashPaymentRequest = false;

  void updateRide(RideModel newRide) {
    ride = newRide;
    update();
    printx('update ride from event');
  }

  String currency = '';
  String currencySym = '';
  String userImageUrl = '';
  bool isLoading = true;
  bool isRunning = false;
  LatLng pickupLatLng = const LatLng(0, 0);
  LatLng destinationLatLng = const LatLng(0, 0);

  Future<void> getRideDetails(String id, {bool shouldLoading = true}) async {
    currency = repo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    isLoading = shouldLoading;
    update();

    ResponseModel responseModel = await repo.getRideDetails(id);
    if (responseModel.statusCode == 200) {
      RideDetailsResponseModel model = RideDetailsResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == MyStrings.success) {
        RideModel? tRide = model.data?.ride;
        userImageUrl = model.data?.userImagePath ?? '';
        if (tRide != null) {
          ride = tRide;
          isRunning = tRide.isRunning == '1' ? true : false;
          pickupLatLng = LatLng(StringConverter.formatDouble(tRide.pickupLatitude.toString()), StringConverter.formatDouble(tRide.pickupLongitude.toString()));
          destinationLatLng = LatLng(StringConverter.formatDouble(tRide.destinationLatitude.toString()), StringConverter.formatDouble(tRide.destinationLongitude.toString()));
        }
        update();
        mapController.loadMap(pickup: pickupLatLng, destination: destinationLatLng);
        if (ride.isRunning == "1" || ride.status == "1") {
          await mapController.setCustomMarkerIcon(isRunning: true);
        }
        if (ride.paymentStatus == "2" && ride.paymentStatus != "1" && shouldLoading == true) {
          onShowPaymentDialog(Get.context!);
        }
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }

  TextEditingController otpController = TextEditingController();

  bool isStartBtnLoading = false;
  bool isRideStart = false;
  Future<void> startRide(String rideId) async {
    isStartBtnLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.startRide(id: ride.id ?? '-1', otp: otpController.text);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          isRideStart = true;
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
          getRideDetails(rideId, shouldLoading: false);
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
    isStartBtnLoading = false;
    otpController.text = '';
    update();
  }

  bool isEndBtnLoading = false;

  Future<void> endRide(String rideId) async {
    isEndBtnLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.endRide(id: rideId);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
          getRideDetails(rideId, shouldLoading: false);
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
    isEndBtnLoading = false;
    update();
  }

  bool isAcceptPaymentBtnLoading = false;
  Future<void> acceptPaymentRide(String rideId, BuildContext context) async {
    isAcceptPaymentBtnLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.acceptCashPayment(id: rideId);
      if (responseModel.statusCode == 200) {
        RideDetailsResponseModel model = RideDetailsResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          isCashPaymentRequest = false;
          RideModel? tRide = model.data?.ride;
          if (tRide != null) {
            ride = tRide;
          }
          update();
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e);
    } finally {
      Get.back();
      isAcceptPaymentBtnLoading = false;
      update();
    }
  }

  TextEditingController reviewMsgController = TextEditingController();
  double rating = 0.0;
  void updateRating(double rate) {
    rating = rate;
    update();
  }

  bool isReviewLoading = false;
  Future<void> reviewRide(String rideId) async {
    isReviewLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.reviewRide(id: rideId, rating: rating.toString(), review: reviewMsgController.text);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          Get.back();
          printx(model.status);
          reviewMsgController.text = '';
          rating = 0.0;
          update();
          Get.offAllNamed(RouteHelper.allRideScreen);
          CustomSnackBar.success(successList: model.message ?? []);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e);
    }
    isReviewLoading = false;
    update();
  }

  void onShowPaymentDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return PaymentReceiveDialog();
        });
  }

  Future<void> updateLocation() async {
    try {
      ResponseModel responseModel = await repo.updateLocation(id: ride.id ?? '');
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
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
    isReviewLoading = false;
    update();
  }
}
