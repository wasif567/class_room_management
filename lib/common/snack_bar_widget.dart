import 'package:flutter/material.dart';
import 'package:management/view/app_theme/app_typography.dart';

SnackBar snackBarWidget(String content, {Color? color, Duration? duration}) {
  return SnackBar(
    duration: duration ?? const Duration(seconds: 4),
    content: Text(
      content,
      textAlign: TextAlign.center,
      style: AppTypography.sfProMedium.copyWith(fontSize: 17, color: Colors.white),
    ),
    backgroundColor: color ?? Colors.red,
    behavior: SnackBarBehavior.floating,
  );
}
