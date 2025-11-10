import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String bannerAsset = 'assets/images/home_banner.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Início')),
      body: SafeArea(
        top: false,
        child: SizedBox.expand(
          child: Image.asset(
            bannerAsset,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
