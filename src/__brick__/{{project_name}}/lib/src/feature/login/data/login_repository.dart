{{#use_dio}}
import 'package:dio/dio.dart';
{{/use_dio}}
import 'package:riverpod_annotation/riverpod_annotation.dart';
{{#use_dio}}
import '../../../../flavor.dart';
{{#use_firebase}}
import '../../../monitoring/error_log/error_log_facade.dart';
{{/use_firebase}}
import '../../../utils/data_source_config/dio/dio_config.dart';
import '../../authentication/data/auth_repository.dart';
{{/use_dio}}
{{^use_dio}}
{{#use_firebase}}
import '../../../utils/common_utils.dart';
{{/use_firebase}}
{{/use_dio}}
import '../domain/login_response.dart';

part 'login_repository.g.dart';

@riverpod
Future<LoginResponse> login(
  Ref ref, {
  required String username,
  required String password,
  required String recaptchaToken,
}) async {
  {{#use_dio}}
  try {
    final dio = ref.watch(dioConfigProvider);
    final response = await dio.post(
      '/api/v1/loginbystaffid',
      options: Options(headers: {'x-api-key': F.apiKey}),
      data: {
        'username': username,
        'password': password,
        'recaptchaToken': recaptchaToken,
        'fcmToken': await ref.watch(authRepositoryProvider).getFcmToken(),
        'language_id': '1',
      },
    );

    final result = LoginResponse.fromJson(response.data);
    // //save session
    // await ref
    //     .read(authRepositoryProvider)
    //     .saveSession(
    //       AppUser(
    //         username: username,
    //         accessToken: result.accessToken,
    //         refreshToken: result.refreshToken,
    //       ),
    //     );
    // //request notification permission and init local notification
    // await ref.read(firebaseServiceProvider).requestNotificationPermission();
    // await ref.read(localNotificationProvider).init();

    return result;
  } on DioException catch (error) {
    return onDioError(error);
  } catch (e, stackTrace) {
    {{#use_firebase}}
    // Record to Log Monitoring
    ref.read(errorLogFacadeProvider).nonFatalError(e, stackTrace);
    {{/use_firebase}}
    rethrow;
  }
  {{/use_dio}}
  {{^use_dio}}
  try {
    // TODO: Implement HTTP client of your choice (e.g., http package, chopper, etc.)
    throw UnimplementedError('Login not implemented. Please implement your HTTP client.');
  } catch (e, stackTrace) {
    // Record to Log Monitoring
    ref.read(errorLogFacadeProvider).nonFatalError(e, stackTrace);
    rethrow;
  }
  {{/use_dio}}
}
