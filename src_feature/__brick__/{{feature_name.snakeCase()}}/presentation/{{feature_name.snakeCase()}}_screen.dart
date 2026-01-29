import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/{{feature_name.snakeCase()}}_event.dart';
import 'controller/{{feature_name.snakeCase()}}_state.dart';

class {{feature_name.pascalCase()}}Screen extends ConsumerWidget with {{feature_name.pascalCase()}}Event, {{feature_name.pascalCase()}}State {
  const {{feature_name.pascalCase()}}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Placeholder(child: Text('{{feature_name.pascalCase()}} Screen'));
  }
}