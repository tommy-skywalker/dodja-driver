import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dodjaerrands_driver/core/helper/date_converter.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';
import 'package:dodjaerrands_driver/core/utils/util.dart';
import 'package:dodjaerrands_driver/data/controller/review/review_controller.dart';
import 'package:dodjaerrands_driver/data/repo/review/review_repo.dart';
import 'package:dodjaerrands_driver/data/services/api_service.dart';
import 'package:dodjaerrands_driver/presentation/components/app-bar/custom_appbar.dart';
import 'package:dodjaerrands_driver/presentation/components/divider/custom_spacer.dart';
import 'package:dodjaerrands_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/presentation/components/no_data.dart';
import 'package:dodjaerrands_driver/presentation/components/shimmer/transaction_card_shimmer.dart';

import '../../../core/helper/string_format_helper.dart';

class ReviewHistoryScreen extends StatefulWidget {
  const ReviewHistoryScreen({super.key});

  @override
  State<ReviewHistoryScreen> createState() => _ReviewHistoryScreenState();
}

class _ReviewHistoryScreenState extends State<ReviewHistoryScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ReviewRepo(apiClient: Get.find()));
    final controller = Get.put(ReviewController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      controller.getReview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: MyStrings.myRatings),
      backgroundColor: MyColor.colorWhite,
      body: GetBuilder<ReviewController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.only(left: Dimensions.space15, right: Dimensions.space15, top: Dimensions.space15),
            child: controller.isLoading
                ? ListView.builder(itemBuilder: (context, index) {
                    return TransactionCardShimmer();
                  })
                : (controller.reviews.isEmpty && controller.isLoading == false)
                    ? NoDataWidget()
                    : Container(
                        color: MyColor.colorWhite,
                        child: Column(
                          children: [
                            spaceDown(Dimensions.space20),
                            RatingBar.builder(
                              initialRating: double.tryParse(Get.arguments ?? "0") ?? 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star_rate_rounded,
                                color: Colors.amber,
                              ),
                              ignoreGestures: true,
                              itemSize: 50,
                              onRatingUpdate: (v) {},
                            ),
                            spaceDown(Dimensions.space5),
                            Text('${MyStrings.yourAverageRatingIs.tr} ${double.tryParse(Get.arguments ?? "0") ?? 0}'.toCapitalized(), style: boldDefault.copyWith(color: MyColor.getBodyTextColor().withOpacity(0.8))),
                            spaceDown(Dimensions.space20),
                            Align(alignment: AlignmentDirectional.centerStart, child: Text("${MyStrings.riderReviews.tr}", style: boldOverLarge.copyWith(fontWeight: FontWeight.w400, color: MyColor.getHeadingTextColor()))),
                            spaceDown(Dimensions.space10),
                            Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) => Container(color: MyColor.borderColor.withOpacity(0.5), height: 1),
                                itemCount: controller.reviews.length,
                                itemBuilder: (context, index) {
                                  final review = controller.reviews[index];
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyImageWidget(imageUrl: '${controller.imagePath}/${review.ride?.user?.avatar}', height: 50, width: 50, radius: 25, isProfile: true),
                                        SizedBox(width: Dimensions.space10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Expanded(child: Text('${review.ride?.user?.firstname ?? ''} ${review.ride?.user?.lastname ?? ''}'.toCapitalized(), style: boldDefault.copyWith(color: MyColor.primaryColor))),
                                                  spaceSide(Dimensions.space10),
                                                  Text("${DateConverter.isoStringToLocalDateOnly(review.createdAt ?? '')}", style: lightSmall.copyWith(color: MyColor.primaryTextColor)),
                                                ],
                                              ),
                                              SizedBox(height: Dimensions.space5),
                                              SizedBox(height: Dimensions.space5),
                                              RatingBar.builder(
                                                initialRating: StringConverter.formatDouble(review.rating ?? '0'),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: false,
                                                itemCount: 5,
                                                itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                                                itemBuilder: (context, _) => const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                ignoreGestures: true,
                                                itemSize: 16,
                                                onRatingUpdate: (v) {},
                                              ),
                                              SizedBox(height: Dimensions.space5),
                                              Text(review.review ?? '', style: lightDefault.copyWith()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }
}
