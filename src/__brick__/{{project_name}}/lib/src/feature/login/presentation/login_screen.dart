import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../common_widget/custom_snackbar.dart';
import '../../../common_widget/form/custom_text_form_field.dart';
import '../../../common_widget/primary_button.dart';
import '../../../common_widget/primary_outline_button.dart';
import '../../../core/mixins/localization_mixin.dart';
import '../../../localization/string_hardcoded.dart';
import '../../../theme/app_color_theme.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_text_theme.dart';
import 'controller/login_controller.dart';
import 'controller/login_event.dart';
import 'controller/login_state.dart';

class LoginScreen extends ConsumerWidget
    with LoginState, LoginEvent, LocalizationMixin {
  const LoginScreen({super.key});

  static const String path = 'login';

  static final _formKey = GlobalKey<FormBuilderState>();

  final String keyLoginUsername = 'username';
  final String keyLoginPassword = 'password';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(loginControllerProvider, (prev, next) {
      if (next is AsyncError) {
        if (!next.isRefreshing && next.hasError) {
          CustomSnackbar.show(
            context,
            CustomSnackbarMode.error,
            next.error.toString(),
          );
        }
      }
    });
    final loc = getLocalizations(ref);

    return Scaffold(
      appBar: AppBar(title: Text(loc.login), centerTitle: true),
      body: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                gapH16,
                Text(
                  'Silakan login'.hardcoded,
                  style: AppTextTheme.regularBase.copyWith(
                    color: AppColorTheme.neutral500,
                  ),
                  textAlign: TextAlign.center,
                ),
                gapH32,
                CustomTextFormField(
                  name: keyLoginUsername,
                  hintText: 'Input Username...'.hardcoded,
                  customValidator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.match(
                      RegExp(r'^[^\s]+$'),
                      errorText: 'Username cannot contain space'.hardcoded,
                    ),
                  ]),
                ),
                gapH16,
                CustomTextFormField(
                  name: keyLoginPassword,
                  hintText: 'Input Password...'.hardcoded,
                  isPassword: true,
                ),
                gapH24,
                Consumer(
                  builder: (context, consRef, child) {
                    final isLoading = isStateLoginLoading(consRef);
                    return PrimaryButton(
                      text: loc.login,
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () => login(
                              consRef,
                              keyLoginUsername: keyLoginUsername,
                              keyLoginPassword: keyLoginPassword,
                              formKey: _formKey,
                            ),
                    );
                  },
                ),
                gapH12,
                PrimaryOutlineButton(
                  text: 'Register'.hardcoded,
                  onPressed: () {
                    // TODO: Implement register action
                  },
                ),
                gapH8,
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement lupa kata sandi
                    },
                    child: Text(
                      'Lupa kata sandi'.hardcoded,
                      style: const TextStyle(color: CupertinoColors.activeBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
