import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'LoginScreen.dart';
import 'ShopScreen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  Future<void>  getPersistance()async{
    String ?email="";
    String ?password="";

    try{
      SharedPreferences preferences=await SharedPreferences.getInstance();
      email=await preferences.getString("Email");
      password=await preferences.getString("Password");
      if(email!=null){
        try{
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password!).then((value)async {
            bool x=await  checkIfDocExists(email!);
            if(x){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logged in Successfully")));
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ShopScreen(shopEmail: email!, sellerEmail: '',)));
            }
            else {
              QuerySnapshot<Map<String,dynamic>> snapshot=await FirebaseFirestore.instance.collection('Accounts').where('email',isEqualTo: email!).get();

                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logged in Successfully")));
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
                    // return "HomePageScreen";


            }

          });
        }
        catch(e){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
        }
      }
      else{
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));

        // return "LoginScreen";
      }



    }
    catch(e){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 10),));

    }



    // return "";
  }
  String whereToGo="";
  Future  whereToGoFunction()async{
    await getPersistance();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // whereToGoFunction().then((value) {
    //   setState((){
    //     isLoaded=true;
    //   });
    // });
    getPersistance().then((value){

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Container(
          color: Colors.white,
          width: 100,
          height: 100,
          child: Image.network("https://firebasestorage.googleapis.com/v0/b/chachukishop.appspot.com/o/appIcon.png?alt=media&token=f882db50-f545-4efc-8a20-97aa5e700209" ,fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
