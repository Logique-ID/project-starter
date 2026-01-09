import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../flavor.dart';
import '../constant/error_message.dart';
import '../utils/common_utils.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.customLoading,
    this.onError,
    this.skipRefreshLoading = true,
    this.skipError = false,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? customLoading;
  final Widget Function(Object, StackTrace)? onError;
  final bool skipRefreshLoading;
  final bool skipError;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      skipLoadingOnRefresh: skipRefreshLoading,
      skipError: skipError,
      error:
          onError ??
          (e, st) {
            CommonUtils.printAndRecordLog('$e', '$st');

            final isPrd = kReleaseMode || F.appFlavor == Flavor.prod;

            final errorMsg =
                e != ErrorMessage.noInternetMsg &&
                    e != ErrorMessage.requestTimeoutMsg
                ? '$e\n\n$st'
                : '$e';

            return Center(
              child: Text(
                isPrd ? ErrorMessage.defaultUnParseErrorMsg : errorMsg,
              ),
            );
          },
      loading: () =>
          Center(child: customLoading ?? const CircularProgressIndicator()),
    );
  }
}
