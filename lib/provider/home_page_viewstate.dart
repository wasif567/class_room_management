import 'package:flutter/material.dart';
import 'package:management/model/module.dart';
import 'package:management/view/app_theme/app_colors.dart';
import 'package:management/view/app_theme/app_images.dart';
import 'package:management/view/pages/class_room/class_room_list.dart';
import 'package:management/view/pages/registrations/registration_list.dart';
import 'package:management/view/pages/student/student_list.dart';
import 'package:management/view/pages/subject/subject_list.dart';

class HomePageViewstate extends ChangeNotifier {
  bool _isGridView = false;
  bool get isGridView => _isGridView;
  set isGridView(bool value) {
    _isGridView = value;
    notifyListeners();
  }

  List<Modules> _modules = [];
  List<Modules> get modules => _modules;
  set modules(List<Modules> value) {
    _modules = value;
    notifyListeners();
  }

  HomePageViewstate() {
    isGridView = true;
    List<String> moduleNames = ["Students", "Subjects", "Class rooms", "Registrations"];
    List<String> moduleImages = [
      AppImages.studentIcon,
      AppImages.bookIcon,
      AppImages.classIcon,
      AppImages.regIcon
    ];
    List<Widget> routes = [
      const StudentList(),
      const SubjectList(),
      const ClassRoomList(),
      const RegistrationList()
    ];
    List<Color> moduleColors = [
      AppColors.lightGreenColor,
      AppColors.subjectColor,
      AppColors.classRoomsColor,
      AppColors.registrationColor
    ];
    for (var i = 0; i < moduleNames.length; i++) {
      modules.add(
          Modules(color: moduleColors[i], text: moduleNames[i], icon: moduleImages[i], route: routes[i]));
    }
  }

  changeView() {
    isGridView = !isGridView;
  }
}
