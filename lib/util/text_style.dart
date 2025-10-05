import 'package:flutter/material.dart';
import 'package:web3_wallet/util/colors.dart';
import 'package:web3_wallet/util/fonts.dart';

class AppTextStyle {
  // Headlines
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );
  //

  // Titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );
  //

  // Body
  static const TextStyle bodySemiBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );
  //

  // Descriptions
  static const TextStyle descriptionSemiBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );

  static const TextStyle descriptionRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );
  //

  // Notes
  static const TextStyle noteSemiBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );

  static const TextStyle noteRegular = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.poppins,
    fontFamilyFallback: [AppFont.kanit],
    color: AppColors.black,
  );
  //
}
