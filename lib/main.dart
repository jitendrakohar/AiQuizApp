import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_questions/modules/home/HomeController.dart';
import 'package:quiz_questions/modules/quiz/QuizController.dart';
import 'package:quiz_questions/routes/AppPages.dart';
import 'package:quiz_questions/modules/home/HomeView.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_questions/utility/StorageService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.put(StorageService());
 await Get.put(HomeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      //  routes: AppPages.routes ,
      //   home: HomeView()
      getPages: AppPages.routes, // Use GetX routing
      initialRoute: AppPages.INITIAL, // Set initial route

    );
  }
}
