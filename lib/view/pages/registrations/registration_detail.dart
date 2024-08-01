import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:management/common/snack_bar_widget.dart';
import 'package:management/main.dart';
import 'package:management/provider/registration_viewstate.dart';
import 'package:management/view/app_theme/app_colors.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:provider/provider.dart';

class RegistrationDetail extends StatelessWidget {
  const RegistrationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context),
      body: Consumer<RegistrationViewstate>(builder: (context, state, child) {
        return SizedBox(
          height: kSize.height,
          width: kSize.width,
          child: state.isLoading! && state.registration == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 16),
                        child: studentDetail(),
                      ),
                      subjectDetail(),
                      const Spacer(),
                      deleteReg(context),
                    ],
                  ),
                ),
        );
      }),
    );
  }

  Widget deleteReg(BuildContext ctxt) {
    return Consumer<RegistrationViewstate>(builder: (context, state, child) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 45.0),
        child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text(
                    'Delete',
                    style: AppTypography.sfProMedium.copyWith(fontSize: 17, color: Colors.black),
                  ),
                  content: Text('Do you want to delete?',
                      style: AppTypography.sfProMedium.copyWith(fontSize: 17, color: Colors.black)),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(ctxt);
                      },
                      child: Text('No',
                          style:
                              AppTypography.sfProMedium.copyWith(fontSize: 17, color: AppColors.blueColor)),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () async {
                        await state.deleteRegistration(state.registration!.id, context).then((value) {
                          if (value) {
                            Navigator.pop(ctxt);
                            Navigator.pop(ctxt);
                          }
                        });
                      },
                      child: Text(
                        'Yes',
                        style: AppTypography.sfProMedium.copyWith(fontSize: 17, color: AppColors.blueColor),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              "Delete Registration",
              style: AppTypography.sfProMedium.copyWith(
                color: Colors.white,
                fontSize: 17,
              ),
            )),
      );
    });
  }

  Widget studentDetail() {
    return Consumer<RegistrationViewstate>(builder: (context, state, child) {
      return DecoratedBox(
        decoration: BoxDecoration(color: AppColors.greyColor, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Student details",
                style: AppTypography.sfProRegular.copyWith(fontSize: 17),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  state.selectedStudent!.name,
                  style: AppTypography.sfProRegular.copyWith(fontSize: 13),
                ),
              ),
              Text(
                state.selectedStudent!.email,
                style: AppTypography.sfProRegular.copyWith(fontSize: 13),
              ),
            ],
          ),
          trailing: Text(
            "Age : ${state.selectedStudent!.age}",
            style: AppTypography.sfProRegular.copyWith(fontSize: 17),
          ),
        ),
      );
    });
  }

  Widget subjectDetail() {
    return Consumer<RegistrationViewstate>(builder: (context, state, child) {
      return DecoratedBox(
        decoration: BoxDecoration(color: AppColors.greyColor, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Subject Details",
                style: AppTypography.sfProRegular.copyWith(fontSize: 17),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  state.selectedSubject!.name,
                  style: AppTypography.sfProRegular.copyWith(fontSize: 13),
                ),
              ),
              Text(
                state.selectedSubject!.teacher,
                style: AppTypography.sfProRegular.copyWith(fontSize: 13),
              ),
            ],
          ),
          trailing: Text(
            "Credit: ${state.selectedSubject!.credits}",
            style: AppTypography.sfProRegular.copyWith(fontSize: 17),
          ),
        ),
      );
    });
  }

  AppBar appBar(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return AppBar(
      leading: const CustomBackBtn(),
      bottom: PreferredSize(
          preferredSize: Size(kSize.width, kSize.height * 0.06),
          child: Text(
            "Registration Detail",
            style: AppTypography.sfProBold.copyWith(fontSize: 22),
          )),
    );
  }
}
