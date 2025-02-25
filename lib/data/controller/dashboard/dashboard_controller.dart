import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dodjaerrands_driver/core/helper/shared_preference_helper.dart';
import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/data/model/authorization/authorization_response_model.dart';
import 'package:dodjaerrands_driver/data/model/global/response_model/response_model.dart';
import 'package:dodjaerrands_driver/data/model/global/ride/ride_model.dart';
import 'package:dodjaerrands_driver/data/model/dashboard/dashboard_response_model.dart';
import 'package:dodjaerrands_driver/data/model/global/user/global_driver_model.dart';
import 'package:dodjaerrands_driver/data/repo/dashboard/dashboard_repo.dart';
import 'package:dodjaerrands_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

import '../../../core/utils/url_container.dart';

class DashBoardController extends GetxController {
  DashBoardRepo repo;
  DashBoardController({required this.repo});
  TextEditingController amountController = TextEditingController();

  int selectedIndex = 0;

  String? profileImageUrl;

  bool isLoading = true;
  Position? currentPosition;
  String currentAddress = "${MyStrings.loading.tr}...";
  RxBool userOnline = true.obs;
  String? nextPageUrl;
  int page = 0;
  double mainAmount = 0;

  bool isDriverVerified = true;
  bool isVehicleVerified = true;

  bool isVehicleVerificationPending = false;
  bool isDriverVerificationPending = false;

  String currency = '';
  String currencySym = '';
  String userImagePath = '';

  Future<void> initialData({bool shouldLoad = true}) async {
    page = 0;
    mainAmount = 0;
    nextPageUrl;
    amountController.text = '';
    currency = repo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    checkPermission();
    runningRide = RideModel(id: "-1");
    isLoading = shouldLoad;
    update();
    await loadData();
    isLoading = false;
    update();
  }

  GlobalDriverInfo driver = GlobalDriverInfo(id: '-1');

  void checkPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request().then((value) async {
        getCurrentLocation();
      }).onError((error, stackTrace) {
        CustomSnackBar.error(errorList: ["Please enable your location permission"]);
      });
    } else {
      getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      currentPosition = await geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.best));
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
      currentAddress = "";
      currentAddress = "${placemarks[0].street} ${placemarks[0].subThoroughfare} ${placemarks[0].thoroughfare},${placemarks[0].subLocality},${placemarks[0].locality},${placemarks[0].country}";

      update();
    } catch (e) {
      printx("Error>>>>>>>: $e");
      CustomSnackBar.error(errorList: ["Something went wrong while Taking Location"]);
    }
  }

  List<RideModel> rideList = [];
  List<RideModel> pendingRidesList = [];
  RideModel? runningRide;
  bool isLoaderLoading = false;
  Future<void> onlineStatus({bool isFromRideDetails = false}) async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      await getCurrentLocation();
    } else {
      await Permission.location.request().then((value) async {
        getCurrentLocation();
      }).onError((error, stackTrace) {
        CustomSnackBar.error(errorList: [MyStrings.pleaseEnableLocationPermission.tr]);
      });
    }

    try {
      isLoaderLoading = true;
      update();
      ResponseModel responseModel = await repo.onlineStatus(lat: currentPosition?.latitude.toString() ?? "", long: currentPosition?.longitude.toString() ?? "");
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == MyStrings.success) {
          if (model.data?.online.toString() == 'true') {
            userOnline.value = true;
          } else {
            userOnline.value = false;
          }
          isLoaderLoading = false;
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
  }

  Future<void> loadData() async {
    pendingRidesList = [];
    runningRide = RideModel(id: "-1");
    isLoading = true;
    update();

    rideList.clear();
    isLoading = true;
    update();

    ResponseModel responseModel = await repo.getData();

    if (responseModel.statusCode == 200) {
      DashBoardRideResponseModel model = DashBoardRideResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == MyStrings.success) {
        nextPageUrl = model.data?.ride?.nextPageUrl;
        userImagePath = '${UrlContainer.domainUrl}/${model.data?.userImagePath}';
        rideList.addAll(model.data?.ride?.data ?? []);
        pendingRidesList.addAll(model.data?.pendingRides ?? []);

        isDriverVerified = model.data?.driverInfo?.dv == "1" ? true : false;
        isVehicleVerified = model.data?.driverInfo?.vv == "1" ? true : false;

        isVehicleVerificationPending = model.data?.driverInfo?.vv == "2" ? true : false;
        isDriverVerificationPending = model.data?.driverInfo?.dv == "2" ? true : false;

        bool value = model.data?.driverInfo?.onlineStatus == "1" ? true : false;
        userOnline.value = value;

        driver = model.data?.driverInfo ?? GlobalDriverInfo(id: '-1');
        runningRide = model.data?.runningRide ?? RideModel(id: '-1');
        repo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userProfileKey, model.data?.driverInfo?.imageWithPath ?? '');

        profileImageUrl = "${UrlContainer.domainUrl}/${model.data?.driverImagePath}/${model.data?.driverInfo?.image}";

        update();
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  bool isSendLoading = false;
  Future<void> sendBid(String rideId) async {
    isSendLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.createBid(amount: mainAmount.toString(), id: rideId);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          Get.back();
          loadData();
          CustomSnackBar.success(successList: model.message ?? [MyStrings.somethingWentWrong]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printx(e);
    }
    isSendLoading = false;
    update();
  }

  updateMainAmount(double amount) {
    mainAmount = amount;
    amountController.text = mainAmount.toString();
    update();
  }

  checkAndGotoMapScreen() async {
    if (runningRide?.id != "-1") {
      Get.toNamed(RouteHelper.rideDetailsScreen, arguments: runningRide?.id ?? '-1');
    }
  }
}
