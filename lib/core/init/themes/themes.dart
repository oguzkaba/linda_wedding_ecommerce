import 'package:flutter/material.dart';
import 'package:linda_wedding_ecommerce/core/constants/app/colors_constants.dart';

class AppTheme {
  static AppTheme? _instance;
  static AppTheme get instance {
    _instance ??= AppTheme._init();
    return _instance!;
  }

  AppTheme._init();

  ThemeData get lightTheme => ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Montserrat',
            ),
        primaryTextTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Montserrat',
            ),
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: ColorConstants.primaryColor),
        appBarTheme: _appBarTheme,
        bottomNavigationBarTheme: _bottomNavBarTheme,
        expansionTileTheme: _expansionTileTheme,
      );

  ExpansionTileThemeData get _expansionTileTheme => ExpansionTileThemeData(
        backgroundColor: ColorConstants.myWhite,
        collapsedBackgroundColor: ColorConstants.myWhite,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
      );

  BottomNavigationBarThemeData get _bottomNavBarTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.myWhite,
        // selectedIconTheme: ,
        // unselectedIconTheme: ,
        selectedLabelStyle: const TextStyle(fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        type: BottomNavigationBarType.fixed,
      );

  AppBarTheme get _appBarTheme => AppBarTheme(
      toolbarHeight: 40,
      iconTheme: IconThemeData(color: ColorConstants.primaryColor),
      actionsIconTheme: IconThemeData(color: ColorConstants.primaryColor),
      backgroundColor: ColorConstants.myWhite,
      titleTextStyle: TextStyle(
          color: ColorConstants.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold));
}
