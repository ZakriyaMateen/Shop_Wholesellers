import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> SignUp({required String email, required String password})async{
  try{

    QuerySnapshot<Map<String, dynamic>> snapShot=await FirebaseFirestore.instance.collection('Accounts').get();

    var length=snapShot.docs.length;
      // if(length==0){

        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        String uid=await FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection("Accounts").doc(uid).set({
          'email':email,
          'password':password,
          'uid':uid,
        });
        SharedPreferences preferences=await SharedPreferences.getInstance();
        await preferences.setString("uid",uid).then((value){
          Fluttertoast.showToast(msg: 'Uid has been saved!',toastLength: Toast.LENGTH_LONG);
        });
        await preferences.setString("email",email).then((value){
          Fluttertoast.showToast(msg: 'Email has been saved!',toastLength: Toast.LENGTH_LONG);
        });
        await preferences.setString("password",password).then((value){
          Fluttertoast.showToast(msg: 'Password has been saved!',toastLength: Toast.LENGTH_LONG);
        });

        return "Success";
      // }
      // else{
      //   Fluttertoast.showToast(msg: 'Access Denied');
      //   return "";
      // }

  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString());
  }
  return "";
}


Future<String> SignIn({required String email, required String password})async{

try{
  SharedPreferences preferences=await SharedPreferences.getInstance();
  preferences.setString("Email", email);
  preferences.setString("Password", password);
}
catch(e){
Fluttertoast.showToast(msg: e.toString());
}
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return "Success";

  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString());
  }
  return "";

}

Future<void> SignOut({required String email, required String password})async{
  try{
    await FirebaseAuth.instance.signOut();
  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString());
  }
}

Future<String> editProfile({required String name, required String designation, required String phone,required String uid, required XFile imageFile})async{

  try{
    firebase_storage.Reference? ref;
    CollectionReference? imgRef;
    File image=await File(imageFile.path);

    try{

      ref=firebase_storage.FirebaseStorage.instance.ref().child(imageFile!.path);
      await ref?.putFile(image!).whenComplete(()  async{
        await ref?.getDownloadURL().then((value)async{
          await FirebaseFirestore.instance.collection("Accounts").doc(uid).update({
            'name':name,
            'designation':designation,
            'phone':phone,
            'profileImage':value

          });
        });
      });
    }
    catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }

    return "Success";
  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString());
  }

  return "";
}

Future<String> addRecipeMethod({required String uid,required String dish,required List<String> ingredients, required String recipe, required String description, required String price, required File imageFile})async{


  try{
    firebase_storage.Reference? ref;
    CollectionReference? imgRef;

    try{





      QuerySnapshot<Map<String, dynamic>> snapShot=await FirebaseFirestore.instance.collection('Recipes').doc(uid).collection('recipes').get();

      var length=snapShot.docs.length;
      ref=firebase_storage.FirebaseStorage.instance.ref().child("RecipeImages"+length.toString());
      String imageUrl="";
      await ref?.putFile(imageFile).whenComplete(() async{

        await ref?.getDownloadURL().then((value) {
          imageUrl=value;
          Fluttertoast.showToast(msg:value);
        }).then((value)async{
          await FirebaseFirestore.instance.collection("Recipes").doc(uid).collection("recipes").doc(uid+length.toString()).set({

            "uid":uid,
            "dish":dish,
            "ingredients":FieldValue.arrayUnion(ingredients),
            "recipe":recipe,
            "description":description,
            "price":price,
            "imageUrl":imageUrl

          });
        });
      });

    }
    catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }

    return "Success";

  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString());
  }

  return "";
}


Future<String> addProduct({required String ProductName,required String ProductPrice,required String ProductQuantity,required File imageFile})async{

  try{
    firebase_storage.Reference? ref;
    CollectionReference? imgRef;

    try{
      User?user;
      user=FirebaseAuth.instance.currentUser;
      QuerySnapshot<Map<String, dynamic>> snapShot=await FirebaseFirestore.instance.collection('AllShops').doc(user!.uid).collection('MyShop').get();
      var length=snapShot.docs.length;


      ref=firebase_storage.FirebaseStorage.instance.ref().child("ProductImages"+length.toString());
      String ProductImageUrl="";
      await ref?.putFile(imageFile).whenComplete(() async{

        await ref?.getDownloadURL().then((value) {
          ProductImageUrl=value;
          // Fluttertoast.showToast(msg:value);
        }).then((value)async{
          await FirebaseFirestore.instance.collection("AllShops").doc(user!.uid).collection('MyShop').add({

            "ProductImageUrl":ProductImageUrl,
            "ProductName":ProductName,
            "ProductQuantity":ProductQuantity,
            "ProductPrice":ProductPrice

          });
        });
      });
      return "success";
    }
    catch(e){
      Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
    }

  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
  }
  return "";
}



Future<String> editProductImageAsWell({required String myUid,required String ProductName,required String ProductPrice,required String ProductQuantity,required File imageFile,required String uidWithIndex})async{

  try{
    firebase_storage.Reference? ref;
    CollectionReference? imgRef;

    try{

      QuerySnapshot<Map<String, dynamic>> snapShot=await FirebaseFirestore.instance.collection('MyShop').get();
      var length=snapShot.docs.length;


      ref=firebase_storage.FirebaseStorage.instance.ref().child("ProductImages"+length.toString());
      String ProductImageUrl="";
      await ref?.putFile(imageFile).whenComplete(() async{

        await ref?.getDownloadURL().then((value) {
          ProductImageUrl=value;
          Fluttertoast.showToast(msg:value);
        }).then((value)async{
          await FirebaseFirestore.instance.collection("AllShops").doc(myUid).collection('MyShop').doc(uidWithIndex).set({

            "ProductImageUrl":ProductImageUrl,
            "ProductName":ProductName,
            "ProductQuantity":ProductQuantity,
            "ProductPrice":ProductPrice

          });
        });
      });
      return "success";
    }
    catch(e){
      Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
    }

  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
  }
  return "";
}



Future<String> editProductWithoutImage({required String myUid,required String ProductName,required String ProductPrice,required String ProductQuantity,required String uidWithIndex})async {


  try{
      await FirebaseFirestore.instance.collection("AllShops").doc(myUid).collection('MyShop').doc(uidWithIndex).update({
        "ProductName": ProductName,
        "ProductPrice":ProductPrice,
        "ProductQuantity":ProductQuantity
      });
      return "success";

  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
  }


  return "";

}




Future<String> addShopLogin({required String email,required String password})async{


  try{
    String uid=await FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String,dynamic>> snapshot=await FirebaseFirestore.instance.collection('Accounts').doc(uid).get();
    if(snapshot.exists) {
      var data = snapshot.data();
      String mainEmail = data!['email'];
      String mainPassword = data!['password'];


      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) async{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: mainEmail, password: mainPassword);
      });




    }


    return "success";

 }
 catch(e){
   Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
 }
 return "";
}

Future<String> addShop({required String email,required Map<String,String> map})async{

  try{
   await FirebaseFirestore.instance.collection('Shops').doc(email).set(map).then((value) {
     return "success";
   });
  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
  }
  return "";
}
