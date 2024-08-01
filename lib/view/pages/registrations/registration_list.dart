import 'package:flutter/material.dart';
import 'package:management/provider/registration_viewstate.dart';
import 'package:management/view/app_theme/app_colors.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:management/view/pages/registrations/new_registration.dart';
import 'package:management/view/pages/registrations/registration_detail.dart';
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
          children: [
            regList(context),
            newRegBtn(),
          ],
        ),
      ),
    );
  }

  Widget newRegBtn() {
    return Consumer<RegistrationViewstate>(builder: (context, state, child) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 45.0),
        child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: AppColors.blueColor.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              state.registrationData();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewRegistration()));
            },
            child: Text(
              "New Registration",
              style: AppTypography.sfProMedium.copyWith(
                color: AppColors.blueColor,
                fontSize: 17,
              ),
            )),
      );
    });
  }

  Widget regList(BuildContext context) {
    return Consumer<RegistrationViewstate>(builder: (context, state, child) {
      return Expanded(
        child: state.isLoading!
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : state.regList == null || (state.regList != null && state.regList!.isEmpty)
                ? Center(
                    child: Text(
                      "No Registrations",
                      style: AppTypography.sfProRegular.copyWith(fontSize: 17),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        itemBuilder: (context, index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                                color: AppColors.greyColor, borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                              onTap: () async {
                                if (!state.isLoading!) {
                                  if (context.mounted) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => const RegistrationDetail()));
                                  }
                                  await state.getRegisteredDetail(state.regList![index].id);
                                }
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                leading: Text(
                                  "Registration Id : ${state.regList![index].id}",
                                  style: AppTypography.sfProRegular.copyWith(fontSize: 17),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 24,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Padding(padding: EdgeInsets.only(bottom: 16));
                        },
                        itemCount: state.regList!.length),
                  ),
      );
    });
  }

  AppBar appBar(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return AppBar(
      leading: const CustomBackBtn(),
      bottom: PreferredSize(
          preferredSize: Size(kSize.width, kSize.height * 0.05),
          child: Text(
            "Registration",
            style: AppTypography.sfProBold.copyWith(fontSize: 22),
          )),
    );
  }
}
