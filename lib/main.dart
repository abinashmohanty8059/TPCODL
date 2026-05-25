import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qxdydzgzlryqjzvneegy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF4ZHlkemd6bHJ5cWp6dm5lZWd5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk2MjI1MzQsImV4cCI6MjA5NTE5ODUzNH0.BjGDyE51nLxBOoPVLmBlrazUCYZGkTD-BfVsuohX6mI',
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TPCODLApp());
}

class TPCODLApp extends StatelessWidget {
  const TPCODLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TPCODL Intern Learning Hub',
      debugShowCheckedModeBanner: false,
      theme: TPTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const MainShell(),
      },
    );
  }
}
