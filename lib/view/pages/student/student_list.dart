import 'package:flutter/material.dart';
import 'package:management/provider/student_page_viewstate.dart';
import 'package:management/view/app_theme/app_colors.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:management/view/pages/student/student_detail.dart';
import 'package:provider/provider.dart';

class StudentList extends StatelessWidget {
  final bool? isReg;
  const StudentList({super.key, this.isReg = false});

  @override
  Widget build(BuildContext context) {
    StudentViewState studentViewState = Provider.of<StudentViewState>(context);
    final kSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context),
      body: SizedBox(
        height: kSize.height,
        width: kSize.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: FutureBuilder(
              future: studentViewState.getStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return ListView.separated(
                      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 32),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: AppColors.greyColor, borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                          child: InkWell(
                            onTap: () {
                              if (isReg!) {
                                Navigator.pop(context, snapshot.data![index]);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentDetail(id: snapshot.data![index].id)));
                              }
                            },
                            child: ListTile(
                              minVerticalPadding: 0,
                              contentPadding: EdgeInsets.zero,
                              leading: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index].name,
                                    style: AppTypography.sfProRegular.copyWith(fontSize: 17),
                                  ),
                                  Text(
                                    snapshot.data![index].email,
                                    style: AppTypography.sfProRegular.copyWith(fontSize: 13),
                                  )
                                ],
                              ),
                              trailing: Text(
                                "Age : ${snapshot.data![index].age}",
                                style: AppTypography.sfProRegular.copyWith(fontSize: 17),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 16,
                        );
                      },
                      itemCount: snapshot.data!.length);
                } else {
                  return Center(
                    child: Text(
                      "No Data",
                      style: AppTypography.sfProRegular.copyWith(fontSize: 17),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return AppBar(
      leading: const CustomBackBtn(),
      bottom: PreferredSize(
          preferredSize: Size(kSize.width, kSize.height * 0.06),
          child: Text(
            "Students",
            style: AppTypography.sfProBold.copyWith(fontSize: 22),
          )),
    );
  }
}
