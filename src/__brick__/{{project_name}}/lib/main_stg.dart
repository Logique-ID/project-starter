import 'firebase_options/firebase_options_stg.dart';
import 'flavor.dart';
import 'initializer.dart';

void main() async {
  F.appFlavor = Flavor.stg;
  await initializeApp(firebaseOptions: DefaultFirebaseOptions.currentPlatform);
}
