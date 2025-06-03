import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final caraouselCurrentIndex = 0.obs;

  void updatePageIndicator(index){
    caraouselCurrentIndex.value =index;
  }
}