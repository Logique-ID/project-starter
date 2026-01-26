import 'dart:developer';

import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../flavor.dart';
import '../../../constant/constants.dart';
import '../../../constant/error_message.dart';
import '../../../feature/authentication/data/auth_repository.dart';
import '../../../feature/login/domain/login_response.dart';
import '../../../monitoring/error_log/error_log_facade.dart';
import '../../common_utils.dart';

part 'dio_config.g.dart';

final _dioBaseOptions = BaseOptions(
  baseUrl: F.apiUrl,
  connectTimeout: const Duration(seconds: Constants.durationInSeconds),
  receiveTimeout: const Duration(seconds: Constants.durationInSeconds),
  sendTimeout: const Duration(seconds: Constants.durationInSeconds),
);

final aliceProvider = Provider<Alice>((ref) {
  return Alice(
    configuration: AliceConfiguration(
      showNotification: !kReleaseMode,
      showShareButton: !kReleaseMode,
    ),
  );
});

@Riverpod(keepAlive: true)
Dio dioConfig(Ref ref) {
  final dio = Dio(_dioBaseOptions);

  if (!kReleaseMode) {
    final alice = ref.watch(aliceProvider);
    final aliceDioAdapter = AliceDioAdapter();

    alice.addAdapter(aliceDioAdapter);

    dio.interceptors.add(aliceDioAdapter);
    dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ),
    );
  }

  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add x-api-key header to every request
        options.headers['x-api-key'] = F.apiKey;

        String? accessToken = ref
            .watch(authRepositoryProvider)
            .currentUser
            ?.accessToken;

        if (accessToken == null) return handler.next(options);

        // TODO: implement refresh token when API is ready
        // if (_isTokenExpired(accessToken)) {
        //   accessToken = await _getAccessTokenAfterRefresh(ref);
        // }
        options.headers['Authorization'] = 'Bearer $accessToken';

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Custom implementation error handling since API can return error code 200 but in the response it is not 200
        final responseData = response.data;
        if (responseData is Map && responseData.containsKey('code')) {
          final code = responseData['code'].toString();
          if (code != '200' || code != '2000') {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
              ),
            );
          }
        }
        return handler.next(response);
      },
      onError: (error, handler) {
        String msg = error.toString();
        try {
          if (error.response?.statusCode == 401) {
            ref.read(authRepositoryProvider).clearSession();
          }
        } catch (e) {
          msg = e.toString();
        }

        ref.read(errorLogFacadeProvider).nonFatalError(msg, error.stackTrace);

        return handler.next(error);
      },
    ),
  );

  return dio;
}

Future<String?> _getAccessTokenAfterRefresh(Ref ref) async {
  try {
    log('refresh token start');
    final currentUser = ref.watch(authRepositoryProvider).currentUser;

    final dioRefreshToken = Dio(_dioBaseOptions);
    dioRefreshToken.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ),
    );

    final response = await dioRefreshToken.get(
      '/bastk/refresh-token',
      options: Options(
        headers: {'Authorization': 'Bearer ${currentUser?.refreshToken}'},
      ),
    );

    final result = LoginResponse.fromJson(response.data);

    ref
        .read(authRepositoryProvider)
        .saveSession(
          currentUser!.copyWith(
            accessToken: result.accessToken,
            refreshToken: result.refreshToken,
          ),
        );

    log('refresh token success');
    return result.accessToken!;
  } catch (e, stackTrace) {
    ref.read(errorLogFacadeProvider).nonFatalError(e, stackTrace);
    await ref.read(authRepositoryProvider).clearSession();

    return null;
  }
}

bool _isTokenExpired(String token) {
  try {
    final tokenToJson = CommonUtils.decodeTokenAsJson(token);
    final expTime = tokenToJson['exp'] as int;

    final expiredTime = DateTime.fromMillisecondsSinceEpoch(expTime * 1000);

    return DateTime.now().isAfter(expiredTime);
  } catch (e) {
    return true;
  }
}

onDioError(DioException error) {
  if (error.type == DioExceptionType.badResponse) {
    String errorMessage = error.response!.data['message']
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
    throw errorMessage;
  } else if (error.type == DioExceptionType.cancel) {
    throw ErrorMessage.requestCancelled;
  } else if (error.type == DioExceptionType.badCertificate) {
    throw ErrorMessage.certificateNotApproved;
  } else if (error.type == DioExceptionType.connectionError) {
    throw ErrorMessage.noAddressAssociatedWithHostname;
  } else if (error.type == DioExceptionType.connectionTimeout) {
    throw ErrorMessage.requestTimeoutMsg;
  } else {
    throw ErrorMessage.defaultUnParseErrorMsg;
  }
}
