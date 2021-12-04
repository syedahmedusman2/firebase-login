import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

  void login()async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    try {
     final UserCredential user = await auth.signInWithEmailAndPassword(email: email, password: password);
     final DocumentSnapshot snapshot = await db.collection("users").doc(user.user.uid).get();

     final data = snapshot.data();

     Navigator.of(context).pushNamed('/home');

    //  print("user is logged in");
    //  print(data['username']);
      
    //   final UserCredential user = await auth.createUserWithEmailAndPassword(email: email, password: password);
    //   await db.collection("users").doc(user.user.uid).set({
    //     "email": email,
    //     "username": username
    //   });
    } catch(e){
      print(e);
    }
   // print("username : "+ username);

  }

  void reg(){
      Navigator.of(context).pushNamed('/register');
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

            Padding(
              padding: const EdgeInsets.all(13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    child: ElevatedButton(onPressed: login, child: Icon(Icons.login), style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.black, width: 30)
                      
                    ),),
                  ),
                  ElevatedButton(onPressed: reg, child: Text("Not have an account"), style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.black, width: 30)
                    
                  )),
                ],
              ),
            ),
            ElevatedButton(onPressed: (){signInWithGoogle();}, child: Text("Sign in with Google"))
            

          ],
        ),
        ),
      ),
      
    );
  }
}