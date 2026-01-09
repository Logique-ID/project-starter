import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../constant/assets_constant.dart';
import '../../theme/app_color_theme.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_theme.dart';
import '../../utils/common_utils.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.name,
    this.title,
    this.hintText,
    this.initialValue,
    this.isEnable = true,
    this.isPassword = false,
    this.isSearch = false,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.customValidator,
    this.maxLength,
    this.onChanged,
    this.suffixText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.isMandatory = true,
    this.textDirection,
    this.onSuffixIconTapped,
    this.capitalizeAll = false,
    this.identifierSuffixIcon,
    this.inputFormatters,
    this.isWithThousandSeparator = true,
    this.isRequireBorder = true,
    this.subtitle,
    this.textAlign = TextAlign.start,
    this.hideDigitCounter = false,
  });

  final String name;
  final String? title;
  final String? subtitle;
  final String? hintText;
  final String? initialValue;
  final bool isEnable;
  final bool isPassword;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? customValidator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmitted;
  final void Function(String?)? onSuffixIconTapped;
  final String? suffixText;
  final String? prefixIcon;
  final String? suffixIcon;
  final bool isSearch;
  final bool isMandatory;
  final TextDirection? textDirection;
  final bool capitalizeAll;
  final String? identifierSuffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool isWithThousandSeparator;
  final bool isRequireBorder;
  final TextAlign textAlign;
  final bool hideDigitCounter;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final _controller = TextEditingController();
  bool _isObscureText = true;

  String? initialValue;

  int state = 0;

  @override
  void initState() {
    initialValue = widget.initialValue;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.title != null)
          Column(
            children: [
              Text(
                widget.isMandatory && widget.isEnable
                    ? '*${widget.title}'
                    : '${widget.title}',
                style: AppTextTheme.regularSm.copyWith(
                  color: AppColorTheme.blackRock500,
                ),
              ),
              gapH8,
            ],
          ),
        if (!CommonUtils.isEmpty(widget.subtitle))
          Column(
            children: [
              Text(
                widget.subtitle!,
                style: AppTextTheme.regularXs.copyWith(
                  color: AppColorTheme.blackRock300,
                ),
              ),
              gapH8,
            ],
          ),
        FormBuilderTextField(
          textAlignVertical: TextAlignVertical.center,
          textAlign: widget.textAlign,
          inputFormatters: [
            if (widget.keyboardType == TextInputType.number &&
                widget.isWithThousandSeparator) ...[
              FilteringTextInputFormatter.digitsOnly,
              _ThousandsSeparatorInputFormatter(),
            ],
            if (widget.capitalizeAll) UpperCaseTextFormatter(),
            if (widget.maxLength != null)
              LengthLimitingTextInputFormatter(widget.maxLength),
            ...?widget.inputFormatters,
          ],
          valueTransformer: widget.keyboardType == TextInputType.number
              ? (value) {
                  String? finalValue = value?.replaceAll(',', '');
                  return finalValue;
                }
              : null,
          controller: initialValue != null ? null : _controller,
          style: AppTextTheme.regularSm.copyWith(
            color: AppColorTheme.blackRock300,
          ),
          name: widget.name,
          textDirection: widget.textDirection,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          textInputAction: widget.isSearch ? TextInputAction.search : null,
          obscureText: !widget.isPassword ? false : _isObscureText,
          enabled: widget.isEnable,
          initialValue: initialValue,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintMaxLines: 1,
            hintStyle: AppTextTheme.regularSm.copyWith(
              color: AppColorTheme.blackRock100,
            ),
            suffixText: widget.suffixText,
            counter: widget.maxLength != null && !widget.hideDigitCounter
                ? null
                : const SizedBox.shrink(),
            errorMaxLines: 2,
            errorStyle: AppTextTheme.regularSm.copyWith(
              color: AppColorTheme.alert500,
              fontSize: 12.sp,
            ),
            errorBorder: widget.isRequireBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColorTheme.alert500),
                  )
                : InputBorder.none,
            border: widget.isRequireBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColorTheme.primary300),
                  )
                : InputBorder.none,
            fillColor: !widget.isEnable
                ? AppColorTheme.blackRock50
                : AppColorTheme.white,
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelStyle: AppTextTheme.regularSm.copyWith(
              color: AppColorTheme.blackRock300,
            ),
            enabledBorder: widget.isRequireBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColorTheme.blackRock100),
                  )
                : InputBorder.none,
            disabledBorder: widget.isRequireBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColorTheme.blackRock100),
                  )
                : InputBorder.none,
            focusedBorder: widget.isRequireBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColorTheme.primary500,
                      width: 1,
                    ),
                  )
                : InputBorder.none,
            prefixIcon: widget.prefixIcon != null
                ? SvgPicture.asset(
                    widget.prefixIcon!,
                    colorFilter: ColorFilter.mode(
                      AppColorTheme.blackRock100,
                      BlendMode.srcIn,
                    ),
                    height: 24.sp,
                    width: 24.sp,
                    fit: BoxFit.scaleDown,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null || widget.isPassword
                ? InkWell(
                    key: Key(widget.identifierSuffixIcon ?? ''),
                    child: SvgPicture.asset(
                      widget.isPassword
                          ? _isObscureText
                                ? AssetsConstant.iconEyeSlash
                                : AssetsConstant.iconEye
                          : widget.suffixIcon!,
                      colorFilter: ColorFilter.mode(
                        AppColorTheme.blackRock100,
                        BlendMode.srcIn,
                      ),
                      height: 24.sp,
                      width: 24.sp,
                      fit: BoxFit.scaleDown,
                    ),
                    onTap: () {
                      if (widget.isPassword) {
                        setState(() {
                          _isObscureText = !_isObscureText;
                        });
                      } else {
                        if (widget.onSuffixIconTapped != null) {
                          widget.onSuffixIconTapped?.call(_controller.text);
                        }
                      }
                    },
                  )
                : null,
          ),
          validator:
              widget.customValidator ??
              ((widget.isMandatory && widget.isEnable)
                  ? FormBuilderValidators.required()
                  : null),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            if (state > 100) state = 0;
            state++;
            int localState = state;
            Future.delayed(const Duration(milliseconds: 500)).then((_) {
              if (localState != state) {
                return;
              }

              widget.onChanged?.call(value);
            });
          },
          onSubmitted: widget.onSubmitted,
        ),
      ],
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty or the same as the old value, return it as is
    if (newValue.text.isEmpty || oldValue.text == newValue.text) {
      return newValue;
    }

    // Remove all non-digit characters
    final newValueText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Format the number with thousands separators
    final formattedText = CommonUtils.addThousandsSeparator(newValueText);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
