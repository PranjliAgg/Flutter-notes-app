import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/addnote.dart';

class Auth extends StatefulWidget {
  static String id = 'Auth';
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final GlobalKey<FormState> formKey= GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userEmail, userPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Auth'),
              centerTitle: true,
              backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.green.shade100,
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Authentication',
                style: TextStyle(
                  fontSize: 36.0,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(height: 45.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email'
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (String email) {
                  userEmail = email;
                },
                validator: (String email) {
                  if (email == null || email.isEmpty) {
                    return "Please enter your email";
                  }

                  else{
                    return null;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration (
                  hintText: 'Password',
                ),
                keyboardType: TextInputType.visiblePassword,
                onSaved: (String password) {
                  userPassword = password;
                },
                validator: (String password) {
                  if (password == null || password.isEmpty) {
                    return "Please enter your password";
                  }
                  else{
                    return null;
                  }
                },
                obscureText: true,
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Login'),
                    onPressed: () {
                      if(formKey.currentState.validate()==true) {
                        formKey.currentState.save();

                        try {
                          final user = auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);

                          if (auth.currentUser !=null) {
                            Navigator.pushNamed(context, AddNote.id);
                          }

                          }on FirebaseAuthException catch (error) {
                          if (error.code=='user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user found')));
                          } else if (error.code=='wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong password entered')));
                          }
                        }
                      }
                    },
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    child: Text('Register'),
                    onPressed: () async {
                      if(formKey.currentState.validate() == true) {
                        formKey.currentState.save();
                        try {
                          final newUser = await auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);

                          if (newUser != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered user successfully')));
                            Navigator.pushNamed(context, AddNote.id);
                          }

                        } on FirebaseAuthException catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
                      }
                      }
                    },
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    child: Text('Logout', style: TextStyle(color: Colors.black),),
                    onPressed: () {
                      auth.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out successfully')));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}