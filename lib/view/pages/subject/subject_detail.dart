import 'package:flutter/material.dart';
import 'package:management/provider/subject_page_viewstate.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:provider/provider.dart';

class SubjectDetail extends StatelessWidget {
  final int id;
  const SubjectDetail({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    SubjectPageViewstate viewState = Provider.of<SubjectPageViewstate>(context);
    final kSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context),
      body: SizedBox(
        height: kSize.height,
        width: kSize.width,
        child: FutureBuilder(
            future: viewState.getSubjectDetail(id),
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
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.network(
                        "https://fastly.picsum.photos/id/78/1584/2376.jpg?hmac=80UVSwpa9Nfcq7sQ5kxb9Z5sD2oLsbd5zkFO5ybMC4E",
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
                        snapshot.data!.teacher,
                        style: AppTypography.sfProRegular.copyWith(fontSize: 22),
                      ),
                    ),
                    Text(
                      "Credit : ${snapshot.data!.credits}",
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
            "Subject Detail",
            style: AppTypography.sfProBold.copyWith(fontSize: 22),
          )),
    );
  }
}
