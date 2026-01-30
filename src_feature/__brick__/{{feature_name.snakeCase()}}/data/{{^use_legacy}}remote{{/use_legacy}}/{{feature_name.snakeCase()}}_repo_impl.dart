import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../{{feature_name.snakeCase()}}_repository.dart';

class Remote{{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  Remote{{feature_name.pascalCase()}}RepositoryImpl(this.ref);

  final Ref ref;

  // TODO: implement repository
}