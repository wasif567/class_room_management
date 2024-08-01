import 'package:flutter/material.dart';
import 'package:management/provider/registration_viewstate.dart';
import 'package:management/view/app_theme/app_colors.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:management/view/pages/student/student_list.dart';
import 'package:management/view/pages/subject/subject_list.dart';
import 'package:provider/provider.dart';

class NewRegistration extends StatelessWidget {
  const NewRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context),
      body: Consumer<RegistrationViewstate>(builder: (context, state, child) {
        return SizedBox(
          height: kSize.height,
          width: kSize.width,
          child: Column(
            children: [studentTile(), subjectTile(), regBtn(context)],
          ),
        );
      }),
    );
  }

  Widget subjectTile() {
    return Consumer<RegistrationViewstate>(builder: (context, state, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(color: AppColors.greyColor, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectList(isReg: true)))
                  .then((value) {
                if (value != null) {
                  state.selectedSubject = value;
                }
              });
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              leading: Text(
                state.selectedSubject != null ? state.selectedSubject!.name : "Select a subject",
                style: AppTypography.sfProRegular.copyWith(fontSize: 17),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 32,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget studentTile() {
    return Consumer<RegistrationViewstate>(builder: (context, state, child) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16.0, left: 16, top: 32),
        child: DecoratedBox(
          decoration: BoxDecoration(color: AppColors.greyColor, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              if (!state.isRegLoading!) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentList(
                              isReg: true,
                            ))).then((value) {
                  if (value != null) {
                    state.selectedStudent = value;
                  }
                });
              }
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              leading: Text(
                state.selectedStudent != null ? state.selectedStudent!.name : "Select a student",
                style: AppTypography.sfProRegular.copyWith(fontSize: 17),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 32,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget regBtn(BuildContext context) {
    return Consumer<RegistrationViewstate>(builder: (context, state, child) {
      return Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 45.0),
        child: state.isRegLoading!
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.greenColor,
                ),
              )
            : TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: AppColors.greenColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  if (!state.isRegLoading!) {
                    await state.newRegistration(context).then((value) {
                      if (value) {
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: Text(
                  "Register",
                  style: AppTypography.sfProMedium.copyWith(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                )),
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
            "New Registration",
            style: AppTypography.sfProBold.copyWith(fontSize: 22),
          )),
    );
  }
}
