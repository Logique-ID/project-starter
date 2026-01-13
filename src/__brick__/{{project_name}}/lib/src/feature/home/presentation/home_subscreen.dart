import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widget/primary_button.dart';
{{#use_localization}}
import '../../../core/mixins/localization_mixin.dart';
{{/use_localization}}
{{^use_localization}}
import '../../../localization/string_hardcoded.dart';
{{/use_localization}}
import 'controller/home_event.dart';

class HomeSubscreen extends ConsumerWidget with HomeEvent{{#use_localization}}, LocalizationMixin{{/use_localization}} {
  const HomeSubscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    {{#use_localization}}
    final loc = getLocalizations(ref);
    {{/use_localization}}

    return Scaffold(
      body: Center(
        child: Column(
          spacing: 16,
          children: [
            const Text('Home Subscreen'),
            PrimaryButton(
              text: {{#use_localization}}loc.login{{/use_localization}}{{^use_localization}}'Login'.hardcoded{{/use_localization}},
              onPressed: () {
                goToLogin(ref);
              },
            ),
          ],
        ),
      ),
    );
  }
}
