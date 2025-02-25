import 'dart:convert';

import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/url_container.dart';
import 'package:dodjaerrands_driver/data/model/review/review_history_response_model.dart';
import 'package:dodjaerrands_driver/data/repo/review/review_repo.dart';
import 'package:dodjaerrands_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

class ReviewController extends GetxController {
  ReviewRepo repo;
  ReviewController({required this.repo});

  bool isLoading = true;
  List<Review> reviews = [];
  String imagePath = "";

  Future<void> getReview() async {
    isLoading = true;
    update();
    try {
      final responseModel = await repo.getReviews();
      if (responseModel.statusCode == 200) {
        ReviewHistoryResponseModel model = ReviewHistoryResponseModel.fromJson(jsonDecode(responseModel.responseJson));
        if (model.status == "success") {
          reviews.addAll(model.data?.reviews ?? []);
          imagePath = "${UrlContainer.domainUrl}/${model.data?.userImagePath}";
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
    } finally {
      isLoading = false;
      update();
    }
  }
}
