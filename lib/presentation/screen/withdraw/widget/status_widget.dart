import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';

class StatusWidget extends StatelessWidget {
  final String status;
  final Color color;

  const StatusWidget({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(vertical: Dimensions.space3, horizontal: Dimensions.space8), alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: color.withOpacity(.1), border: Border.all(color: color, width: .5)), child: Text(status.tr, style: regularSmall.copyWith(color: color)));
  }
}
