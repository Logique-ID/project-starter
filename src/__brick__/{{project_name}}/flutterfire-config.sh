#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors
# Feel free to reuse and adapt this script for your own projects

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev', 'stg', or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config \
      --project={{firebase_project_id}} \
      --out=lib/firebase_options/firebase_options_dev.dart \
      --ios-bundle-id={{app_id}}.dev \
      --ios-out=ios/flavors/dev/GoogleService-Info.plist \
      --ios-build-config=Debug-dev \
      --android-package-name={{app_id}}.dev \
      --android-out=android/app/src/dev/google-services.json \
      --platforms=android,ios \
      --yes
    ;;
  stg)
    flutterfire config \
      --project={{firebase_project_id}} \
      --out=lib/firebase_options/firebase_options_stg.dart \
      --ios-bundle-id={{app_id}}.stg \
      --ios-out=ios/flavors/stg/GoogleService-Info.plist \
      --ios-build-config=Debug-stg \
      --android-package-name={{app_id}}.stg \
      --android-out=android/app/src/stg/google-services.json \
      --platforms=android,ios \
      --yes
    ;;
  prod)
    flutterfire config \
      --project={{firebase_project_id}} \
      --out=lib/firebase_options/firebase_options_prod.dart \
      --ios-bundle-id={{app_id}} \
      --ios-out=ios/flavors/prod/GoogleService-Info.plist \
      --ios-build-config=Debug-prod \
      --android-package-name={{app_id}} \
      --android-out=android/app/src/prod/google-services.json \
      --platforms=android,ios \
      --yes
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev', 'stg', or 'prod'."
    exit 1
    ;;
esac
