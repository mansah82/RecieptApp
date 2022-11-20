import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:recipe_app/main.dart';
import 'package:recipe_app/model/user_model.dart';
import 'package:recipe_app/utils.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignUpWidget({super.key, required this.onClickedSignIn});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
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
                "Sign Up Page",
                style: TextStyle(
                    color: Colors.white, fontSize: 25, fontFamily: "seguiB"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                textInputAction: TextInputAction.next,
                //initialValue: globals.name,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  suffixIconConstraints:
                      BoxConstraints(minHeight: 45, minWidth: 45),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,

                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextFormField(
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                style: const TextStyle(color: Colors.white),
                obscureText: true,

                validator: (value) => value != null && value.length < 6
                    ? 'Enter min 6 characters'
                    : null,
                keyboardType: TextInputType.text,
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
                onPressed: () {
                  signUp();
                  //createUser(emailController.text);
                },
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
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(40, 255, 255, 255),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color: Colors.white)),
                  ),
                ),
                onPressed: widget.onClickedSignIn, //widget.onClickedSignUp,
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
          ]),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((_) => createUser(emailController.text));
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future createUser(String email) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
      final user = UserModel(
        uid: uid,
        name: "",
        email: emailController.text,
        favorites: [],
        //tar bort extra listan
      );
      print(
          "---------------------------------------------------------------------");
      final json = user.toMap();
      await docUser.set(json);
    } catch (e) {
      showSnackBar2(context: context, content: e.toString());
    }
  }
}
