import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

import '../../../common_widget/custom_snackbar.dart';
import '../../../routing/app_router.dart';
import '../../../service/freerasp/freerasp_service.dart';
import '../../../theme/app_color_theme.dart';
import '../../../theme/app_text_theme.dart';
import '../../berita/presentation/berita_subscreen.dart';
import '../../faq/presentation/faq_subscreen.dart';
import '../../home/presentation/home_subscreen.dart';
import '../../kegiatan/presentation/kegiatan_subscreen.dart';
import '../../laporan/presentation/laporan_subscreen.dart';

class MainNavScreen extends ConsumerWidget {
  const MainNavScreen({super.key, required this.currentIndex});

  static const String path = '/mainnav';

  final int currentIndex;

  Widget _buildBody() {
    return LazyLoadIndexedStack(
      index: currentIndex,
      children: const [
        HomeSubscreen(),
        BeritaSubscreen(),
        LaporanSubscreen(),
        KegiatanSubscreen(),
        FAQSubscreen(),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Threat detection listener to update UI
    ref
        .read(freeraspServiceProvider)
        .attachListener(
          {{#detect_passcode}}onPasscode: () => showThreatDialog(context, 'Passcode not set'),{{/detect_passcode}}
          {{#detect_vpn}}onSystemVPN: () => showThreatDialog(context, 'System VPN detected'),{{/detect_vpn}}
          {{#detect_screenshots}}onScreenshot: () =>
              showThreatDialog(context, 'Screenshot capture detected'),{{/detect_screenshots}}
          {{#detect_screenrecord}}onScreenRecording: () =>
              showThreatDialog(context, 'Screen recording detected'),{{/detect_screenrecord}}
        );

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColorTheme.primary500,
        unselectedItemColor: AppColorTheme.secondary100,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTextTheme.regularXs,
        unselectedLabelStyle: AppTextTheme.regularXs,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Berita'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Kegiatan'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'FAQ'),
        ],
        currentIndex: currentIndex,
        onTap: (selectedIndex) {
          if (currentIndex != selectedIndex) {
            context.goNamed(
              AppRoute.mainNav.name,
              pathParameters: {'currentIndex': '$selectedIndex'},
            );
          }
        },
      ),
    );
  }

  void showThreatDialog(BuildContext context, String threatType) {
    CustomSnackbar.show(context, CustomSnackbarMode.warning, threatType);
  }
}
