import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth.dart';
import 'addnote.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Unable to initialize firebase.');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
              title: 'Notes app',
              routes: {
                Auth.id: (context) => Auth(),
                AddNote.id: (context) => AddNote()
              },
              initialRoute: Auth.id,
            );
        }

        return CircularProgressIndicator();

      },
    ); //MaterialApp
  }
}