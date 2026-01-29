import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:freerasp/freerasp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../flavor.dart';

part 'freerasp_service.g.dart';

class FreeraspService {
  FreeraspService(this._talsec);
  final Talsec _talsec;

  Future<void> init() async {
    final packageName = F.packageName;

    // create a configuration for freeRASP
    final config = TalsecConfig(
      /// For Android
      androidConfig: AndroidConfig(
        packageName: packageName,
        signingCertHashes: [F.androidSigningCertHash],
        supportedStores: List.empty(),
        malwareConfig: MalwareConfig(
          blacklistedPackageNames: [packageName],
          suspiciousPermissions: [],
        ),
      ),

      /// For iOS
      iosConfig: IOSConfig(bundleIds: [packageName], teamId: F.iosTeamId),
      watcherMail: F.watcherMail,
      isProd: kReleaseMode || F.appFlavor == Flavor.prod,
      killOnBypass: true,
    );

    // start freeRASP
    await _talsec.start(config);

    final raspExecutionStateCallback = RaspExecutionStateCallback(
      onAllChecksDone: () => log("All checks done"),
    );

    // Attaching listener
    _talsec.attachExecutionStateListener(raspExecutionStateCallback);
  }

  void attachListener({
    void Function()? onAppIntegrity,
    void Function()? onObfuscationIssues,
    void Function()? onDebug,
    void Function()? onDeviceBinding,
    void Function()? onDeviceID,
    void Function()? onHooks,
    void Function()? onPasscode,
    void Function()? onPrivilegedAccess,
    void Function()? onSecureHardwareNotAvailable,
    void Function()? onSimulator,
    void Function()? onSystemVPN,
    void Function()? onDevMode,
    void Function()? onADBEnabled,
    void Function()? onUnofficialStore,
    void Function()? onScreenshot,
    void Function()? onScreenRecording,
    void Function()? onMultiInstance,
    void Function()? onUnsecureWiFi,
    void Function()? onLocationSpoofing,
    void Function()? onTimeSpoofing,
    void Function(List<SuspiciousAppInfo?>)? onMalware,
  }) {
    final callback = ThreatCallback(
      onAppIntegrity: onAppIntegrity,
      onObfuscationIssues: onObfuscationIssues,
      onDebug: onDebug,
      onDeviceBinding: onDeviceBinding,
      onDeviceID: onDeviceID,
      onHooks: onHooks,
      onPasscode: onPasscode{{#detect_passcode}} ?? () => _onThreat("Passcode not set"){{/detect_passcode}},
      onPrivilegedAccess: onPrivilegedAccess,
      onSecureHardwareNotAvailable: onSecureHardwareNotAvailable,
      onSimulator: onSimulator,
      onSystemVPN: onSystemVPN{{#detect_vpn}} ?? () => _onThreat("System VPN"){{/detect_vpn}},
      onDevMode: onDevMode,
      onADBEnabled: onADBEnabled,
      onUnofficialStore: onUnofficialStore,
      onScreenshot: onScreenshot{{#detect_screenshots}} ?? () => _onThreat("Screenshot"){{/detect_screenshots}},
      onScreenRecording:
          onScreenRecording{{#detect_screenrecord}} ?? () => _onThreat("Screen recording"){{/detect_screenrecord}},
      onMultiInstance: onMultiInstance,
      onUnsecureWiFi: onUnsecureWiFi,
      onLocationSpoofing: onLocationSpoofing,
      onTimeSpoofing: onTimeSpoofing,
      onMalware: onMalware,
    );

    _talsec.attachListener(callback);
  }

  void _onThreat(String threatType) {
    // TODO: Implement threat handling
    log(threatType);
  }
}

@Riverpod(keepAlive: true)
FreeraspService freeraspService(Ref ref) {
  return FreeraspService(Talsec.instance);
}
