import 'package:dundermifflinapp/components/splash.dart';
import 'package:flutter/material.dart';
import 'package:dundermifflinapp/pages/product/product.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashPage(),
      routes: {
        '/product': (context) => const ProductPage(),
      },
    );
  }
}
