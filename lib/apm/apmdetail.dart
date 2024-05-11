import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:printex_business_app/apm/printexdetailinput_edit.dart';
import 'package:printex_business_app/backend/apmdao.dart';
import 'package:printex_business_app/components.dart';
import 'package:printex_business_app/model/apm.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class APMPage extends StatefulWidget {
  APM apm;
  APMPage({super.key, required this.apm});

  @override
  State<APMPage> createState() => _APMPageState(apm);
}

class _APMPageState extends State<APMPage> {
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String selectedDay = '';
  APM apm;
  APMOperatingHours? operatingHours;
  APMDetails? details;
  APMPricing? pricing;
  _APMPageState(this.apm);
  @override
  void initState() {
    selectedDay = days.first;
    super.initState();
  }

  final cardController = PageController(viewportFraction: 1, keepPage: true);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApmDAO().getAPMDetails(apm.apmID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 20,
              width: 20,
              child: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          } else {
            var item = snapshot.data!;
            details = snapshot.data!;
            return Scaffold(
              appBar: PrinTEXComponents()
                  .appBarWithBackButton('PrinTEX Details', context),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (operatingHours == null ||
                      details == null ||
                      pricing == null) {
                    return;
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PrintDetailInputEdit(
                          apm: apm,
                          operatingHours: operatingHours!,
                          details: details!,
                          pricing: pricing!)));
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 240,
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          child: PageView(
                            controller: cardController,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 240,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(apm.pictureUrl),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              //https://hxebdlcxtauthsyfyprv.supabase.co/storage/v1/object/public/apms/fc6b2565-917a-407d-96b6-af299374c2a8/IMG_20231218_143249.jpg
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 240,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(apm.pictureUrl2),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SmoothPageIndicator(
                          effect: const ScrollingDotsEffect(
                              dotWidth: 10,
                              dotHeight: 10,
                              paintStyle: PaintingStyle.fill),
                          controller: cardController,
                          count: 2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          builder: (context, snapshot) {
                            print(snapshot.error);
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            pricing = snapshot.data;
                            return TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Container());
                                },
                                child: Text('See pricing'));
                          },
                          future: ApmDAO().getPricing(apm.apmID),
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x7F2728FF),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 310,
                                  child: Text(
                                    apm.printerName,
                                    style: const TextStyle(
                                      color: Color(0xFF3A3A3A),
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Location:',
                                  style: TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${apm.address1}, ${apm.address2}, ${apm.city}, ${apm.state}',
                                  style: const TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Operation Hours:',
                                  style: TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                FutureBuilder<APMOperatingHours>(
                                    future: ApmDAO()
                                        .getAPMOperatingHours(apm.apmID),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      }

                                      Map<String, String> operatinghours =
                                          snapshot.data!.toMap();
                                      operatingHours = snapshot.data!;
                                      return Row(
                                        children: [
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                value: selectedDay,
                                                style: const TextStyle(
                                                  color: Color(0xFF3A3A3A),
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                                items: days.map<
                                                    DropdownMenuItem<
                                                        String>>((e) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: e, child: Text(e));
                                                }).toList(),
                                                onChanged: (val) {
                                                  if (val != null) {
                                                    setState(() {
                                                      selectedDay = val;
                                                    });
                                                  }
                                                }),
                                          ),
                                          const SizedBox(
                                            width: 0,
                                          ),
                                          Text(
                                            operatinghours[
                                                selectedDay.toLowerCase()]!,
                                            style: const TextStyle(
                                              color: Color(0xFF3A3A3A),
                                              fontSize: 13,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        if ((await MapLauncher.isMapAvailable(
                                            MapType.google))!) {
                                          await MapLauncher.showMarker(
                                              mapType: MapType.google,
                                              coords: Coords(apm.lat, apm.lng),
                                              title: apm.printerName);
                                        } else {
                                          final availableMaps =
                                              await MapLauncher.installedMaps;

                                          availableMaps.first.showMarker(
                                              coords: Coords(apm.lat, apm.lng),
                                              title: apm.printerName);
                                        }
                                      },
                                      child: Ink(
                                        width: 91,
                                        height: 26,
                                        decoration: ShapeDecoration(
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        child: const Center(
                                          child: SizedBox(
                                            width: 66,
                                            child: Text(
                                              'Direction',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          height: 200,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x7F2728FF),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'PrinTEX Details',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF3A3A3A),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Printer Type: ',
                                                style: TextStyle(
                                                  color: Color(0xFF3A3A3A),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: item.type,
                                                style: const TextStyle(
                                                  color: Color(0xFF3A3A3A),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      'Black & White Printing: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: item.bwprint
                                                      ? 'Yes '
                                                      : 'No ',
                                                  style: const TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Color Printing: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: item.colorprint
                                                      ? 'Yes '
                                                      : 'No ',
                                                  style: const TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Both-Sided Printing: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: item.bothsideprint
                                                      ? 'Yes '
                                                      : 'No ',
                                                  style: const TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Paper Size: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: item.papersize,
                                                  style: const TextStyle(
                                                    color: Color(0xFF3A3A3A),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
