import 'package:flutter/material.dart';
import 'package:management/provider/class_room_page_viewstate.dart';
import 'package:management/provider/home_page_viewstate.dart';
import 'package:management/provider/registration_viewstate.dart';
import 'package:management/provider/student_page_viewstate.dart';
import 'package:management/provider/subject_page_viewstate.dart';
import 'package:management/view/pages/home_page/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageViewstate()),
        ChangeNotifierProvider(create: (_) => StudentViewState()),
        ChangeNotifierProvider(create: (_) => SubjectPageViewstate()),
        ChangeNotifierProvider(create: (_) => ClassRoomViewstate()),
        ChangeNotifierProvider(create: (_) => RegistrationViewstate()),
      ],
      child: MaterialApp(
        title: 'Class Room Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
