
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_icons.dart';
import '../image/custom_svg_picture.dart';

class CustomTimeLine extends StatelessWidget {
  Widget firstWidget;
  Widget secondWidget;
  bool? needScrolling;
  double? indicatorPosition;
  Color? dashColor;
  CustomTimeLine({
    super.key,
    required this.firstWidget,
    required this.secondWidget,
    this.needScrolling = false,
    this.dashColor,
    this.indicatorPosition = 0.40,
  });

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      shrinkWrap: true,

      theme: TimelineThemeData(
        nodePosition: 0,
        indicatorTheme: const IndicatorThemeData(size: 15.0, color: MyColor.colorBlack),
        indicatorPosition: indicatorPosition,
        nodeItemOverlap: false,
      ),

      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      // padding: const EdgeInsets.symmetric(vertical: 20.0),
      // physics: needScrolling! ? const PageScrollPhysics() : const NeverScrollableScrollPhysics(),
      builder: TimelineTileBuilder.connected(
        contentsBuilder: (context, index) => index == 0 ? firstWidget : secondWidget,
        connectorBuilder: (_, index, __) {
          return DashedLineConnector(
            color: dashColor ?? MyColor.colorBlack,
            thickness: .5,
          );
        },
        indicatorBuilder: (_, index) {
          return index == 0
              ? const CustomSvgPicture(
                  image: MyIcons.mapRed,
                  color: MyColor.colorRed,
                  height: 28,
                  width: 28,
                )
              : const CustomSvgPicture(
                  image: MyIcons.mapYellow,
                  color: MyColor.colorYellow,
                  height: 28,
                  width: 28,
                );
        },
        itemCount: 2,
      ),
    );
  }
}
