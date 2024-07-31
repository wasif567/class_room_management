import 'package:flutter/material.dart';
import 'package:management/provider/class_room_page_viewstate.dart';
import 'package:management/view/app_theme/app_colors.dart';
import 'package:management/view/common_components/back_btn.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:management/view/pages/class_room/class_details.dart';
import 'package:provider/provider.dart';

class ClassRoomList extends StatelessWidget {
  const ClassRoomList({super.key});

  @override
  Widget build(BuildContext context) {
    ClassRoomViewstate viewstate = Provider.of<ClassRoomViewstate>(context);
    final kSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context),
      body: SizedBox(
        height: kSize.height,
        width: kSize.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: FutureBuilder(
              future: viewstate.getClassList(),
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
                            onTap: () async {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => const ClassRoomDetail()));
                              await viewstate.getClassroomDetail(snapshot.data![index].id);
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
                                    snapshot.data![index].layout,
                                    style: AppTypography.sfProRegular.copyWith(fontSize: 13),
                                  )
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    "${snapshot.data![index].size}",
                                    style: AppTypography.sfProRegular.copyWith(fontSize: 17),
                                  ),
                                  Text(
                                    "Seats",
                                    style: AppTypography.sfProRegular.copyWith(fontSize: 13),
                                  )
                                ],
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
            "Class Rooms",
            style: AppTypography.sfProBold.copyWith(fontSize: 22),
          )),
    );
  }
}
