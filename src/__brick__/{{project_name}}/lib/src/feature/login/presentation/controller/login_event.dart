{{#use_firebase}}import 'dart:async';{{/use_firebase}}

import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

{{#use_firebase}}import '../../../../monitoring/analytics_facade.dart';{{/use_firebase}}
import '../../../../utils/common_utils.dart';
import 'login_controller.dart';

mixin class LoginEvent {
  void login(
    WidgetRef ref, {
    required String keyLoginUsername,
    required String keyLoginPassword,
    required GlobalKey<FormBuilderState> formKey,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.saveAndValidate()) {
      try {
        {{#use_firebase}}unawaited(ref.read(analyticsFacadeProvider).trackLogin());{{/use_firebase}}
        final values = formKey.currentState!.value;

        final String username = values[keyLoginUsername];
        final String password = values[keyLoginPassword];
        final String recaptchaToken = ''; //TODO get recaptcha token
        await ref
            .watch(loginControllerProvider.notifier)
            .login(
              username: username,
              password: password,
              recaptchaToken: recaptchaToken,
            );

        ref.invalidate(loginControllerProvider);
      } catch (e, st) {
        CommonUtils.printAndRecordLog(e, st.toString());
      }
    }
  }
}
