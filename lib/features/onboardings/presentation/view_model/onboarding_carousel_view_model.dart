/// ViewModel for the Onboarding Carousel screen.
///
/// This class manages the state and logic for the onboarding carousel,
/// including the current page index, handling page transitions, and navigating
/// to the next screen upon completion of the onboarding process.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zarpay/app/features/auth/presentation/views/whatsapp_auth_screen.dart';
import 'package:zarpay/app/features/onboardings/data/models/onboarding_carousel_model.dart';

/// The OnboardingCarouselViewModel class extends GetxController to manage the state and logic for the onboarding carousel.
class OnboardingCarouselViewModel extends GetxController {
  /// List of onboarding carousels to be displayed.
  List<OnboardingCarousel> onboardingCarousels = [];

  /// Observable integer to keep track of the current page index.
  RxInt currentPageIndex = 0.obs;

  /// PageController to manage the PageView.
  PageController? pageController;

  /// Called when the controller is initialized.
  @override
  void onInit() {
    super.onInit();
    currentPageIndex = 0.obs;
    pageController = PageController();
    getOnboardings();
  }

  /// Sets the current page index.
  ///
  /// [value] The new page index.
  void setCurrentPageIndex(int value) {
    currentPageIndex.value = value;
  }

  /// Handles the logic for the "Next" button press.
  ///
  /// If the user is not on the last page, it moves to the next page.
  /// If the user is on the last page, it navigates to the WhatsappAuthScreen.
  void onNextPressed() {
    if (currentPageIndex.value < onboardingCarousels.length - 1) {
      currentPageIndex.value++;
      pageController!.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      final String? referralCode = Get.arguments as String?;
      Get.to(
        () => const WhatsappAuthScreen(),
        transition: Transition.rightToLeft,
        arguments: referralCode,
      );
    }
  }

  /// Initializes the list of onboarding carousels.
  void getOnboardings() {
    onboardingCarousels.add(OnboardingCarousel(
      title: "Save and Spend Digital Dollars",
      description:
          "Use Digital Dollars to Secure Your Savings and Simplify Your Spending.",
      imgUrl: "assets/images/carousel-image1.png",
    ));
    onboardingCarousels.add(OnboardingCarousel(
      title: "Shop Online With USD Virtual Cards",
      description:
          "No more foreign exchange fees when you shop pay for things in USD.",
      imgUrl: "assets/images/carousel-image2.png",
    ));
    onboardingCarousels.add(OnboardingCarousel(
      title: "Pay Friends With Digital Dollars",
      description:
          "Send digital dollars to your friend’s phone number or \$username",
      imgUrl: "assets/images/carousel-image3.png",
    ));
  }
}
