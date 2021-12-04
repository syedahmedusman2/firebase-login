import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void register()async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    try {
      
      final UserCredential user = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await db.collection("users").doc(user.user.uid).set({
        "email": email,
        "username": username
      });
    } catch(e){
      print(e);
    }

    print("username : "+ username);

  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(border: UnderlineInputBorder(),
                labelText: "Enter Your Username"),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(border: UnderlineInputBorder(),
                labelText: "Enter Your Email"),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(border: UnderlineInputBorder(),
                labelText: "Enter Your Password"),
              ),
            ),

            ElevatedButton(onPressed: register, child: Icon(Icons.app_registration))
          ],
        ),),
      ),
      
    );
  }
}