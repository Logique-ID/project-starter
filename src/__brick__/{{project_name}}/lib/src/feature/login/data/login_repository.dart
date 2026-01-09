import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../flavor.dart';
import '../../../utils/data_source_config/dio/dio_config.dart';
import '../../authentication/data/auth_repository.dart';
import '../domain/login_response.dart';

part 'login_repository.g.dart';

@riverpod
Future<LoginResponse> login(
  Ref ref, {
  required String username,
  required String password,
  required String recaptchaToken,
}) async {
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
  } catch (e) {
    rethrow;
  }
}
