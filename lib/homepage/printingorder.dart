import 'package:flutter/material.dart';
import 'package:printex_business_app/components.dart';

class PrintingOrderPage extends StatefulWidget {
  const PrintingOrderPage({super.key});

  @override
  State<PrintingOrderPage> createState() => _PrintingOrderPageState();
}

class _PrintingOrderPageState extends State<PrintingOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PrinTEXComponents().appBar('Printing Order', context, null, ),
      body: Center(child: const Text('Printing Order Page')),
    );
  }
}
