/// This screen displays the onboarding carousel for the Zarpay application.
///
/// The screen includes a series of onboarding images, a title, description,
/// and a button to proceed to the next screen. It uses a PageView to navigate
/// through the onboarding steps and displays an indicator for the current page.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zarpay/app/core/constants/constant.dart';
import 'package:zarpay/app/core/constants/textstyles.dart';
import 'package:zarpay/app/widgets/rounded_button.dart';
import 'package:zarpay/app/features/onboardings/presentation/view_model/onboarding_carousel_view_model.dart';

/// The main widget for the onboarding carousel screen.
class OnboardingCarouselScreen extends StatelessWidget {
  OnboardingCarouselScreen({super.key});

  /// The view model for managing the state and logic of the onboarding carousel.
  final OnboardingCarouselViewModel _model =
      Get.put(OnboardingCarouselViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      body: Obx(
        () => Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.loose,
          children: [
            // Background
            background(),
            // Top section with dynamic images
            topSection(),
            // Bottom section with text and controls
            bottomSection()
          ],
        ),
      ),
    );
  }

  /// Builds the background container for the screen.
  Widget background() {
    return Container(
      height: 1.sh - 336.h,
      decoration: const BoxDecoration(color: primaryColor),
    );
  }

  /// Builds the top section containing the PageView for the onboarding images.
  Widget topSection() {
    return Container(
      decoration: const BoxDecoration(color: primaryColor),
      child: PageView.builder(
        pageSnapping: true,
        controller: _model.pageController,
        onPageChanged: (value) {
          _model.setCurrentPageIndex(value);
        },
        itemCount: _model.onboardingCarousels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 50.h),
            child: Image.asset(
              _model.onboardingCarousels[index].imgUrl!,
              fit: BoxFit.fitHeight,
              height: 1.sh - 100.h,
              width: 1.sw,
            ),
          );
        },
      ),
    );
  }

  /// Builds the bottom section containing the title, description, and controls.
  Widget bottomSection() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 342.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.r),
            topRight: Radius.circular(32.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _model.onboardingCarousels[_model.currentPageIndex.value]
                      .title!,
                  textAlign: TextAlign.center,
                  style: headingTextStyle.copyWith(
                    height: 1.2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0.h,
                ),
                child: Text(
                  _model.onboardingCarousels[_model.currentPageIndex.value]
                      .description!,
                  textAlign: TextAlign.center,
                  style: bodyTextStyle.copyWith(
                    fontSize: 16.sp,
                    color: const Color(0XFFBDBDBD),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0.h),
                child: AnimatedSmoothIndicator(
                  activeIndex: _model.currentPageIndex.value,
                  count: _model.onboardingCarousels.length,
                  effect: ColorTransitionEffect(
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    dotColor: greyColor,
                    activeDotColor: activeDotColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0.h),
                child: RoundedButton(
                  textChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
                        style: buttonTextStyle,
                      ),
                    ],
                  ),
                  onPressed: () {
                    _model.onNextPressed();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
