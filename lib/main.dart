import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'splash.dart';
import 'storage.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.i.load();
  runApp(const MonAutoApp());
}

class MonAutoApp extends StatelessWidget {
  const MonAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon auto',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: const Locale('fr'),
      supportedLocales: const [Locale('fr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashPage(),
    );
  }
}
