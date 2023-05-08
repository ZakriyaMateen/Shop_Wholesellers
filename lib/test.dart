import 'package:chachukishop/viewImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AllOrdersScreen.dart';
import 'DeliveredOrdersScreen.dart';
import 'LoginScreen.dart';
import 'ShowBillScreen.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}
bool isLoaded=true;

bool Navigate=false;

class _testState extends State<test> {
  int total=0;
  void showDialog({required double h, required int index})
  {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(

            title: Padding(
              padding: EdgeInsets.only(bottom: h*0.015),
              child: styled(text: 'Delete Product', color: Colors.black, weight: FontWeight.bold, size: 17),
            ),
          content: Text("Are you sure you want to delete the product?"),
          actions: [
            CupertinoDialogAction(
                child: styled(text: 'Confirm', color: Colors.red, weight: FontWeight.normal, size: h*0.02),
                onPressed: ()async
                {
                  String uid=FirebaseAuth.instance.currentUser!.uid;
                  String indexToString=index.toString();
                    await FirebaseFirestore.instance.collection('MyShop').doc(uid+indexToString).delete().then((value){

                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: 'Deleted successfully!', color:Colors.white, weight: FontWeight.normal, size:h*0.015)));
                    });
                }
            ),
            CupertinoDialogAction(
              child: styled(text: 'Cancel', color:Colors.green, weight: FontWeight.bold, size:h*0.02),
              onPressed: (){
                Navigator.of(context).pop();
              }
              ,
            )
          ],
        );
      },
    );
  }
  List<String> productNames=['a','b','c'];
  List<String> productPrices=['12','22','33'];
  List<String> productImageUrls=['','',''];

  List<TextEditingController> controllers=[];

  String shopName='';
  int v=0;
  final formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
  List<String> countList=['','','','',''];
    return
        Scaffold(
          drawer: Drawer(
            backgroundColor: Colors.white,
            child: Padding(
              padding:  EdgeInsets.only(top:h*0.2),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                       border: Border(bottom: BorderSide(color: Colors.grey[500]!,width: 0.2))
                    ),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AllOrdersScreen()));
                      },
                      leading: Icon(Icons.shopping_cart,color: Colors.grey,),
                      title: styled(text: 'All Orders', color: Colors.grey, weight: FontWeight.normal, size: h*0.016),
                      trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: h*0.012,),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[500]!,width: 0.2))
                    ),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliveredOrdersScreen()));
                      },
                      leading: Icon(Icons.remove_shopping_cart,color: Colors.grey,),
                      title: styled(text: 'Delivered', color: Colors.grey, weight: FontWeight.normal, size: h*0.016),
                      trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: h*0.012,),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[500]!,width: 0.2))
                    ),
                    child: ListTile(
                      leading: Icon(Icons.privacy_tip,color: Colors.grey,),
                      title: styled(text: 'Privacy Policy', color: Colors.grey, weight: FontWeight.normal, size: h*0.016),
                      trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: h*0.012,),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[500]!,width: 0.2))
                    ),
                    child: ListTile(
                      onTap: ()async{
                        await FirebaseAuth.instance.signOut();
                      },
                      leading: Icon(Icons.logout,color: Colors.grey,),
                      title: styled(text: 'Sign out', color: Colors.grey, weight: FontWeight.normal, size: h*0.016),
                      trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: h*0.012,),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );


  }

}
