import 'firebase_options/firebase_options_prod.dart';
import 'flavor.dart';
import 'initializer.dart';

void main() async {
  F.appFlavor = Flavor.prod;
  await initializeApp(firebaseOptions: DefaultFirebaseOptions.currentPlatform);
}
