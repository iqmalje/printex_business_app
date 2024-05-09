import 'package:flutter/material.dart';
import 'package:printex_business_app/components.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrinTEXComponents()
          .appBar('PrinTEX Registered', context, null, showInfo: true),
      body: Center(child: Text('PrinTEX Registered Page')),
    );
  }
}
