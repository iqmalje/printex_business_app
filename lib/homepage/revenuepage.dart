import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:printex_business_app/backend/orderdao.dart';
import 'package:printex_business_app/components.dart';
import 'package:printex_business_app/model/apm.dart';
import 'package:printex_business_app/model/bank.dart';
import 'package:printex_business_app/model/providers.dart';
import 'package:printex_business_app/revenue/bankdetail.dart';
import 'package:provider/provider.dart';

class eWalletPage extends StatefulWidget {
  const eWalletPage({super.key});

  @override
  State<eWalletPage> createState() => _eWalletPageState();
}

class _eWalletPageState extends State<eWalletPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  DateTime startdate = DateTime.now().subtract(Duration(days: 30)),
      enddate = DateTime.now();

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrinTEXComponents().appBar('Revenue', context, null),
      body: Padding(
        padding: EdgeInsets.only(
            top: 30.0,
            left: MediaQuery.sizeOf(context).width * 0.1,
            right: MediaQuery.sizeOf(context).width * 0.1),
        child: Column(
          children: [
            buildDate(),
            const SizedBox(
              height: 20,
            ),
            buildFinanceTracker(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  DateTimeRange? range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now().subtract(Duration(days: 100)),
                      lastDate: DateTime.now());

                  if (range == null) return;

                  setState(() {
                    startdate = range.start;

                    enddate = range.end;
                  });
                },
                child: const Text('Duration')),
            TabBar(controller: tabController, tabs: [
              Container(
                  height: 50, child: const Center(child: Text('Dashboard'))),
              Container(
                  height: 50, child: const Center(child: Text('Payments'))),
              Container(height: 50, child: const Center(child: Text('Bank'))),
            ]),
            Expanded(
              child: TabBarView(controller: tabController, children: [
                buildDashboard(context),
                buildPayment(),
                buildBank(context),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Column buildBank(BuildContext context) {
    Bank bank = context.watch<BankDetailsProvider>().bank;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.25))
              ],
              color: const Color(0xFFF5F5F5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank Name',
                        style: PrinTEXComponents().getTextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      Text(
                        bank.bankName,
                        style: PrinTEXComponents().getTextStyle(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bank Number',
                        style: PrinTEXComponents().getTextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      Text(
                        bank.bankNumber,
                        style: PrinTEXComponents().getTextStyle(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bank Name',
                        style: PrinTEXComponents().getTextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      Text(
                        bank.bank,
                        style: PrinTEXComponents().getTextStyle(),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                      onPressed: () {
                        Switcher().SwitchPage(context, const BankDetailPage());
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                      )),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Padding buildPayment() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('RM 0.00'),
                    const Text('payment id'),
                    Text(DateFormat('dd/MM/yyyy, hh:mm a')
                        .format(DateTime.now()))
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios))
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: 3,
      ),
    );
  }

  Widget buildDashboard(BuildContext context) {
    return FutureBuilder(
        future: OrderDAO().getRevenueInfo(startdate, enddate),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.25))
                    ],
                    color: const Color(0xFFF5F5F5)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration',
                        style: PrinTEXComponents().getTextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      Text(
                        '${DateFormat('dd MMMM yyyy').format(startdate)} - ${DateFormat('dd MMMM yyyy').format(enddate)}',
                        style: PrinTEXComponents().getTextStyle(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Revenue',
                        style: PrinTEXComponents().getTextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      Text(
                        'RM ${(snapshot.data!['revenue'] as double).toStringAsFixed(2)}',
                        style: PrinTEXComponents().getTextStyle(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payments',
                                  style: PrinTEXComponents().getTextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                                Text(
                                  snapshot.data!['payments'].toString(),
                                  style: PrinTEXComponents().getTextStyle(),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            height: 50,
                            width: 1,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customers',
                                  style: PrinTEXComponents().getTextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                                Text(
                                  snapshot.data!['customers'].toString(),
                                  style: PrinTEXComponents().getTextStyle(),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'PrinTEX\'s Revenue',
                style: PrinTEXComponents().getTextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              buildViewPrinters(context)
            ],
          );
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
                    const Text('Revenue : RM 0.00')
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

  Widget buildFinanceTracker() {
    return FutureBuilder(
        future: OrderDAO().getBriefRevenueInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RM ${(snapshot.data!['revenue'] as double).toStringAsFixed(2)}',
                    style: PrinTEXComponents().getTextStyle(),
                  ),
                  Text(
                    'Revenue',
                    style: PrinTEXComponents().getTextStyle(
                        fontWeight: FontWeight.w400, fontSize: 16),
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
                    snapshot.data!['payments'].toString(),
                    style: PrinTEXComponents().getTextStyle(),
                  ),
                  Text(
                    'Payments',
                    style: PrinTEXComponents().getTextStyle(
                        fontWeight: FontWeight.w400, fontSize: 16),
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
                    snapshot.data!['customers'].toString(),
                    style: PrinTEXComponents().getTextStyle(),
                  ),
                  Text(
                    'Customers',
                    style: PrinTEXComponents().getTextStyle(
                        fontWeight: FontWeight.w400, fontSize: 16),
                  )
                ],
              ),
            ],
          );
        });
  }
}
