{{#use_firebase}}
import 'firebase_options/firebase_options_prod.dart';
{{/use_firebase}}
import 'flavor.dart';
import 'initializer.dart';

void main() async {
  F.appFlavor = Flavor.prod;
  await initializeApp({{#use_firebase}}firebaseOptions: DefaultFirebaseOptions.currentPlatform{{/use_firebase}});
}
