import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printex_business_app/backend/authenticationDAO.dart';
import 'package:printex_business_app/components.dart';
import 'package:printex_business_app/authentication/forgotpassword.dart';
import 'package:printex_business_app/authentication/signuppage.dart';
import 'package:printex_business_app/authentication/emailverification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isPasswordHidden = true, isLoading = false;
  TextEditingController email = TextEditingController(),
      password = TextEditingController();

  double containerheight = 0;
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.sizeOf(context).height);
    double screenheight = MediaQuery.sizeOf(context).height;
    containerheight = screenheight > 800
        ? MediaQuery.sizeOf(context).height * 0.7
        : screenheight < 700
            ? MediaQuery.sizeOf(context).height * 0.8
            : MediaQuery.sizeOf(context).height * 0.75;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/printex_business.png',
                          height: 120,
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF000000),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45))),
                    width: MediaQuery.sizeOf(context).width,
                    height: containerheight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 45.0, top: 45, right: 45, bottom: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Welcome to PrinTEX Business',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20)),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Log In',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 40)),
                              const SizedBox(
                                height: 35,
                              ),
                              PrinTEXComponents().inputField(
                                  MediaQuery.sizeOf(context).width * 0.8,
                                  'Email',
                                  email,
                                  formats: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s'))
                                  ],
                                  suffixIcon: Icons.mail),
                              const SizedBox(
                                height: 25,
                              ),
                              PrinTEXComponents().inputPasswordField(
                                  MediaQuery.sizeOf(context).width * 0.8,
                                  'Password',
                                  isPasswordHidden, () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              }, password),
                              const SizedBox(
                                height: 18,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Switcher().SwitchPage(
                                        context, const ForgotPasswordPage());
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              PrinTEXComponents().outlinedButton(
                                  MediaQuery.sizeOf(context).width * 0.8,
                                  'SIGN IN', () async {
                                if (isLoading) return;

                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  String result = await AuthenticationDAO()
                                      .signIn(email.text, password.text);

                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/home', (route) => false);
                                } on EmailNotVerified {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text('Please verify your email first'),
                                  ));
                                  AuthenticationDAO().supabase.auth.resend(
                                      type: OtpType.signup, email: email.text);
                                  Switcher().SwitchPage(context,
                                      EmailVerificationPage(email: email.text));
                                  setState(() {
                                    isLoading = false;
                                  });
                                } on InvalidLoginCredentials {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Invalid login credentials'),
                                  ));
                                  setState(() {
                                    isLoading = false;
                                  });
                                } on AccountIsNotOwner catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(e.cause),
                                  ));
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }, isLoading: isLoading, black: true),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Don\'t have an account?',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Switcher().SwitchPage(
                                          context, const SignUpPage());
                                    },
                                    child: const Text(
                                      ' SIGN UP',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
