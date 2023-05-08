

import 'package:chachukishop/LoginScreen.dart';
import 'package:chachukishop/viewImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ShowBillScreen.dart';


class ShopScreen extends StatefulWidget {
  final String shopEmail,sellerEmail;
  const ShopScreen({Key? key, required this.shopEmail, required this.sellerEmail}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  List<TextEditingController> controllers=[];
  int total=0;

  List<String> productNames=[];
  List<String> productPrices=[];
  List<String> productImageUrls=[];

  String uid='';

  Future<void> getUid()async{
    try{
      QuerySnapshot<Map<String,dynamic>> snapshot= await FirebaseFirestore.instance.collection('AllShopsReg').where('ShopEmail',isEqualTo: widget.shopEmail).get();
      final docs=snapshot.docs;

      for(int i=0;i<docs.length;++i){
        final data=docs[i].data();
        uid=data['Uid'];
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  List<String> productQuantities=[];

  Future<void> getShopAccessedProducts()async{

    try{



      
      var collection = await FirebaseFirestore.instance.collection(
          'Shops').doc(uid).collection('regShops');
      var docSnapshot = await collection.doc(widget.shopEmail).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();

        var pNamesArray=data!['ProductNames'];
        var pPricesArray=data!['ProductPrices'];
        var pImageUrlsArray=data!['ProductImageUrls'];

        productNames=List<String>.from(pNamesArray);
        productPrices=List<String>.from(pPricesArray);
        productImageUrls=List<String>.from(pImageUrlsArray);





      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color: Colors.white, weight: FontWeight.normal, size: 13)));
    }

  }

  Future<void> getQuantities()async{
    try{
      var collection1 = await FirebaseFirestore.instance.collection("Stock").doc(uid).collection('myStock').where('Uid',isEqualTo:uid);




      for (var value in productNames) {
        var snapshots = await collection1.where('ProductName', isEqualTo: value).get();
        String productQuantity='';
        for (var doc in snapshots.docs) {
          final data= doc.data();
          productQuantities.add(data['ProductQuantity']);

        }
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color: Colors.white, weight: FontWeight.normal, size: 13)));
    }
  }

  String shopName='';

  List<String> ProductQuantities=[];

  Future<void> getShopName()async{
    // var collection = FirebaseFirestore.instance.collection('AllShops').doc(user!.uid).collection('MyShop');
    // var snapshots = await collection.where('ProductName', isEqualTo: data['ProductName']).get();
    // String id='';
    // for (var doc in snapshots.docs) {
    //   await doc.reference.delete();
    //   id=await doc.id;
    // }
    final da=await FirebaseFirestore.instance.collection('AllShopsReg').where("ShopEmail",isEqualTo:widget.shopEmail).get().then((value) {
      final d=value.docs;
      for(int p=0;p<d.length;++p){
        final dat=d[p].data();
        shopName=dat['ShopName'];
      }
    });

  }

  bool isLoaded=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      getUid().then((value){
        getShopAccessedProducts().then((value){
          getShopName().then((value) {
            getQuantities().then((value) {

              setState((){
              isLoaded=true;
            });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: '$productQuantities', color: Colors.white, weight: FontWeight.normal, size: 13),duration: Duration(seconds: 20),));


            });

          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: styled(text: 'Available Products', color: Colors.black, weight: FontWeight.bold, size: h*0.0164),
        actions: [
          CupertinoButton(child: styled(text: 'Log Out', color: Colors.red!, weight: FontWeight.normal, size: h*0.013), onPressed: ()async{
            await FirebaseAuth.instance.signOut().then((value)async{
              SharedPreferences pref=await SharedPreferences.getInstance();
              await pref.setString("Email","");
              await pref.setString("Password","");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            });

          })
        ],
      ),
      body: isLoaded? SafeArea(
        child: Center(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: w*0.035  ,vertical: h*0.02),
            child: Material(
              elevation: 7.7,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Container(
                width: w,
                height: h*0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    SizedBox(height: h*0.0155,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        styled(text: shopName, color:Colors.black, weight: FontWeight.bold, size:h*0.018),
                      ],
                    ),
                    Flexible(
                      child: ListView.builder(itemBuilder: (context,index){

                        controllers.add(TextEditingController(text: '0'));

                       return index!=productNames.length? Padding(
                          padding: EdgeInsets.only(left: w*0.02,right: w*0.02,top: index==0?h*0.015:0,bottom: h*0.012),
                          child: Material(
                            elevation: 2.5,
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: w,
                              height: h*0.12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: w*0.02),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    InkWell(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>viewImage(imageUrl:productImageUrls[index])));
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(200),
                                            border: Border.all(color:Colors.grey[700]!,width: 1.2)
                                          ),
                                          child: CircleAvatar(backgroundColor: Colors.white,radius: w*0.048,foregroundImage: NetworkImage(productImageUrls[index]),)),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Flexible(child: styled(text: productNames[index], color:Colors.black, weight: FontWeight.w600, size:h*0.0152)),
                                         SizedBox(height: h*0.004,),
                                         Flexible(child: styled(text: productPrices[index]+' /piece' , color:Colors.black, weight: FontWeight.normal, size:h*0.014)),
                                        SizedBox(height: h*0.004,),
                                        Flexible(child: Text('${productQuantities[index]} available',style: GoogleFonts.adamina(textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: h*0.014,fontStyle: FontStyle.italic)),)),
                                      ],
                                    ),
                                    Container(
                                      width: w*0.45,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Material(
                                            elevation: 3,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),

                                            child: InkWell(
                                              onTap: (){
                                                setState((){
                                                  int val=int.parse(controllers[index].text.toString());
                                                  if(val>0){
                                                    val--;
                                                    controllers[index].text=val.toString();
                                                    total=total-int.parse(productPrices[index]);
                                                  }
                                                  if( total<0){
                                                    setState((){
                                                      total=0;
                                                    });
                                                  }
                                                });
                                                // setState((){
                                                //   int val=int.parse(controllers[index].text.toString());
                                                //  if(val>0){
                                                //    val--;
                                                //    controllers[index].text=val.toString();
                                                //    total=total-int.parse(productPrices[index]);
                                                //
                                                //  }
                                                // });
                                              },
                                              child: Container(
                                                width: w*0.08,
                                                height: h*0.05,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                    colors: [
                                                      Colors.red[900]!,
                                                      Colors.red[800]!,

                                                      Colors.red[800]!,
                                                      Colors.red[900]!,
                                                    ]
                                                  )
                                                ),
                                                child: Center(
                                                  child: Icon(Icons.remove,color: Colors.white,size: w*0.04,),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: w*0.25 ,
                                            height: h*0.05,
                                            child: TextFormField(
                                              enabled: false,


                                              onFieldSubmitted: (value){
                                                setState((){
                                                  if(controllers[index].text==""){
                                                    controllers[index].text="0";
                                                  }
                                                });
                                              },
                                              // onTap: (){
                                              //   setState((){
                                              //     controllers[index].text="0";
                                              //   });
                                              // },

                                              controller: controllers[index],
                                              keyboardType: TextInputType.phone,
                                              validator: (value){
                                                if(value!.isEmpty){
                                                  return 'Empty product field';
                                                }
                                                else{
                                                  return null;
                                                }
                                              },
                                              cursorColor: Colors.grey[800],
                                              style:  GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.014,fontWeight: FontWeight.normal)),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: h*0.02,left: w*0.012),
                                                hintStyle:   GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.016,fontWeight: FontWeight.normal)),
                                                hintText: 'Quantity...',
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.grey[700]!,width: 0.8)
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black,width: 1.5)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    // borderRadius: BorderRadius.circular(5),
                                                    borderSide: BorderSide(color: Colors.grey[700]!,width: 1)
                                                ),
                                              ),
                                            ),
                                          ),
                                          Material(
                                            elevation: 3,

                                            borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                            child: InkWell(
                                              onTap: (){
                                                setState((){
                                                  if(controllers[index].text.toString()==""){
                                                    controllers[index].text="0";
                                                  }
                                                  else{
                                                    int val=int.parse(controllers[index].text.toString());
                                                    if(val>=0){
                                                     if(val<int.parse(productQuantities[index])){
                                                       val++;
                                                       controllers[index].text=val.toString();
                                                       total=total+int.parse(productPrices[index]);
                                                     }
                                                     else{
                                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: "Couldn't exceed the stock limit", color: Colors.white, weight: FontWeight.normal, size:h*0.013)));
                                                     }
                                                    }
                                                  }
                                                });

                                              },
                                              child: Container(
                                                width: w*0.08,
                                                height: h*0.05,
                                                decoration: BoxDecoration(

                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomLeft,
                                                        colors: [
                                                          Colors.green[900]!,
                                                          Colors.green[800]!,

                                                          Colors.green[800]!,
                                                          Colors.green[900]!,
                                                        ]
                                                    )
                                                ),
                                                child: Center(
                                                  child: Icon(Icons.add,color: Colors.white,size: w*0.04,),
                                                ),
                                              ),
                                            ),
                                          ),



                                        ],
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ):
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.02),
                          child: OutlinedButton(onPressed: ()async{

                            List<String> billProductNames=[];
                            List<String> billProductPrices=[];
                            List<String> billProductImageUrls=[];
                            List<String>   billQtys=[];

                            for(int i=0;i<controllers.length;++i){
                              if((controllers[i].text.toString()!="0")&&(controllers[i].text.toString()!="")){

                                billQtys.add(controllers[i].text.toString());
                                billProductNames.add(productNames[i]);
                                billProductPrices.add(productPrices[i]);
                                billProductImageUrls.add(productImageUrls[i]);

                              }
                            }



                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$billQtys')));
                                    if(billQtys.length>0){

                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowBillScreen(ProductNames:billProductNames,ProductPrices:billProductPrices,ProductImageUrls:billProductImageUrls,ProductQuantities:billQtys, total: total.toString(), shopEmail: widget.shopEmail,shopName: shopName, Uid: uid,)));

                                    }
                                        else{
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: 'Please choose some products ', color: Colors.white, weight:FontWeight.normal, size: h*0.013)));
                                    }



                          }
                          , child: styled(text: 'Proceed', color: Colors.black, weight: FontWeight.bold, size:h*0.016),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(w, h*0.045),
                            side: BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            )
                          ),),
                        );
                      },itemCount: productNames.length + 1,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ):Center(child: Container(width: 40,height: 40,
        child: CircularProgressIndicator(),),)
    );
  }

}

