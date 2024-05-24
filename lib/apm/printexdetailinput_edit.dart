import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printex_business_app/backend/apmdao.dart';
import 'package:printex_business_app/components.dart';
import 'package:printex_business_app/model/apm.dart';
import 'package:time_range_picker/time_range_picker.dart';

class PrintDetailInputEdit extends StatefulWidget {
  APM apm;
  APMOperatingHours operatingHours;
  APMDetails details;
  APMPricing pricing;
  PrintDetailInputEdit(
      {super.key,
      required this.apm,
      required this.operatingHours,
      required this.details,
      required this.pricing});

  @override
  // ignore: no_logic_in_create_state
  State<PrintDetailInputEdit> createState() =>
      _PrintDetailInputEditState(apm, operatingHours, details, pricing);
}

class _PrintDetailInputEditState extends State<PrintDetailInputEdit> {
  bool isActive = true;
  APM apm;
  APMOperatingHours operatingHours;
  APMDetails details;
  APMPricing pricing;
  _PrintDetailInputEditState(
      this.apm, this.operatingHours, this.details, this.pricing);
  TextEditingController license = TextEditingController(),
      shopName = TextEditingController(),
      address1 = TextEditingController(),
      address2 = TextEditingController(),
      city = TextEditingController(),
      state = TextEditingController(),
      singlebw = TextEditingController(),
      bothbw = TextEditingController(),
      singlecolor = TextEditingController(),
      bothcolor = TextEditingController();

  String type = "",
      bwprint = "",
      colorprint = "",
      bothprint = "",
      typepaper = "",
      layout = "";
  final ImagePicker picker = ImagePicker();
  XFile? picture1, picture2;

  List<String> operationHours = List.generate(7, (index) => "");
  List<bool> isOpened = List.generate(7, (index) => true);
  bool is24Hours = false;

