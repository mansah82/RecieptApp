import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe_app/Login_widget.dart';
import 'package:recipe_app/auth_page.dart';
import 'package:recipe_app/home_page.dart';
import 'package:recipe_app/utils.dart';
import 'package:recipe_app/verify_email_page.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          //suffixIconColor: Colors.pink2,

          contentPadding: EdgeInsets.fromLTRB(30, 20, 20, 20),
          filled: true,
          fillColor: Color.fromARGB(39, 255, 255, 255),
        ),
        primarySwatch: Colors.primaryWhite,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong!'));
        } else if (snapshot.hasData) {
          return VerifyEmailPage();
        } else {
          return AuthPage();
        }
      }),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
