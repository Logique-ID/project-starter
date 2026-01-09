import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

import '../../../constant/constants.dart';
import 'sembast_codec.dart';

part 'sembast_config.g.dart';

class SembastDatabase {
  SembastDatabase(this.db);
  final Database db;
  final store = StoreRef.main();
}

@Riverpod(keepAlive: true)
Future<SembastDatabase> sembastDatabase(Ref ref) async {
  const fileName = 'default.db';

  Database db;
  if (!kIsWeb) {
    final appDocDir = await getApplicationDocumentsDirectory();
    final codec = getEncryptSembastCodec(password: Constants.dbKey);
    db = await databaseFactoryIo.openDatabase(
      '${appDocDir.path}/$fileName',
      codec: codec,
    );
  } else {
    db = await databaseFactoryWeb.openDatabase(fileName);
  }

  return SembastDatabase(db);
}
