import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:recipe_app/forgot_password_page.dart';
import 'package:recipe_app/home_page.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginWidget({required this.onClickedSignUp});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
            child: Text(
              "Sign In Page",
              style: TextStyle(
                  color: Colors.white, fontSize: 25, fontFamily: "seguiB"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              controller: emailController,
              textInputAction: TextInputAction.next,
              //initialValue: globals.name,
              decoration: const InputDecoration(
                labelText: 'Email',
                suffixIconConstraints:
                    BoxConstraints(minHeight: 45, minWidth: 45),
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              controller: passwordController,
              textInputAction: TextInputAction.next,
              //initialValue: globals.name,
              decoration: const InputDecoration(
                labelText: 'Password',
                suffixIconConstraints:
                    BoxConstraints(minHeight: 45, minWidth: 45),
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(0),
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 255, 255, 255),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: signIn,
              child: const SizedBox(
                height: 55,
                child: Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Color.fromARGB(255, 237, 57, 87),
                      fontSize: 20,
                    ),
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
                  Color.fromARGB(82, 255, 255, 255),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(color: Colors.white)),
                ),
              ),
              onPressed: widget.onClickedSignUp,
              child: const SizedBox(
                height: 55,
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Color.fromARGB(255, 237, 57, 87),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: GestureDetector(
              child: const Text(
                'Forgot Password',
                style: TextStyle(
                    fontFamily: "seguiM",
                    //decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 17),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage())),
            ),
          ),
        ]),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
