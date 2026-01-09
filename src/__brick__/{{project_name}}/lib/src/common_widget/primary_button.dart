import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_color_theme.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_theme.dart';

/// Primary button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
  });
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final String? prefixIcon;
  final String? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: isLoading
          ? CircularProgressIndicator(color: AppColorTheme.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (prefixIcon != null) ...[
                  SvgPicture.asset(
                    prefixIcon!,
                    height: 28.sp,
                    width: 28.sp,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      AppColorTheme.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  gapW16,
                ],
                Text(
                  textAlign: TextAlign.center,
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.regularBase.copyWith(
                    color: AppColorTheme.white,
                  ),
                ),
                if (suffixIcon != null) ...[
                  gapW16,
                  SvgPicture.asset(
                    suffixIcon!,
                    height: 28.sp,
                    width: 28.sp,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      AppColorTheme.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
