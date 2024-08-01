import 'package:flutter/material.dart';
import 'package:management/common/snack_bar_widget.dart';
import 'package:management/model/classrooms_model.dart';
import 'package:management/model/subjects_model.dart';
import 'dart:math' as math;
import 'package:management/provider/class_room_page_viewstate.dart';
import 'package:management/provider/subject_page_viewstate.dart';
import 'package:management/view/app_theme/app_colors.dart';
import 'package:management/view/app_theme/app_images.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:management/view/pages/subject/subject_list.dart';
import 'package:provider/provider.dart';

class ClassRoomDetail extends StatelessWidget {
  const ClassRoomDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return Consumer<ClassRoomViewstate>(builder: (context, state, child) {
      return Scaffold(
        appBar: appBar(context),
        body: SizedBox(
          height: kSize.height,
          width: kSize.width,
          child: state.isLoading!
              ? const Center(
                  child: CircularProgressIndicator(
                  color: AppColors.greenColor,
                ))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        if (state.classroom != null) changeSubjectBtn(context, state.classroom!),
                        if (state.classroom != null && state.classroom!.layout == 'conference') ...{
                          conferenceLayOut(state.classroom!.size)
                        },
                        if (state.classroom != null && state.classroom!.layout == 'classroom') ...{
                          classRoomLayOut(state.classroom!.size)
                        },
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
  }

  Widget changeSubjectBtn(BuildContext context, ClassroomModel classDetail) {
    final kSize = MediaQuery.of(context).size;
    return Consumer<ClassRoomViewstate>(builder: (context, state, child) {
      return Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: SizedBox(
          width: kSize.width,
          child: TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14),
                  backgroundColor: AppColors.greyColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                SubjectPageViewstate viewstate = Provider.of<SubjectPageViewstate>(context, listen: false);
                viewstate.isFromClass = true;
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectList()))
                    .then((value) async {
                  if (value != null) {
                    //
                    SubjectModel sub = value;
                    classDetail.subject = sub.id;
                    await state.updateSubject(classDetail, context);
                  }
                });
              },
              child: Consumer<ClassRoomViewstate>(builder: (context, subjectState, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<ClassRoomViewstate>(builder: (context, state, child) {
                      if (state.subject != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subjectState.subject != null ? subjectState.subject!.name : "",
                              style: AppTypography.sfProRegular.copyWith(fontSize: 17),
                            ),
                            Text(
                              subjectState.subject != null ? subjectState.subject!.teacher : "",
                              style: AppTypography.sfProRegular.copyWith(fontSize: 13),
                            )
                          ],
                        );
                      } else {
                        return Text(
                          "Add Subject",
                          style: AppTypography.sfProRegular.copyWith(fontSize: 17),
                        );
                      }
                    }),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: AppColors.lightGreenColor, borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8.0),
                        child: Text(
                          state.subject != null ? "Change" : "Add",
                          style:
                              AppTypography.sfProRegular.copyWith(color: AppColors.greenColor, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                );
              })),
        ),
      );
    });
  }

  Widget conferenceLayOut(int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: List.generate(getStudentCount(count)[1], (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Image.asset(
                      AppImages.student,
                      height: 30,
                      width: 30,
                    ),
                  ),
                );
              }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: 140,
              color: AppColors.greyColor,
            ),
            Column(
              children: List.generate(getStudentCount(count).first, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.asset(
                    AppImages.student,
                    height: 30,
                    width: 30,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<int> getStudentCount(int count) {
    if (count % 2 == 0) {
      double students = count / 2;
      return [students.toInt(), students.toInt()];
    } else {
      // double students = count / 2;
      int part1 = count ~/ 2;
      int part2 = part1 + 1;
      return [part1, part2];
    }
  }

  Widget classRoomLayOut(int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        runAlignment: WrapAlignment.start,
        spacing: 13,
        runSpacing: 16,
        children: List.generate(count, (index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignOutside)),
            padding: const EdgeInsets.all(22.0),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Image.asset(
                AppImages.student,
                height: 24,
                width: 24,
              ),
            ),
          );
        }),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return AppBar(
      leading: const CustomBackBtn(),
      bottom: PreferredSize(
          preferredSize: Size(kSize.width, kSize.height * 0.06),
          child: Consumer<ClassRoomViewstate>(
            builder: (context, state, child) {
              return Text(
                state.classroom != null ? state.classroom!.name : "",
                style: AppTypography.sfProBold.copyWith(fontSize: 22),
              );
            },
          )),
    );
  }
}
