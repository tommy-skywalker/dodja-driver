import 'package:dodjaerrands_driver/core/utils/method.dart';
import 'package:dodjaerrands_driver/core/utils/url_container.dart';
import 'package:dodjaerrands_driver/data/model/global/response_model/response_model.dart';
import 'package:dodjaerrands_driver/data/services/api_service.dart';

class ReferenceRepo {
  ApiClient apiClient;
  ReferenceRepo({required this.apiClient});

  Future<ResponseModel> getReferData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.referenceEndPoint}";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
