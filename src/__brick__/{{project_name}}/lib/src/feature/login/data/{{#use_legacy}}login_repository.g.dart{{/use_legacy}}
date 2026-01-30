// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(login)
const loginProvider = LoginFamily._();

final class LoginProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoginResponse>,
          LoginResponse,
          FutureOr<LoginResponse>
        >
    with $FutureModifier<LoginResponse>, $FutureProvider<LoginResponse> {
  const LoginProvider._({
    required LoginFamily super.from,
    required ({String username, String password, String recaptchaToken})
    super.argument,
  }) : super(
         retry: null,
         name: r'loginProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loginHash();

  @override
  String toString() {
    return r'loginProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<LoginResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoginResponse> create(Ref ref) {
    final argument =
        this.argument
            as ({String username, String password, String recaptchaToken});
    return login(
      ref,
      username: argument.username,
      password: argument.password,
      recaptchaToken: argument.recaptchaToken,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LoginProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loginHash() => r'909de13f8f9179304acace44094aabeb6c7e3b78';

final class LoginFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<LoginResponse>,
          ({String username, String password, String recaptchaToken})
        > {
  const LoginFamily._()
    : super(
        retry: null,
        name: r'loginProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoginProvider call({
    required String username,
    required String password,
    required String recaptchaToken,
  }) => LoginProvider._(
    argument: (
      username: username,
      password: password,
      recaptchaToken: recaptchaToken,
    ),
    from: this,
  );

  @override
  String toString() => r'loginProvider';
}
