{{#use_firebase}}
import 'firebase_options/firebase_options_stg.dart';
{{/use_firebase}}
import 'flavor.dart';
import 'initializer.dart';

void main() async {
  F.appFlavor = Flavor.stg;
  await initializeApp({{#use_firebase}}firebaseOptions: DefaultFirebaseOptions.currentPlatform{{/use_firebase}});
}
