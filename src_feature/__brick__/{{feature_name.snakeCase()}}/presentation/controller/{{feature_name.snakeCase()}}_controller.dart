{{^use_legacy}}import 'package:flutter_riverpod/flutter_riverpod.dart';{{/use_legacy}}
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/{{feature_name.snakeCase()}}_repository.dart';
{{^use_legacy}}import '../../data/remote/{{feature_name.snakeCase()}}_repo_impl.dart';{{/use_legacy}}

part '{{feature_name.snakeCase()}}_controller.g.dart';

@riverpod
class {{feature_name.pascalCase()}}Controller extends _${{feature_name.pascalCase()}}Controller {
  @override
  FutureOr<void> build() {}

  // TODO: implement controller
}

{{^use_legacy}}/// Interface for {{feature_name.pascalCase()}}Repository
final {{feature_name.camelCase()}}RepoProvider = Provider<{{feature_name.pascalCase()}}Repository>((ref) {
  return Remote{{feature_name.pascalCase()}}RepositoryImpl(ref);
});{{/use_legacy}}