import 'package:flutter/material.dart';
import 'package:management/provider/home_page_viewstate.dart';
import 'package:management/view/app_theme/app_images.dart';
import 'package:management/view/app_theme/app_typography.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final kSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(kSize),
        body: Consumer<HomePageViewstate>(
          builder: (context, state, child) {
            return SizedBox(
              height: kSize.height,
              width: kSize.width,
              child: state.isGridView ? gridView() : listView(),
            );
          },
        ));
  }

  AppBar appBar(Size kSize) {
    return AppBar(
      toolbarHeight: kSize.height * 0.1,
      leadingWidth: kSize.width * 0.5,
      leading: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16.0),
        child: RichText(
            text:
                TextSpan(text: "Hello,\n", style: AppTypography.sfProBold.copyWith(fontSize: 28), children: [
          TextSpan(
            text: TimeOfDay.now().hour < 12
                ? "Good Morning"
                : TimeOfDay.now().hour < 19
                    ? "Good Afternoon"
                    : "Good Evening",
            style: AppTypography.sfProRegular.copyWith(fontSize: 22),
          )
        ])),
      ),
      actions: [
        Consumer<HomePageViewstate>(
          builder: (context, state, child) {
            return TextButton(
              onPressed: () {
                state.changeView();
              },
              child: state.isGridView
                  ? Image.asset(
                      AppImages.gridIcon,
                      height: 32,
                      width: 32,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.menu,
                      size: 32,
                      color: Colors.black,
                    ),
            );
          },
        )
      ],
    );
  }

  Widget gridView() {
    // List<String> gridList = ["Students", "Subjects", "Class rooms", "Registrations"];
    return Consumer<HomePageViewstate>(
      builder: (context, state, child) {
        return Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 28,
            children: List.generate(state.modules.length, (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => state.modules[index].route!));
                },
                child: Container(
                  height: 216,
                  width: 175,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: state.modules[index].color,
                  ),
                  // color: Colors.teal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(
                        flex: 3,
                      ),
                      Image.asset(
                        state.modules[index].icon,
                        height: 48,
                        width: 48,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        state.modules[index].text,
                        style: AppTypography.sfProMedium,
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget listView() {
    return Consumer<HomePageViewstate>(
      builder: (context, state, child) {
        return Center(
          child: ListView.separated(
              padding: const EdgeInsets.only(top: 131),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => state.modules[index].route!));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: state.modules[index].color,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      state.modules[index].text,
                      style: AppTypography.sfProSemiBold.copyWith(fontSize: 17),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Padding(padding: EdgeInsets.only(bottom: 40));
              },
              itemCount: state.modules.length),
        );
      },
    );
  }
}
