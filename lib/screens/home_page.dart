import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rdp_todolist/services/firestore_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/rdplogo.png'),
            const Text(
              'Daily Planner',
              style: TextStyle(
                  fontFamily: 'Caveat', fontSize: 32, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
