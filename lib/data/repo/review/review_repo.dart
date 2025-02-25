import 'package:dodjaerrands_driver/core/utils/method.dart';
import 'package:dodjaerrands_driver/core/utils/url_container.dart';
import 'package:dodjaerrands_driver/data/model/global/response_model/response_model.dart';
import 'package:dodjaerrands_driver/data/services/api_service.dart';

class ReviewRepo {
  ApiClient apiClient;
  ReviewRepo({required this.apiClient});

  Future<ResponseModel> getReviews() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.reviewHistoryEndPoint}";
    final response = await apiClient.request(url, Method.getMethod, {}, passHeader: true);
    return response;
  }
}
