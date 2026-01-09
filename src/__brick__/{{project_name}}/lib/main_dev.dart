import 'firebase_options/firebase_options_dev.dart';
import 'flavor.dart';
import 'initializer.dart';

void main() async {
  F.appFlavor = Flavor.dev;
  await initializeApp(firebaseOptions: DefaultFirebaseOptions.currentPlatform);
}
