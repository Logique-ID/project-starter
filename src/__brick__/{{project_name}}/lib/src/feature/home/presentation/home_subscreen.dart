import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widget/primary_button.dart';
import '../../../core/mixins/localization_mixin.dart';
import 'controller/home_event.dart';

class HomeSubscreen extends ConsumerWidget with HomeEvent, LocalizationMixin {
  const HomeSubscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = getLocalizations(ref);

    return Scaffold(
      body: Center(
        child: Column(
          spacing: 16,
          children: [
            const Text('Home Subscreen'),
            PrimaryButton(
              text: loc.login,
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
