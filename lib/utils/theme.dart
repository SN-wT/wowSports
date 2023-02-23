import 'package:flutter/material.dart';

import 'color_resource.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    extensions: [
      AppColors(
        backgroundColor: AppColorResource.Color_FFF,
        textColor: AppColorResource.Color_FFF,
        pageColor: AppColorResource.Color_FFF,
      )
    ],
  );

  static ThemeData darkTheme = ThemeData(
    extensions: [
      AppColors(
        backgroundColor: AppColorResource.Color_FFF,
        textColor: AppColorResource.Color_FFF,
        pageColor: AppColorResource.Color_FFF,
      )
    ],
  );
}

class AppColors extends ThemeExtension<AppColors> {
  final Color backgroundColor;
  final Color textColor;
  final Color pageColor;

  AppColors({
    this.backgroundColor,
    this.textColor,
    this.pageColor,
  });

  bool get isDarkTheme => backgroundColor == AppColorResource.Color_000;

  @override
  ThemeExtension<AppColors> copyWith() {
    return AppColors(
      backgroundColor: backgroundColor,
      textColor: textColor,
      pageColor: pageColor,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors> other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      backgroundColor: Color.lerp(backgroundColor, backgroundColor, t) ??
          AppColorResource.Color_FFF,
      textColor:
          Color.lerp(textColor, textColor, t) ?? AppColorResource.Color_000,
      pageColor:
          Color.lerp(pageColor, pageColor, t) ?? AppColorResource.Color_FFF,
    );
  }
}
