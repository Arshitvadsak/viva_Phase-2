import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:viva3/screens/vote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routes: {'/': (context) => votePage()},
    ),
  );
}
