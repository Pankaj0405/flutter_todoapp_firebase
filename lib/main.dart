import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todoapp_firebase/controllers/auth_controller.dart';
import 'package:flutter_todoapp_firebase/screens/signup_screen.dart';
import 'package:flutter_todoapp_firebase/services/theme_services.dart';
import 'package:flutter_todoapp_firebase/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone ',
      themeMode: ThemeService().theme,
      darkTheme: Themes.dark,
      theme: Themes.light,
      home: SignupScreen(),
    );
  }
}