  @override
  void initState() {
    shopName = TextEditingController(text: apm.printerName);
    address1 = TextEditingController(text: apm.address1);
    address2 = TextEditingController(text: apm.address2);
    city = TextEditingController(text: apm.city);
    state = TextEditingController(text: apm.state);
    singlebw = TextEditingController(text: pricing.blackWhiteSingle.toString());
    bothbw = TextEditingController(text: pricing.blackWhiteBoth.toString());
    singlecolor = TextEditingController(text: pricing.colorSingle.toString());
    bothcolor = TextEditingController(text: pricing.colorBoth.toString());
    operationHours = operatingHours.toList();
    type = details.type;
    bwprint = details.bwprint ? 'Yes' : 'No';
    colorprint = details.colorprint ? 'Yes' : 'No';
    bothprint = details.bothsideprint ? 'Yes' : 'No';
    typepaper = details.papersize;
    layout = details.layout;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PrinTEXComponents().appBarWithBackButton('PrinTEX Details', context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Please Complete All Information Below"),
              const SizedBox(
                height: 10,
              ),
              DetailComponent().title("PrinTEX Status"),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isActive = true;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: !isActive
                          ? const Color.fromARGB(255, 160, 160, 160)
                          : const Color.fromRGBO(249, 249, 249, 1),
                      elevation: 2.0, // Elevation for drop shadow
                      shadowColor: const Color.fromRGBO(0, 0, 0, 0.25),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(color: Color.fromRGBO(26, 255, 48, 1)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isActive = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: isActive
                            ? Color.fromARGB(255, 160, 160, 160)
                            : const Color.fromRGBO(249, 249, 249, 1),
                        elevation: 2.0,
                        shadowColor: const Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                      child: const Text(
                        'Maintenance',
                        style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                      ),
                    ),
                  ),
                ],
              ),
              DetailComponent().title("PrinTEX License Key"),
              DetailComponent().input("PrinTEX License Key", license),
              DetailComponent().title("PrinTEX Name"),
              DetailComponent().input("PrinTEX Shop Name", shopName),
              DetailComponent().title("PrinTEX Location"),
              DetailComponent().input("1st Street Name", address1),
              DetailComponent().input("2nd Street Name (Optional)", address2),
              DetailComponent().input("City", city),
              const SizedBox(
                height: 8,
              ),
              DetailComponent().input("State", state),
              DetailComponent().title("PrinTEX Photos (Exactly 2 Photos)"),
              DetailComponent().inputImage(
                  picture1 == null ? "1st PrinTEX Photo" : "Uploaded 1st Photo",
                  () async {
                picture1 = await picker.pickImage(source: ImageSource.gallery);
                setState(() {});
              }, iconPath: 'assets/images/Vector.png'),
              DetailComponent().inputImage(
                  picture2 == null ? "2nd PrinTEX Photo" : "Uploaded 2nd Photo",
                  () async {
                picture2 = await picker.pickImage(source: ImageSource.gallery);
                setState(() {});
              }, iconPath: 'assets/images/Vector.png'),
              DetailComponent().title("PrinTEX Operation Hours"),
              Row(
                children: [
                  Checkbox(
                      value: is24Hours,
                      onChanged: (value) {
                        setState(() {
                          is24Hours = !is24Hours;
                        });
                      }), //backend
                  const Text("Open 24 hours, all the days")
                ],
              ),
              Builder(builder: (context) {
                if (is24Hours) {
                  return Container();
                }
                return SingleChildScrollView(
                  child: Table(
                    columnWidths: {
                      0: const FixedColumnWidth(80),
                      1: const FixedColumnWidth(200)
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      const TableRow(children: [
                        TableCell(
                            child: Align(
                                alignment: Alignment.center, child: Text(""))),
                        TableCell(
                            child: Align(
                                alignment: Alignment.center,
                                child: Text("Hours"))),
                        TableCell(
                            child: Align(
                                alignment: Alignment.center,
                                child: Text("Open*"))),
                      ]),
                      DetailComponent().operationRow(
                          "Monday", context, operationHours[0], isOpened[0],
                          () {
                        setState(() {
                          isOpened[0] = !isOpened[0];
                          if (isOpened[0] == false) {
                            operationHours[0] = "Closed";
                          } else {
                            operationHours[0] = "";
                          }
                        });
                      }, () {
                        setTimeRange(0);
                      }),
                      DetailComponent().operationRow(
                          "Tuesday", context, operationHours[1], isOpened[1],
                          () {
                        setState(() {
                          isOpened[1] = !isOpened[1];
                          if (isOpened[1] == false) {
                            operationHours[1] = "Closed";
                          } else {
                            operationHours[1] = "";
                          }
                        });
                      }, () {
                        setTimeRange(1);
                      }),
                      DetailComponent().operationRow(
                          "Wednesday", context, operationHours[2], isOpened[2],
                          () {
                        setState(() {
                          isOpened[2] = !isOpened[2];
                          if (isOpened[2] == false) {
                            operationHours[2] = "Closed";
                          } else {
                            operationHours[2] = "";
                          }
                        });
                      }, () {
                        setTimeRange(2);
                      }),
                      DetailComponent().operationRow(
                          "Thursday", context, operationHours[3], isOpened[3],
                          () {
                        setState(() {
                          isOpened[3] = !isOpened[3];
                          if (isOpened[3] == false) {
                            operationHours[3] = "Closed";
                          } else {
                            operationHours[3] = "";
                          }
                        });
                      }, () {
                        setTimeRange(3);
                      }),
                      DetailComponent().operationRow(
                          "Friday", context, operationHours[4], isOpened[4],
                          () {
                        setState(() {
                          isOpened[4] = !isOpened[4];
                          if (isOpened[4] == false) {
                            operationHours[4] = "Closed";
                          } else {
                            operationHours[4] = "";
                          }
                        });
                      }, () {
                        setTimeRange(4);
                      }),
                      DetailComponent().operationRow(
                          "Saturday", context, operationHours[5], isOpened[5],
                          () {
                        setState(() {
                          isOpened[5] = !isOpened[5];
                          if (isOpened[5] == false) {
                            operationHours[5] = "Closed";
                          } else {
                            operationHours[5] = "";
                          }
                        });
                      }, () {
                        setTimeRange(5);
                      }),
                      DetailComponent().operationRow(
                          "Sunday", context, operationHours[6], isOpened[6],
                          () {
                        setState(() {
                          isOpened[6] = !isOpened[6];
                          if (isOpened[6] == false) {
                            operationHours[6] = "Closed";
                          } else {
                            operationHours[6] = "";
                          }
                        });
                      }, () {
                        setTimeRange(6);
                      }),
                    ],
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '* Open 24 Hours',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              DetailComponent().title("Printing Details"),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  DetailComponent().detailRow(
                      "Printer Type", ["Inkjet Printer", "Laser Printer"],
                      (String? val) {
                    setState(() {
                      if (val != null) {
                        type = val;
                      }
                    });
                  }, type.isEmpty ? "Inkjet Printer" : type),
                  DetailComponent().detailRow(
                      "Black & White Priting", ["Yes", "No"], (String? val) {
                    setState(() {
                      if (val != null) {
                        bwprint = val;
                      }
                    });
                  }, bwprint.isEmpty ? "Yes" : bwprint),
                  DetailComponent().detailRow("Color Printing", ["Yes", "No"],
                      (String? val) {
                    setState(() {
                      if (val != null) {
                        colorprint = val;
                      }
                    });
                  }, colorprint.isEmpty ? "Yes" : colorprint),
                  DetailComponent().detailRow(
                      "Both-Sided Printing", ["Yes", "No"], (String? val) {
                    setState(() {
                      if (val != null) {
                        bothprint = val;
                      }
                    });
                  }, bothprint.isEmpty ? "Yes" : bothprint),
                  DetailComponent().detailRow(
                      "Type of Paper", ["A4 70gsm", "A4 80gsm"], (String? val) {
                    setState(() {
                      if (val != null) {
                        typepaper = val;
                      }
                    });
                  }, typepaper.isEmpty ? "A4 70gsm" : typepaper),
                  DetailComponent().detailRow("Layout", [
                    "1 in 1 only",
                    "1 in 1 & 2 in 1",
                    "1 in 1, 2 in 1, 4 in 1",
                    "1 in 1, 2 in 1, 4 in 1 & 6 in 1"
                  ], (String? val) {
                    setState(() {
                      if (val != null) {
                        layout = val;
                      }
                    });
                  }, layout.isEmpty ? "1 in 1 only" : layout),
                ],
              ),
              DetailComponent().title("PrinTEX Pricing"),
              Table(
                columnWidths: {
                  0: FixedColumnWidth(250),
                  1: FixedColumnWidth(100)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  const TableRow(children: [
                    TableCell(
                        child: Align(
                            alignment: Alignment.center, child: Text(""))),
                    TableCell(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Price/page"))),
                    TableCell(
                        child: Align(
                            alignment: Alignment.center, child: Text(""))),
                  ]),
                  DetailComponent()
                      .detailRowInput("A4 Single Sided B&W", singlebw),
                  DetailComponent().detailRowInput("A4 Both Sided B&W", bothbw),
                  DetailComponent()
                      .detailRowInput("A4 Single Sided Color", singlecolor),
                  DetailComponent()
                      .detailRowInput("A4 Both Sided Color", bothcolor),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("I wanna delete this PrinTEX.",
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
                                      content: const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
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
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          217, 217, 217, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Cancel",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            DetailComponent()
                                                .alertButton(context, () async {
                                              print("asdsads");
                                              await ApmDAO()
                                                  .deleteAPM(apm.apmID);

                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      '/home',
                                                      (route) => false);
                                            },
                                                    text: "Confirm",
                                                    color: Colors.black),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ));
                      },
                      child: const Padding(
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
              const SizedBox(
                height: 10,
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
                  DetailComponent().confirmButton(context, () {
                    Navigator.of(context).pop();
                  },
                      text: "Cancel",
                      color: const Color.fromRGBO(217, 217, 217, 1)),
                  const SizedBox(
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

                  DetailComponent().confirmButton(context, () async {
                    // check for empty
                    if (shopName.text.isEmpty ||
                        address1.text.isEmpty ||
                        address2.text.isEmpty ||
                        city.text.isEmpty ||
                        state.text.isEmpty ||
                        type.isEmpty ||
                        bwprint.isEmpty ||
                        colorprint.isEmpty ||
                        bothprint.isEmpty ||
                        typepaper.isEmpty ||
                        layout.isEmpty ||
                        singlebw.text.isEmpty ||
                        bothbw.text.isEmpty ||
                        singlecolor.text.isEmpty ||
                        bothcolor.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Must fill all blanks!')));
                      return;
                    }

                    if (operationHours.contains("")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Must fill all blankss!')));
                      return;
                    }

                    APM apm = APM(
                        apmID: this.apm.apmID,
                        printerName: shopName.text,
                        pictureUrl: '',
                        pictureUrl2: '',
                        isActive: isActive,
                        paperAmount: 0,
                        address1: address1.text,
                        address2: address2.text,
                        city: city.text,
                        state: state.text,
                        lat: 0,
                        lng: 0);
                    APMOperatingHours operatingHoursAPM = APMOperatingHours(
                        monday: operationHours[0],
                        tuesday: operationHours[1],
                        wednesday: operationHours[2],
                        thursday: operationHours[3],
                        friday: operationHours[4],
                        saturday: operationHours[5],
                        sunday: operationHours[6]);
                    APMDetails apmDetails = APMDetails(
                        type,
                        typepaper,
                        layout,
                        bwprint == 'Yes',
                        colorprint == 'Yes',
                        bothprint == 'Yes');
                    APMPricing apmPricing = APMPricing(
                        blackWhiteSingle: double.parse(singlebw.text),
                        blackWhiteBoth: double.parse(bothbw.text),
                        colorSingle: double.parse(singlecolor.text),
                        colorBoth: double.parse(bothcolor.text));
                    await ApmDAO().updateAPM(
                        apm, apmDetails, operatingHoursAPM, apmPricing);

                    print("DONE");

                    Navigator.of(context).pop();
                  }, text: "Confirm", color: Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setTimeRange(int index) async {
    TimeRange result = await showTimeRangePicker(context: context);
    // format to string

    String startTimeAMPM = result.startTime.hour >= 12 ? 'PM' : 'AM';
    String endTimeAMPM = result.endTime.hour >= 12 ? 'PM' : 'AM';
    String startProperHours = result.startTime.hour > 12
        ? (result.startTime.hour - 12).toString().padLeft(2, '0')
        : result.startTime.hour.toString().padLeft(2, '0');

    String endProperHours = result.endTime.hour > 12
        ? (result.endTime.hour - 12).toString().padLeft(2, '0')
        : (result.endTime.hour).toString().padLeft(2, '0');

    setState(() {
      operationHours[index] =
          "$startProperHours:${result.startTime.minute.toString().padLeft(2, '0')}$startTimeAMPM-$endProperHours:${result.endTime.minute.toString().padLeft(2, '0')}$endTimeAMPM";
    });
  }
}

class DetailComponent {
  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget input(String hintText, TextEditingController controller,
      {String? iconPath, double? width}) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: iconPath == null ? null : Image.asset(iconPath),
              filled: true,
              fillColor: const Color.fromRGBO(249, 249, 249, 1),
              hintText: hintText,
              hintStyle: const TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(99, 99, 99, 1))),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(99, 99, 99, 1)),
              ),
              contentPadding: const EdgeInsets.all(10)),
        ),
      ),
    );
  }

  Widget inputImage(String hintText, void Function() onTap,
      {String? iconPath}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        onTap: onTap,
        decoration: InputDecoration(
            suffixIcon: iconPath == null ? null : Image.asset(iconPath),
            filled: true,
            fillColor: const Color.fromRGBO(249, 249, 249, 1),
            hintText: hintText,
            hintStyle: const TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(99, 99, 99, 1))),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(99, 99, 99, 1)),
            ),
            contentPadding: const EdgeInsets.all(10)),
      ),
    );
  }

  Widget dropdowninput(String text, List<String> items,
      void Function(String?) onTap, String valueText) {
    return DropdownButtonFormField(
      isExpanded: true,
      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: valueText,
      onChanged: onTap,
      decoration: const InputDecoration(
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

  TableRow detailRow(String title, List<String> items,
      void Function(String?) onTap, String valueText) {
    return TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text(title)),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: DetailComponent().dropdowninput(title, items, onTap, valueText),
      )
    ]);
  }

  TableRow detailRowInput(String title, TextEditingController controller) {
    return TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text(title)),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: DetailComponent().input(title, controller),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container())
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

  TableRow operationRow(
      String text,
      BuildContext context,
      String operationHours,
      bool isOpened,
      void Function() onClick,
      void Function() onHourTap) {
    return TableRow(children: [
      TableCell(child: Text(text)),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DetailComponent().dateInput(
                context, !isOpened ? () {} : onHourTap, operationHours),
          )),
      TableCell(
          child: Checkbox(
              value: isOpened,
              onChanged: (value) {
                onClick();
              })),
    ]);
  }

  Widget dateInput(
      BuildContext context, void Function() onTap, String operationHours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.datetime,
        onTap: () async {
          onTap();
        },
        controller: TextEditingController(text: operationHours),
        readOnly: true,
        decoration: const InputDecoration(
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

  Widget confirmButton(BuildContext context, void Function() onTap,
      {String? text, Color? color}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color!,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text!,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }

  Widget alertButton(BuildContext context, void Function() onTap,
      {String? text, Color? color}) {
    print("test");
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color!,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
