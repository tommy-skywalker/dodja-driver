import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/url_container.dart';
import 'package:dodjaerrands_driver/data/controller/ride/complete_ride/complete_ride_controller.dart';
import 'package:dodjaerrands_driver/data/repo/ride/ride_repo.dart';
import 'package:dodjaerrands_driver/data/services/api_service.dart';
import 'package:dodjaerrands_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:dodjaerrands_driver/presentation/components/no_data.dart';
import 'package:dodjaerrands_driver/presentation/components/shimmer/ride_shimmer.dart';
import 'package:dodjaerrands_driver/presentation/screens/ride_history/widget/complete_ride_card.dart';
import 'package:flutter/material.dart';
import 'package:dodjaerrands_driver/presentation/screens/ride_history/widget/review_bottom_sheet_widget.dart';

class AllRideSection extends StatefulWidget {
  final bool isInterCity;

  const AllRideSection({super.key, required this.isInterCity});

  @override
  State<AllRideSection> createState() => _AllRideSectionState();
}

class _AllRideSectionState extends State<AllRideSection> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<AllRideController>().hasNext()) {
        Get.find<AllRideController>().getAllRideList();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    final controller = Get.put(AllRideController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData(widget.isInterCity).then((v) {
        controller.getAllRideList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllRideController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.getAllRideList(p: 1);
          },
          backgroundColor: MyColor.primaryColor,
          color: MyColor.colorWhite,
          child: controller.isLoading
              ? SingleChildScrollView(
                  child: Column(children: List.generate(10, (index) => const RideShimmer())),
                )
              : controller.isLoading == false && controller.allRideList.isEmpty
                  ? NoDataWidget(isRide: true, text: MyStrings.sorryThereIsNoCompleteRideFound.tr)
                  : ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.space15),
                      itemCount: controller.allRideList.length,
                      reverse: false,
                      itemBuilder: (context, index) {
                        return AllRideCard(
                          currency: controller.defaultCurrencySymbol,
                          ride: controller.allRideList[index],
                          isPaymentDone: true,
                          isReviewDone: controller.allRideList[index].driverReview != null ? true : false,
                          imageUrl: '${UrlContainer.domainUrl}/${controller.imagePath}/${controller.allRideList[index].user?.avatar}',
                          reviewBtnCallback: () {
                            CustomBottomSheet(
                              child: ReviewBottomSheet(
                                controller: controller,
                                ride: controller.allRideList[index],
                              ),
                            ).customBottomSheet(context);
                          },
                        );
                      },
                    ),
        );
      },
    );
  }
}
