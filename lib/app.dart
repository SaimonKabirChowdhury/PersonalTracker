import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/jarvis_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/module_screen.dart';

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JARVIS Personal OS',
      theme: AppTheme.light(),
      home: const JarvisShell(),
    );
  }
}

class JarvisShell extends StatelessWidget {
  const JarvisShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JarvisProvider>(
      builder: (context, provider, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: provider.activeModule == null
              ? const HomeScreen(key: ValueKey('home-screen'))
              : ModuleScreen(
                  key: ValueKey(provider.activeModule!.id),
                  detail: provider.activeModule!,
                ),
        );
      },
    );
  }
}
