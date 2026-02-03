import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/device_info.dart';
import '../../../core/responsive/responsive_layout.dart';

class BeritaSubscreen extends ConsumerWidget {
  const BeritaSubscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ref.isMobile;
    log('isMobile: $isMobile');

    return const ResponsiveLayout(
      mobile: Placeholder(child: Text('Berita Subscreen Mobile')),
      tablet: Placeholder(child: Text('Berita Subscreen Tablet')),
      desktop: Placeholder(child: Text('Berita Subscreen Desktop')),
    );
  }
}
