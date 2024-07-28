import 'package:flutter/material.dart';
import 'package:management/model/module.dart';
import 'package:management/view/app_theme/app_colors.dart';
import 'package:management/view/app_theme/app_images.dart';

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
    List<Color> moduleColors = [
      AppColors.studentColor,
      AppColors.subjectColor,
      AppColors.classRoomsColor,
      AppColors.registrationColor
    ];
    for (var i = 0; i < moduleNames.length; i++) {
      modules.add(Modules(color: moduleColors[i], text: moduleNames[i], icon: moduleImages[i]));
    }
  }

  changeView() {
    isGridView = !isGridView;
  }
}
