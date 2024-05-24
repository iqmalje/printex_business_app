import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:printex_business_app/apm/apmdetail.dart';
import 'package:printex_business_app/backend/apmdao.dart';
import 'package:printex_business_app/components.dart';
import 'package:printex_business_app/apm/printexdetailinput.dart';
import 'package:printex_business_app/model/providers.dart';
import 'package:printex_business_app/model/apm.dart';
import 'package:provider/provider.dart';

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PrintDetailInput()));
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Center(
            child: FutureBuilder(
                future: ApmDAO().getRegisteredAPM(),
                builder: (context, snapshot) {
                  print(snapshot.error);
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  context
                      .read<ListAPMProvider>()
                      .changeAPM(newAPM: snapshot.data!);
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/printer-amico.png'),
                          const SizedBox(height: 10),
                          const Text(
                            "No registered PrinTEX yet",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          const Text("Register PrinTEX now"),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return buildPrinter(snapshot.data!.elementAt(index));
                        });
                  }
                })));
  }

  Widget buildPrinter(APM apm) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => APMPage(
                  apm: apm,
                )));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 15),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: 100, // Height of the first row
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        248, 238, 238, 238), // Background color
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: const Offset(0, 1), // Offset
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Image.network(apm.pictureUrl),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  apm.printerName, //text AKAN OVERFLOWWWWWWW
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  "${apm.city}, ${apm.state}", //text AKAN OVERFLOWWWWWWW
                                  style: TextStyle(
                                      color: Color.fromRGBO(99, 99, 99, 1)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Container(
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(apm.isActive
                                          ? 'Active'
                                          : 'Maintenance')),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
