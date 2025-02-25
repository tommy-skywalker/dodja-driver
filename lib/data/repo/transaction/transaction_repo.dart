import 'dart:convert';

import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:dodjaerrands_driver/core/utils/method.dart';
import 'package:dodjaerrands_driver/core/utils/url_container.dart';
import 'package:dodjaerrands_driver/data/model/global/response_model/response_model.dart';
import 'package:dodjaerrands_driver/data/model/global/user/global_driver_model.dart';
import 'package:dodjaerrands_driver/data/model/profile/profile_response_model.dart';
import 'package:dodjaerrands_driver/data/services/api_service.dart';

class TransactionRepo {
  ApiClient apiClient;
  TransactionRepo({required this.apiClient});

  Future<ResponseModel> getTransactionList(int page, {String type = "", String remark = "", String searchText = "", String walletType = ''}) async {
    if (type.toLowerCase() == "all" || (type.toLowerCase() != 'plus' && type.toLowerCase() != 'minus')) {
      type = '';
    }

    if (remark.isEmpty || remark.toLowerCase() == "all") {
      remark = '';
    }

    String url = '${UrlContainer.baseUrl}${UrlContainer.transactionEndpoint}?page=$page&type=$type&remark=$remark&search=$searchText';
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<GlobalDriverInfo> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';

    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      ProfileResponseModel model = ProfileResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == 'success') {
        printx('model.data.driver.balance ${model.data?.driver?.balance}');
        return model.data?.driver ?? GlobalDriverInfo();
      } else {
        return GlobalDriverInfo(id: '-1');
      }
    } else {
      return GlobalDriverInfo(id: '-1');
    }
  }
}
