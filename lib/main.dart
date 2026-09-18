import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'expense_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Start loading any previously saved expenses right away. The splash
  // screen is shown for ~2 seconds, which is plenty of time for this to
  // finish before the user reaches the Dashboard/History screens — and
  // since ExpenseStore notifies its listeners when loading completes,
  // those screens will simply rebuild with the saved data if it's still
  // loading when they first appear.
  ExpenseStore.instance.load();
  runApp(const PaisaApp());
}

class PaisaApp extends StatelessWidget {
  const PaisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Khata',
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const KhataSplashScreen(),
    );
  }
}
