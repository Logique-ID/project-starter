import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_color_theme.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_theme.dart';

class PrimaryOutlineButton extends StatelessWidget {
  const PrimaryOutlineButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.borderAndTextColor = const Color(
      0xFF0057D9,
    ), //AppColorTheme.primary500
    this.backgroundColor = const Color(0xFFFFFFFF), //AppColorTheme.white
    this.isBorderRequired = true,
  });

  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final String? prefixIcon;
  final String? suffixIcon;
  final Color borderAndTextColor;
  final Color backgroundColor;
  final bool isBorderRequired;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        overlayColor: borderAndTextColor,
        padding: const EdgeInsets.all(12),
        side: isBorderRequired ? BorderSide(color: borderAndTextColor) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: isLoading
          ? CircularProgressIndicator(color: borderAndTextColor)
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
                      borderAndTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  gapW16,
                ],
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.regularBase.copyWith(
                    color: borderAndTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
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
