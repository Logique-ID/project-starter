import 'dart:developer';

import 'package:flutter/material.dart';

import '../theme/app_color_theme.dart';

enum CustomSnackbarMode { error, success, warning }

class CustomSnackbar {
  static show(
    BuildContext context,
    CustomSnackbarMode mode,
    String textContent, {
    int durationInSeconds = 15,
    SnackBarAction? action,
  }) {
    Color backgroundColor;

    if (mode == CustomSnackbarMode.error) {
      backgroundColor = AppColorTheme.alert500;
    } else if (mode == CustomSnackbarMode.success) {
      backgroundColor = AppColorTheme.success500;
    } else {
      backgroundColor = AppColorTheme.warning500;
    }

    final snackBar = SnackBar(
      content: Text(
        textContent,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: mode == CustomSnackbarMode.warning
              ? AppColorTheme.neutral500
              : AppColorTheme.white,
        ),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSeconds),
      action:
          action ??
          SnackBarAction(
            label: 'close',
            textColor: mode == CustomSnackbarMode.warning
                ? AppColorTheme.neutral500
                : AppColorTheme.white,
            onPressed: () {
              try {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              } catch (e) {
                log('Snackbar cannot be closed due to different context');
              }
            },
          ),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
