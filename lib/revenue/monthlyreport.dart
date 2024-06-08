import 'dart:io';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_pdf/export_delegate.dart';
import 'package:flutter_to_pdf/export_frame.dart';
import 'package:printex_business_app/backend/orderdao.dart';
import 'package:printex_business_app/backend/transactionDAO.dart';
import 'package:printex_business_app/components.dart';

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

int monthSelected = DateTime.now().month, yearSelected = DateTime.now().year;

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final ExportDelegate exportDelegate = ExportDelegate(
      ttfFonts: {'Poppins': 'assets/fonts/Poppins/Poppins-Regular.ttf'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PrinTEXComponents().appBarWithBackButton('Monthly Report', context),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: DropdownMenu(
                    onSelected: (value) {
                      if (value == null) return;
                      setState(() {
                        monthSelected = value;
                      });
                    },
                    initialSelection: monthSelected,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<int>(value: 1, label: 'January'),
                      DropdownMenuEntry<int>(value: 2, label: 'February'),
                      DropdownMenuEntry<int>(value: 3, label: 'March'),
                      DropdownMenuEntry<int>(value: 4, label: 'April'),
                      DropdownMenuEntry<int>(value: 5, label: 'May'),
                      DropdownMenuEntry<int>(value: 6, label: 'June'),
                      DropdownMenuEntry<int>(value: 7, label: 'July'),
                      DropdownMenuEntry<int>(value: 8, label: 'August'),
                      DropdownMenuEntry<int>(value: 9, label: 'September'),
                      DropdownMenuEntry<int>(value: 10, label: 'October'),
                      DropdownMenuEntry<int>(value: 11, label: 'November'),
                      DropdownMenuEntry<int>(value: 12, label: 'December'),
                    ]),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: DropdownMenu(
                    onSelected: (value) {
                      if (value == null) return;
                      setState(() {
                        yearSelected = value;
                      });
                    },
                    initialSelection: yearSelected,
                    dropdownMenuEntries: List.generate(
                        30,
                        (index) => DropdownMenuEntry<int>(
                            value: (DateTime.now().year - index),
                            label: '${(DateTime.now().year - index)}'))),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ExportFrame(
            frameId: 'monthlyReport',
            exportDelegate: exportDelegate,
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              decoration: BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PrinTEX Monthly Report',
                      style: PrinTEXComponents().getTextStyle(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildTitleAndContent('Month and Year',
                        '${monthNames[monthSelected - 1]} $yearSelected'),
                    FutureBuilder(
                        future: OrderDAO().getBriefOrderInfo(
                            timeSelected:
                                DateTime(yearSelected, monthSelected)),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTitleAndContent(
                                    'Total Number of Created Orders', '0'),
                                buildTitleAndContent(
                                    'Total Number of Successful Orders', '0'),
                                buildTitleAndContent(
                                    'Total Number of Failed Orders', '0'),
                              ],
                            );
                          }
                          print("entah");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTitleAndContent(
                                  'Total Number of Created Orders',
                                  snapshot.data!['total_order'].toString()),
                              buildTitleAndContent(
                                  'Total Number of Successful Orders',
                                  snapshot.data!['successful_order']
                                      .toString()),
                              buildTitleAndContent(
                                  'Total Number of Failed Orders',
                                  snapshot.data!['failed_order'].toString()),
                            ],
                          );
                        }),
                    FutureBuilder(
                        future: OrderDAO().getBriefRevenueInfo(
                            timeSelected:
                                DateTime(yearSelected, monthSelected)),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTitleAndContent(
                                    'Total Number of Payments', '0'),
                                buildTitleAndContent(
                                    'Total Number of Customers', '0'),
                                buildTitleAndContent(
                                    'Total Number of Revenue', '0'),
                              ],
                            );
                          }
                          print("entah");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTitleAndContent('Total Number of Payments',
                                  snapshot.data!['payments'].toString()),
                              buildTitleAndContent('Total Number of Customers',
                                  snapshot.data!['customers'].toString()),
                              buildTitleAndContent('Total Number of Revenue',
                                  snapshot.data!['revenue'].toStringAsFixed(2)),
                            ],
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    PrinTEXComponents().filledButton(
                        MediaQuery.sizeOf(context).width * 0.8,
                        'Download report', () async {
                      var what = await exportDelegate
                          .exportToPdfDocument('monthlyReport');
                      var bytes = await what.save();

                      await DocumentFileSavePlus().saveFile(
                          bytes,
                          'monthlyReport_${monthNames[monthSelected - 1]}_$yearSelected.pdf',
                          'application/pdf');

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Report successfully downloaded!')));
                    })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitleAndContent(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: PrinTEXComponents()
              .getTextStyle(fontSize: 12, color: const Color(0xFF636363)),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          content,
          style: PrinTEXComponents()
              .getTextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
