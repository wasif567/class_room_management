import 'package:flutter/material.dart';
import 'package:management/provider/registration_viewstate.dart';
import 'package:management/view/app_theme/app_colors.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:provider/provider.dart';

class RegistrationList extends StatelessWidget {
  const RegistrationList({super.key});

  @override
  Widget build(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context),
      body: SizedBox(
        height: kSize.height,
        width: kSize.width,
        child: Column(
          children: [],
        ),
      ),
    );
  }

  Widget regList(BuildContext context) {
    return Consumer<RegistrationViewstate>(builder: (context, state, child) {
      return Expanded(
        child: state.regList == null && state.regList!.isEmpty
            ? Text(
                "No Registrations",
                style: AppTypography.sfProRegular.copyWith(fontSize: 17),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return DecoratedBox(
                    decoration:
                        BoxDecoration(color: AppColors.greyColor, borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text("${state.regList![index].student}"),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 32,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(padding: EdgeInsets.only(bottom: 16));
                },
                itemCount: state.regList!.length),
      );
    });
  }

  AppBar appBar(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return AppBar(
      leading: const CustomBackBtn(),
      bottom: PreferredSize(
          preferredSize: Size(kSize.width, kSize.height * 0.1),
          child: Text(
            "Registration",
            style: AppTypography.sfProBold.copyWith(fontSize: 22),
          )),
    );
  }
}
