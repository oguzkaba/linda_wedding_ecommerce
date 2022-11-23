// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:linda_wedding_ecommerce/core/constants/app/colors_constants.dart';
import 'package:lottie/lottie.dart';

import '../../extansions/asset_extansion.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final String lottieName;
  final double? height;
  const LoadingIndicatorWidget(
      {Key? key, required this.lottieName, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.myWhite,
        body: Center(child: Lottie.asset(lottieName.toLottie)));
  }
}
