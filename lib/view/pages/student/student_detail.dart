import 'package:flutter/material.dart';
import 'package:management/provider/student_page_viewstate.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:provider/provider.dart';

class StudentDetail extends StatelessWidget {
  final int id;
  const StudentDetail({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    StudentViewState viewState = Provider.of<StudentViewState>(context);
    final kSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context),
      body: SizedBox(
        height: kSize.height,
        width: kSize.width,
        child: FutureBuilder(
            future: viewState.getStudentDetail(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              }
              if (snapshot.data != null && snapshot.data!.id > 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      clipBehavior: Clip.antiAlias,
                      height: 133,
                      width: 133,
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Image.network(
                        "https://fastly.picsum.photos/id/64/4326/2884.jpg?hmac=9_SzX666YRpR_fOyYStXpfSiJ_edO3ghlSRnH2w09Kg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      snapshot.data!.name,
                      style: AppTypography.sfProRegular.copyWith(fontSize: 22),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Age : ${snapshot.data!.age}",
                        style: AppTypography.sfProRegular.copyWith(fontSize: 22),
                      ),
                    ),
                    Text(
                      snapshot.data!.email,
                      style: AppTypography.sfProRegular.copyWith(fontSize: 17),
                    ),
                  ],
                );
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
    );
  }

  AppBar appBar(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return AppBar(
      leading: const CustomBackBtn(),
      bottom: PreferredSize(
          preferredSize: Size(kSize.width, kSize.height * 0.06),
          child: Text(
            "Student Detail",
            style: AppTypography.sfProBold.copyWith(fontSize: 22),
          )),
    );
  }
}
