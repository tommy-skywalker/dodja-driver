import 'package:geolocator/geolocator.dart';
import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:dodjaerrands_driver/core/utils/method.dart';
import 'package:dodjaerrands_driver/core/utils/url_container.dart';
import 'package:dodjaerrands_driver/core/utils/util.dart';
import 'package:dodjaerrands_driver/data/model/global/response_model/response_model.dart';
import 'package:dodjaerrands_driver/data/services/api_service.dart';

class RideRepo {
  ApiClient apiClient;
  RideRepo({required this.apiClient});
  Future<ResponseModel> getNewRide({required bool isICity}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=${isICity ? '2' : '1'}&status=new";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getRideDetails(String id) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideDetails}/$id";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> acceptedRide({required bool isICity}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=${isICity ? '2' : '1'}&status=accept";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> activeRide({required bool isICity}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=${isICity ? '2' : '1'}&status=2";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> runningRide({required bool isICity}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=${isICity ? '2' : '1'}&status=3";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getAllRideList(String page, {required bool isICity}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=${isICity ? '2' : '1'}&page=$page";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> startRide({
    required String id,
    required String otp,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.startRides}/$id";
    Map<String, String> params = {
      'otp': otp,
    };
    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> endRide({
    required String id,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.endRides}/$id";
    Position position = await MyUtils.getCurrentLocation();
    Map<String, String> params = {
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
    };
    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> acceptCashPayment({
    required String id,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.acceptCashPaymentRides}/$id";

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> completedRide() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.completedRides}";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> canceledRide(String page, {required bool isICity}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.rideList}?ride_type=${isICity ? '2' : '1'}&status=9";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> createBid({required String rideId, required String amount}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.createBid}/$rideId";
    Map<String, String> params = {'rideId': rideId, 'bid_amount': amount};
    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> reviewRide({
    required String id,
    required String review,
    required String rating,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.reviewRide}/$id";
    Map<String, String> params = {'review': review, 'rating': rating};
    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> updateLocation({required String id}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.liveLocation}/$id";
    final location = await MyUtils.getCurrentLocation();
    Map<String, String> params = {'latitude': location.latitude.toString(), 'longitude': location.longitude.toString()};
    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    printx(responseModel.responseJson);
    return responseModel;
  }

  Future<ResponseModel> cancelRide({
    required String id,
    required String reason,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.cancelBid}/$id";
    Map<String, String> params = {'cancel_reason': reason};
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, params, passHeader: true);
    return responseModel;
  }
}
