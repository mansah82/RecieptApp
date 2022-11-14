import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recipe_app/home_page.dart';
import 'package:recipe_app/utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 10),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(255, 239, 61, 100),
                  Color.fromARGB(255, 239, 93, 103),
                  Color.fromARGB(255, 239, 127, 107),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Verify Email',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "seguiB",
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'a verfication email has been sent to your email',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "seguiM",
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      child: const SizedBox(
                        height: 60,
                        child: Center(
                          child: Text(
                            "Resent Email",
                            style: TextStyle(
                                color: Color.fromARGB(255, 237, 57, 87),
                                fontSize: 20,
                                fontFamily: "seguiB"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xffffffff),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(color: Colors.white)),
                        ),
                      ),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const SizedBox(
                        height: 60,
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Color.fromARGB(255, 237, 57, 87),
                                fontSize: 20,
                                fontFamily: "seguiB"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
}
