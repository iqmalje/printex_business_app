import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printex_business_app/apm/printexdetailinput_edit.dart';
import 'package:printex_business_app/backend/orderdao.dart';
import 'package:printex_business_app/components.dart';
import 'package:printex_business_app/model/providers.dart';
import 'package:printex_business_app/model/apm.dart';
import 'package:printex_business_app/model/order.dart';
import 'package:provider/provider.dart';

class PrintingOrderPage extends StatefulWidget {
  const PrintingOrderPage({super.key});

  @override
  State<PrintingOrderPage> createState() => _PrintingOrderPageState();
}

class _PrintingOrderPageState extends State<PrintingOrderPage> {
  bool isDashboard = true;
  DateTime? startdate, enddate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrinTEXComponents().appBar(
          'Printing Order',
          context,
          null,
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: 30.0,
              left: MediaQuery.sizeOf(context).width * 0.1,
              right: MediaQuery.sizeOf(context).width * 0.1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildDate(),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: OrderDAO().getBriefOrderInfo(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return buildOrderTracker({
                          'total_order': 0,
                          'successful_order': 0,
                          'failed_order': 0
                        });
                      }
                      return buildOrderTracker(snapshot.data!);
                    }),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isDashboard = true;
                          });
                        },
                        child: const Text('Dashboard')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isDashboard = false;
                          });
                        },
                        child: const Text('Orders')),
                  ],
                ),
                buildDashboardOrder()
              ],
            ),
          ),
        ));
  }

  Builder buildDashboardOrder() {
    return Builder(builder: (context) {
      if (isDashboard) {
        return buildViewPrinters(context);
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      DateTimeRange? range = await showDateRangePicker(
                          context: context,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 100)),
                          lastDate: DateTime.now());

                      if (range == null) return;

                      setState(() {
                        startdate = range.start;

                        enddate = range.end;
                      });
                    },
                    child: const Text('Duration')),
                const SizedBox(
                  width: 20,
                ),
                Builder(builder: (context) {
                  if (startdate == null || enddate == null) {
                    return Container();
                  } else
                    return Text(dateFormatter());
                })
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: OrderDAO().getOrdersAssociated(
                    startdate: startdate, enddate: enddate),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        Order currentOrder = snapshot.data!.elementAt(index);

                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'RM ${currentOrder.cost.toStringAsFixed(2)}',
                                        style: PrinTEXComponents().getTextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                            child: Text(
                                          currentOrder.status,
                                          style: PrinTEXComponents()
                                              .getTextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                        )),
                                      )
                                    ],
                                  ),
                                  Text(
                                    currentOrder.orderID,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(DateFormat('dd MMMM yyyy, hh:mm a')
                                      .format(currentOrder.date
                                          .add(Duration(hours: 8))))
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_forward_ios))
                          ],
                        );
                      }),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: snapshot.data!.length);
                })
          ],
        );
      }
    });
  }

  ListView buildViewPrinters(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          APM currentAPM = context.read<ListAPMProvider>().apm[index];
          return Row(
            children: [
              Image.network(
                currentAPM.pictureUrl,
                height: 70,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentAPM.printerName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: PrinTEXComponents().getTextStyle(fontSize: 14),
                    ),
                    Text(
                        'Status : ${currentAPM.isActive ? 'Ready' : 'Maintenance'}')
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios))
            ],
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: context.watch<ListAPMProvider>().apm.length);
  }

  Widget buildOrderTracker(Map<String, int> data) {
    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['total_order'].toString(),
                style: PrinTEXComponents().getTextStyle(),
              ),
              Text(
                'Orders',
                style: PrinTEXComponents()
                    .getTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              )
            ],
          ),
          Container(
            height: 30,
            width: 1,
            color: Colors.black,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['successful_order'].toString(),
                style: PrinTEXComponents().getTextStyle(),
              ),
              Text(
                'Successful',
                style: PrinTEXComponents()
                    .getTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              )
            ],
          ),
          Container(
            height: 30,
            width: 1,
            color: Colors.black,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['failed_order'].toString(),
                style: PrinTEXComponents().getTextStyle(),
              ),
              Text(
                'Failed',
                style: PrinTEXComponents()
                    .getTextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              )
            ],
          ),
        ],
      );
    });
  }

  String dateFormatter() {
    if (startdate != null && enddate != null) {
      if (startdate!.year == enddate!.year) {
        return '${DateFormat("dd/MM").format(startdate!)} - ${DateFormat("dd/MM/yyyy").format(enddate!)}';
      } else {
        return '${DateFormat("dd/MM/yyyy").format(startdate!)} - ${DateFormat("dd/MM/yyyy").format(enddate!)}';
      }
    } else
      return "";
  }

  Row buildDate() {
    return Row(
      children: [
        Text(
          'Today',
          style: PrinTEXComponents().getTextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          DateFormat('d MMMM yyyy').format(DateTime.now()),
          style: PrinTEXComponents().getTextStyle(fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
