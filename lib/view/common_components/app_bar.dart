import 'package:flutter/material.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:management/view/app_theme/app_typography.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return AppBar(
      leading: const CustomBackBtn(),
      bottom: PreferredSize(
          preferredSize: Size(kSize.width, kSize.height * 0.1),
          child: Text(
            title,
            style: AppTypography.sfProMedium.copyWith(),
          )),
    );
  }
}
