import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:{{project_name}}/flavor.dart';
import 'package:{{project_name}}/src/feature/authentication/data/auth_repository.dart';
import 'package:{{project_name}}/src/feature/authentication/domain/app_user.dart';
import 'package:{{project_name}}/src/feature/login/data/remote/local_login_repo_impl.dart';
import 'package:{{project_name}}/src/monitoring/error_log/error_log_facade.dart';
import 'package:{{project_name}}/src/utils/data_source_config/dio/dio_config.dart';

class MockDio extends Mock implements Dio {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockErrorLogFacade extends Mock implements ErrorLogFacade {}

class FakeAppUser extends Fake implements AppUser {}

// Helper provider to allow testing LoginRepoImpl with a valid Ref
final testLoginRepoImplProvider = Provider<RemoteLoginRepositoryImpl>((ref) {
  return RemoteLoginRepositoryImpl(ref);
});

void main() {
  late MockDio mockDio;
  late MockAuthRepository mockAuthRepository;
  late MockErrorLogFacade mockErrorLogFacade;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(FakeAppUser());
  });

  setUp(() {
    mockDio = MockDio();
    mockAuthRepository = MockAuthRepository();
    mockErrorLogFacade = MockErrorLogFacade();

    F.appFlavor = Flavor.dev;

    container = ProviderContainer(
      overrides: [
        dioConfigProvider.overrideWithValue(mockDio),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        errorLogFacadeProvider.overrideWithValue(mockErrorLogFacade),
      ],
    );

    // Stub error log to avoid strict mock errors
    when(
      () => mockErrorLogFacade.nonFatalError(any(), any()),
    ).thenAnswer((_) => Future.value());
  });

  tearDown(() {
    container.dispose();
  });

  group('LoginRepoImpl', () {
    const username = 'testuser';
    const password = 'password';
    const recaptchaToken = 'token';
    const fcmToken = 'fcm_token';

    test('should return LoginResponse when login is successful', () async {
      final responseData = {
        'access_token': 'access',
        'refresh_token': 'refresh',
      };

      // Mock FCM token retrieval
      when(
        () => mockAuthRepository.getFcmToken(),
      ).thenAnswer((_) async => fcmToken);

      // Mock Dio post request
      when(
        () => mockDio.post(
          any(),
          options: any(named: 'options'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/'),
          data: responseData,
          statusCode: 200,
        ),
      );

      // Mock save session
      // when(
      //   () => mockAuthRepository.saveSession(any()),
      // ).thenAnswer((_) async {});

      final loginRepo = container.read(testLoginRepoImplProvider);
      final result = await loginRepo.login(
        username: username,
        password: password,
        recaptchaToken: recaptchaToken,
      );

      expect(result.accessToken, 'access');
      expect(result.refreshToken, 'refresh');

      // Verify saveSession was called
      // verify(() => mockAuthRepository.saveSession(any())).called(1);
    });
  });
}
