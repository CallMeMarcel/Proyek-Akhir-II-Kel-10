import 'package:del_cafeshop/features/authentication/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  // Variables
  final PageController pageController = PageController();
  final RxInt currentPageIndex = 0.obs;

  // Update Current Index when page scroll
  void updatePageIndicator(int index) => currentPageIndex.value = index;

  // Jump to the specific dot selected page
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  // Update Current Index & Jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      Get.offAll(() => const LoginScreen()); // Use offAll to remove onboarding from stack
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  // Skip onboarding and go to login
  void skipPage() {
    currentPageIndex.value = 2;
    Get.offAll(() => const LoginScreen()); // Directly navigate to login
  }

  @override
  void onClose() {
    pageController.dispose(); // Prevent memory leaks
    super.onClose();
  }
}