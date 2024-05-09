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
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Image.asset('assets/images/printer-amico.png'),
                const SizedBox(height: 10),
                const Text(
                  "No registered PrinTEX yet",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 10),
                const Text("Register PrinTEX now"),
              ],
            ),
          ),
        ));
  }
}
