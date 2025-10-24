/// This screen handles the WhatsApp authentication for the Zarpay application.
///
/// The screen includes a form where users can enter their phone number to receive
/// a verification code via WhatsApp. It uses GetX for state management and a
/// progress indicator while the authentication process is ongoing.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zarpay/app/core/constants/textstyles.dart';
import 'package:zarpay/app/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:zarpay/app/features/auth/presentation/widgets/intl_phone_field.dart';
import 'package:zarpay/app/widgets/image_container.dart';
import 'package:zarpay/app/widgets/rounded_button.dart';

/// A stateless widget that represents the WhatsApp authentication screen.
class WhatsappAuthScreen extends StatelessWidget {
  const WhatsappAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AuthViewModel>(
      init: AuthViewModel(),
      builder: (viewModel) {
        return ModalProgressHUD(
          inAsyncCall: viewModel.isLoading.value,
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Form(
              key: viewModel.createAccountScreenformkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      content(),
                      // TextField for entering number
                      customTextField(viewModel),
                    ],
                  ),
                  buttons(
                    onVerifyTap: () async {
                      await viewModel.onSendOtpPressed();
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the content section of the screen.
  Widget content() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 56.0.w),
      child: Column(
        children: [
          SizedBox(height: 84.h),
          ImageContainer(
            height: 152.h,
            width: 152.w,
            assets: "assets/images/whatsapp.png",
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 16.h),
          Text(
            "Continue with WhatsApp",
            textAlign: TextAlign.center,
            style: headingTextStyle.copyWith(fontSize: 32.sp, height: 1.2),
          ),
          SizedBox(height: 16.sp),
          Text(
            "We need to verify your phone number to make sure you’re a real human.",
            textAlign: TextAlign.center,
            style: bodyTextStyle.copyWith(
              fontSize: 14.sp,
              color: const Color(0XFF9E9E9E),
            ),
          ),
          SizedBox(height: 26.sp),
        ],
      ),
    );
  }

  /// Builds the custom text field for entering the phone number.
  ///
  /// [viewModel] The ViewModel managing the state and logic for the authentication.
  Widget customTextField(AuthViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntlPhoneField2(
            cursorColor: Colors.black,
            controller: viewModel.phoneNumberCtlr,
            flagsButtonPadding: EdgeInsets.only(left: 14.w),
            style: bodyTextStyle.copyWith(
              fontSize: 14.sp,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 16.h),
              isCollapsed: true,
              alignLabelWithHint: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              label: Text(
                "Input your phone number",
                style: bodyTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: Colors.grey.withOpacity(0.4),
                ),
              ),
              counterText: "",
              hintText: "Input your phone number",
              hintStyle: bodyTextStyle.copyWith(
                fontSize: 14.sp,
                color: Colors.grey.withOpacity(0.4),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
                borderSide: const BorderSide(color: Colors.red),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
                borderSide: const BorderSide(color: Colors.red),
              ),
              errorStyle: bodyTextStyle.copyWith(
                color: Colors.red,
                fontSize: 12.sp,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
                borderSide: BorderSide(
                  color: const Color(0XFFBDBDBD).withOpacity(0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
                borderSide: BorderSide(
                  color: const Color(0XFFBDBDBD).withOpacity(0.5),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
                borderSide: BorderSide(
                  color: const Color(0XFFBDBDBD).withOpacity(0.5),
                ),
              ),
            ),
            initialCountryCode: viewModel.getCountry.code,
            dropdownIcon: ImageContainer(
              assets: "assets/images/dropdown.png",
              fit: BoxFit.fitHeight,
              height: 6.67.h,
              width: 11.67.w,
            ),
            dropdownIconPosition: IconPosition.trailing,
            onCountryChanged: viewModel.onCountryChanged,
            dropdownTextStyle: bodyTextStyle.copyWith(fontSize: 14.sp),
            onSaved: (value) {},
            onChanged: (phone) {
              // Handle phone number change
            },
            autovalidateMode: AutovalidateMode.disabled,
            validator: (phoneNumber) async {
              if (!phoneNumber!.number.isPhoneNumber) {
                return "Please check your phone number";
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  /// Builds the button section for submitting the phone number.
  ///
  /// [onVerifyTap] The callback function to be executed when the verify button is pressed.
  Widget buttons({void Function()? onVerifyTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 26.h),
      child: Column(
        children: [
          RoundedButton(
            textChild: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Verify my Account",
                  style: buttonTextStyle,
                ),
              ],
            ),
            onPressed: onVerifyTap,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
