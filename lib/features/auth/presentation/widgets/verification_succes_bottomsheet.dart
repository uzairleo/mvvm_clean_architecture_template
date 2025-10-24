/// This widget displays a bottom sheet that shows a success message after verification.
///
/// The bottom sheet includes an image, a success message, a warning message, and a confirmation button.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zarpay/app/core/constants/textstyles.dart';
import 'package:zarpay/app/widgets/image_container.dart';
import 'package:zarpay/app/widgets/rounded_button.dart';

/// A stateless widget that represents the verification success bottom sheet.
///
/// The [onPressed] parameter is a callback function that is executed when the confirmation button is pressed.
class VerificationSuccessBottomSheet extends StatelessWidget {
  final void Function()? onPressed;

  const VerificationSuccessBottomSheet({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 386.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageContainer(
                  assets: "assets/images/success.png",
                  height: 152.h,
                  width: 152.w,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
            Text(
              "Verification Successful!",
              textAlign: TextAlign.center,
              style: headingTextStyle.copyWith(fontSize: 32.sp, height: 1.2),
            ),
            Text(
              "Remember, ZAR will never message you on WhatsApp asking for your private information.",
              textAlign: TextAlign.center,
              style: bodyTextStyle.copyWith(
                fontSize: 13.4.sp,
                color: const Color(0XFF9E9E9E),
              ),
            ),
            RoundedButton(
              textChild: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Confirm",
                    style: buttonTextStyle,
                  ),
                ],
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
