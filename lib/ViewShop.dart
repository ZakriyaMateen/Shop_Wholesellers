import 'package:chachukishop/AddShop.dart';
import 'package:chachukishop/HomePage.dart';
import 'package:chachukishop/LoginScreen.dart';
import 'package:chachukishop/addShopInfo.dart';
import 'package:chachukishop/viewImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewShop extends StatefulWidget {
  final String shopEmail,shopName,uid;
  const ViewShop({Key? key, required this.shopEmail, required  this.shopName, required this.uid}) : super(key: key);

  @override
  State<ViewShop> createState() => _ViewShopState();
}




class _ViewShopState extends State<ViewShop> {

    List<String> ProductNames=[];
    List<String> ProductPrices=[];
    List<String> ProductUrls=[];

    Future<void> getViewProducts()async{
     try{
       User ?user=await FirebaseAuth.instance.currentUser;
       var collection = await FirebaseFirestore.instance.collection(
           'Shops').doc(user!.uid).collection('regShops');
       var docSnapshot = await collection.doc(widget.shopEmail).get();
       if (docSnapshot.exists) {
         Map<String, dynamic>? data = docSnapshot.data();

         var ProductNamesArray=data?['ProductNames'];
         ProductNames= List<String>.from(ProductNamesArray);

         var ProductPricesArray=data?['ProductPrices'];
         ProductPrices= List<String>.from(ProductPricesArray);

         var ProductUrlsArray=data?['ProductImageUrls'];
         ProductUrls= List<String>.from(ProductUrlsArray);
         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$ProductPrices'),duration: Duration(seconds: 10),));


       }
     }
     catch(e){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 10),));
     }

    }


bool isLoaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getViewProducts().then((value){
      setState((){
        isLoaded=true;
      });
    });
  }

  bool isDeleting=false;
     Route<Object?> _dialogBuilder(
        BuildContext context, Object? arguments) {
      return CupertinoDialogRoute<void>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Confirm Delete?'),
            content: const Text("You won't be able to restore this shop"),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () async{
                    Navigator.pop(context);
                    setState((){
                      isDeleting=true;
                    });
                  try{
                    await  FirebaseFirestore.instance.collection('Shops').doc(widget.uid).collection('regShops').doc(widget.shopEmail).delete().then((value)async{
                         var collection = await FirebaseFirestore.instance.collection('AllShopsReg');
                      var snapshots = await collection.where('ShopEmail', isEqualTo:widget.shopEmail).get();

                         for (var doc in snapshots.docs) {
                           await doc.reference.delete();
                         }

                    }).then((value){
                      setState((){
                        isDeleting=false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: widget.shopName+ " has been deleted successfully!", color: Colors.white, weight: FontWeight.normal, size: 16),duration: Duration(seconds: 5),));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>HomePage()));
                    });
                  }
                  catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text:e.toString(), color: Colors.white, weight: FontWeight.normal, size: 12),duration: Duration(seconds: 12),));

                  }


                },
                child:styled(text: 'Confirm', color:Colors.red, weight: FontWeight.normal, size:13.6)
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                  child:styled(text: 'Cancel', color:Colors.black, weight: FontWeight.normal, size:13.6)
              ),
            ],
          );
        },
      );
    }


  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(


              padding: EdgeInsets.only(right: w*0.024),
              child:   CupertinoButton(
                  onPressed: () {
                  try{
                    Navigator.of(context).restorablePush(_dialogBuilder);
                  }
                  catch(e){
                    Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
                  }
                  }
                  ,child: styled(text: 'Remove', color: Colors.red, weight: FontWeight.bold, size: h*0.0179))
          )

      ],
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: InkWell(onTap: (){
          Navigator.of(context).pop();
        },child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.grey[700],size: h*0.02,)),
      ),
      body:isLoaded?Padding(
        padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.04),
        child:isDeleting==false? Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.024),
              child: Column(
                children: [
                  // styled(text: '-- Shop --', color: Colors.black, weight: FontWeight.bold, size:h*0.02),
                  SizedBox(height:h*0.02),
                  styled(text: '-- '+widget.shopName+' --', color: Colors.black, weight: FontWeight.normal, size:h*0.018),

                  Flexible(child: Padding(
                    padding:  EdgeInsets.only(top: h*0.02),
                    child: ListView.builder(itemBuilder: (context,index){
                      return ListTile(
                        tileColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: h*0.005),
                        leading: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>viewImage(imageUrl: ProductUrls[index])));
                          },
                          child: Container(

                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(200),
                                border: Border.all(color:Colors.grey,width: 1.1),
                              ),
                              child: CircleAvatar(foregroundImage: NetworkImage(ProductUrls[index]),)),
                        ),
                        title: styled(text: ProductNames[index], color: Colors.black, weight: FontWeight.bold, size: h*0.0175),
                        trailing: styled(text: ProductPrices[index]+' PKR', color: Colors.black, weight: FontWeight.normal, size: h*0.0175 ),
                      );
                    },itemCount: ProductNames.length,),
                  )),
                  OutlinedButton(onPressed: ()
                  async{
                    // try{
                    //
                    // }
                    // catch(e){
                    //
                    // }
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddShopInfo(shopEmail: widget.shopEmail)));
                  },style:
                    OutlinedButton.styleFrom(
                      minimumSize: Size(w,h*0.042),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      side: BorderSide(color: Colors.black,width: 1.2)
                    ), child: styled(text: "Edit", color: Colors.black, weight: FontWeight.bold, size:h*0.015),)
                ],
              ),
            ),
          ),
        ):Center(child: CircularProgressIndicator(),)
      ):Center(child: CircularProgressIndicator(),)
    );
  }
}
