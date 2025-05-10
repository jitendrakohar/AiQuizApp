import 'package:get/get.dart';
import 'package:quiz_questions/modules/home/HomeController.dart';
import 'package:quiz_questions/modules/quiz/QuizController.dart';
import 'package:quiz_questions/modules/results/ResultsController.dart';
import 'package:quiz_questions/modules/home/HomeView.dart';
import 'package:quiz_questions/modules/quiz/QuizView.dart';
import 'package:quiz_questions/modules/results/ResultsView.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
      name: Routes.QUIZ,
      page: () => QuizView(),
      binding: BindingsBuilder(() {
        Get.put<QuizController>(QuizController());
      }),
    ),
    GetPage(
      name: Routes.RESULTS,
      page: () => const ResultsView(),
      binding: BindingsBuilder(() {
        Get.put<ResultsController>(ResultsController());
      }),
    ),
  ];
}

abstract class Routes {
  static const HOME = '/home';
  static const QUIZ = '/quiz';
  static const RESULTS = '/results';
}
