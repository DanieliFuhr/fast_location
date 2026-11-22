
import 'package:flutter/material.dart';

import 'src/modules/initial/page/initial_page.dart';
import 'src/shared/colors/app_theme.dart';
import 'src/shared/storage/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o armazenamento local.
  await LocalStorage.initialize();

  // Inicia o aplicativo.
  runApp(const FastLocationApp());
}

class FastLocationApp extends StatelessWidget {
  const FastLocationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastLocation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const InitialPage(),
    );
  }
}
