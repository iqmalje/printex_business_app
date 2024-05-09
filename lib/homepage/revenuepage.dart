import 'package:flutter/material.dart';
import 'package:printex_business_app/components.dart';

class eWalletPage extends StatefulWidget {
  const eWalletPage({super.key});

  @override
  State<eWalletPage> createState() => _eWalletPageState();
}

class _eWalletPageState extends State<eWalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrinTEXComponents().appBar('Revenue', context, null),
      body: Center(child: Text('Revenue Page')),
    );
  }
}
