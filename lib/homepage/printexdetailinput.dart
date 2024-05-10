import 'package:flutter/material.dart';
import 'package:printex_business_app/components.dart';

class PrintDetailInput extends StatefulWidget {
  const PrintDetailInput({super.key});

  @override
  State<PrintDetailInput> createState() => _PrintDetailInputState();
}

class _PrintDetailInputState extends State<PrintDetailInput> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PrinTEXComponents().appBarWithBackButton('PrinTEX Details', context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Please Complete All Information Below"),
              SizedBox(
                height: 10,
              ),
              DetailComponent().title("PrinTEX Status"),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Active',
                      style: TextStyle(color: Color.fromRGBO(26, 255, 48, 1)),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(249, 249, 249, 1),
                      elevation: 2.0, // Elevation for drop shadow
                      shadowColor: Color.fromRGBO(0, 0, 0, 0.25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Maintenance',
                        style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromRGBO(249, 249, 249, 1),
                        elevation: 2.0,
                        shadowColor: Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                    ),
                  ),
                ],
              ),
              DetailComponent().title("PrinTEX License Key"),
              DetailComponent().input("PrinTEX License Key"),
              DetailComponent().title("PrinTEX Name"),
              DetailComponent().input("PrinTEX Shop Name"),
              DetailComponent().title("PrinTEX Location"),
              DetailComponent().input("1st Street Name"),
              DetailComponent().input("2nd Street Name (Optional)"),
              DetailComponent().dropdowninput("Post Code"),
              SizedBox(
                height: 8,
              ),
              DetailComponent().input("State"),
              DetailComponent().title("PrinTEX Photos (Exactly 2 Photos)"),
              DetailComponent().input("1st PrinTEX Photo",
                  iconPath: 'assets/images/Vector.png'),
              DetailComponent().input("2nd PrinTEX Photo",
                  iconPath: 'assets/images/Vector.png'),
              DetailComponent().title("PrinTEX Operation Hours"),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}), //backend
                  Text("Open 24 hours, all the days")
                ],
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: DataTable(
              //       horizontalMargin: 0,
              //       columnSpacing: 10,
              //       dividerThickness: 0.00000000001,
              //       columns: [
              //         DataColumn(label: Text('')),
              //         DataColumn(label: Text('Start')),
              //         DataColumn(label: Center(child: Text('End'))),
              //         DataColumn(label: Text('Closed')),
              //         DataColumn(label: Text('Open*')),
              //       ],
              //       rows: [
              //         DetailComponent().dataRow("Monday"),
              //         DetailComponent().dataRow("Tuesday"),
              //         DetailComponent().dataRow("Wednesday"),
              //         DetailComponent().dataRow("Thursday"),
              //         DetailComponent().dataRow("Friday"),
              //         DetailComponent().dataRow("Saturday"),
              //         DetailComponent().dataRow("Sunday"),
              //       ]),
              // ),
              SingleChildScrollView(
                child: Table(
                  columnWidths: {
                    0: FixedColumnWidth(100),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      TableCell(
                          child: Align(
                              alignment: Alignment.center, child: Text(""))),
                      TableCell(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("Start"))),
                      TableCell(
                          child: Align(
                              alignment: Alignment.center, child: Text("End"))),
                      TableCell(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("Closed"))),
                      TableCell(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("Open*"))),
                    ]),
                    DetailComponent().operationRow("Monday"),
                    DetailComponent().operationRow("Tuesday"),
                    DetailComponent().operationRow("Wednesday"),
                    DetailComponent().operationRow("Thursday"),
                    DetailComponent().operationRow("Friday"),
                    DetailComponent().operationRow("Saturday"),
                    DetailComponent().operationRow("Sunday"),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '* Open 24 Hours',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              DetailComponent().title("Printing Details"),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  DetailComponent().detailRow("Printer Type"),
                  DetailComponent().detailRow("Black & White Priting"),
                  DetailComponent().detailRow("Color Printing"),
                  DetailComponent().detailRow("Both-Sided Printing"),
                  DetailComponent().detailRow("Type of Paper"),
                  DetailComponent().detailRow("Layout"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("I wanna delete this PrinTEX.",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      )),
                  // TextButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       "Delete",
                  //       style: TextStyle(
                  //           fontStyle: FontStyle.italic,
                  //           color: Colors.black,
                  //           decoration: TextDecoration.underline,
                  //           decorationThickness: 2),
                  //     )),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AlertDialog(
                                      backgroundColor: Colors.white,
                                      content: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Are you sure you want to delete this PrinTEX?",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            DetailComponent().alertButton(
                                                context,
                                                text: "Cancel",
                                                color: Color.fromRGBO(
                                                    217, 217, 217, 1)),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            DetailComponent().alertButton(
                                                context,
                                                text: "Confirm",
                                                color: Colors.black),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          " Delete",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       "Cancel",
                  //       style: TextStyle(color: Colors.white, fontSize: 25),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  // backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  DetailComponent().confirmButton(context,
                      text: "Cancel", color: Color.fromRGBO(217, 217, 217, 1)),
                  SizedBox(
                    width: 15,
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       "Confirm",
                  //       style: TextStyle(color: Colors.white, fontSize: 25),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.black,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  DetailComponent().confirmButton(context,
                      text: "Confirm", color: Colors.black),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailComponent {
  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget input(String hintText, {String? iconPath}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
            suffixIcon: iconPath == null ? null : Image.asset(iconPath),
            filled: true,
            fillColor: Color.fromRGBO(249, 249, 249, 1),
            hintText: hintText,
            hintStyle: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(99, 99, 99, 1))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(99, 99, 99, 1)),
            ),
            contentPadding: EdgeInsets.all(10)),
      ),
    );
  }

  Widget dropdowninput(String text) {
    return DropdownButtonFormField(
      hint: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
        ),
      ),
      items: null,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        filled: true,
        fillColor: Color.fromRGBO(249, 249, 249, 1),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(99, 99, 99, 1))),
      ),
    );
  }

  // TableRow detailRow(String title) {
  //   return TableRow(children: [
  //     Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 5.0),
  //       child: TableCell(child: Text(title)),
  //     ),
  //     Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 5.0),
  //         child: TableCell(
  //           child: DetailComponent().dropdowninput("test"),
  //         )),
  //   ]);
  // }

  TableRow detailRow(String title) {
    return TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text(title)),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: DetailComponent().dropdowninput("test"),
      )
    ]);
  }

  // TableRow operationRow(String text) {
  //   return TableRow(children: [
  //     TableCell(child: Text(text)),
  //     Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //       child: TableCell(child: DetailComponent().dateInput()),
  //     ),
  //     Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //       child: TableCell(child: DetailComponent().dateInput()),
  //     ),
  //     TableCell(child: Checkbox(value: false, onChanged: (value) {})),
  //     TableCell(child: Checkbox(value: false, onChanged: (value) {})),
  //   ]);
  // }

  TableRow operationRow(String text) {
    return TableRow(children: [
      TableCell(child: Text(text)),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DetailComponent().dateInput(),
          )),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DetailComponent().dateInput(),
          )),
      TableCell(child: Checkbox(value: false, onChanged: (value) {})),
      TableCell(child: Checkbox(value: false, onChanged: (value) {})),
    ]);
  }

  Widget dateInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(99, 99, 99, 1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(99, 99, 99, 1)),
            ),
            contentPadding: EdgeInsets.all(10)),
      ),
    );
  }

  Widget confirmButton(BuildContext context, {String? text, Color? color}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          text!,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color!,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget alertButton(BuildContext context, {String? text, Color? color}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          text!,
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color!,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
