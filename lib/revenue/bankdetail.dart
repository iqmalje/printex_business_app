import 'package:flutter/material.dart';
import 'package:printex_business_app/components.dart';
import 'package:printex_business_app/model/bank.dart';
import 'package:printex_business_app/model/providers.dart';
import 'package:provider/provider.dart';

class BankDetailPage extends StatefulWidget {
  const BankDetailPage({super.key});

  @override
  State<BankDetailPage> createState() => _BankDetailPageState();
}

class _BankDetailPageState extends State<BankDetailPage> {
  late TextEditingController bankname, banknumber, bankController;

  late Bank bank;

  @override
  void initState() {
    super.initState();

    bank = context.read<BankDetailsProvider>().bank;

    bankname = TextEditingController(text: bank.bankName);
    banknumber = TextEditingController(text: bank.bankNumber);
    bankController = TextEditingController(text: bank.bank);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrinTEXComponents().appBarWithBackButton('Account Bank', context),
      body: Padding(
        padding: EdgeInsets.only(
            top: 20.0,
            left: MediaQuery.sizeOf(context).width * 0.07,
            right: MediaQuery.sizeOf(context).width * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please complete all information below',
              style: PrinTEXComponents().getTextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  style: FontStyle.italic),
            ),
            const SizedBox(
              height: 20,
            ),
            buildInput('Bank Name', bankname),
            const SizedBox(
              height: 20,
            ),
            buildInput('Bank Number', banknumber),
            const SizedBox(
              height: 20,
            ),
            buildInput('Bank', bankController),
            const SizedBox(
              height: 20,
            ),
            PrinTEXComponents().filledButton(
                MediaQuery.sizeOf(context).width, 'Confirm', () async {
              context.read<BankDetailsProvider>().changeBank(
                  newBank: Bank(
                      bankName: bankname.text,
                      bankNumber: banknumber.text,
                      bank: bankController.text));

              Navigator.of(context).pop();
            })
          ],
        ),
      ),
    );
  }

  Column buildInput(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: PrinTEXComponents().getTextStyle(),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.black,
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                controller: controller,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: title),
              ),
            )),
      ],
    );
  }
}
