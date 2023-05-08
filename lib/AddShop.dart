import 'package:chachukishop/DbMethods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomePage.dart';
import 'LoginScreen.dart';

class AddShop extends StatefulWidget {
  final String shopEmail,shopName,owner,address,regNo;
  const AddShop({Key? key, required this.shopEmail, required this.shopName, required this.owner, required this.address, required this.regNo}) : super(key: key);

  @override
  State<AddShop> createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  List<bool>  _checkBoxValue=[

  ];
  List<String> ProductNames=[];
  List<String> ProductImageUrls=[];
  List<String> ProductPrices=[];
  Future<void> getProducts()async{
     try{
       SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values,);
       SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
         statusBarColor: Colors.transparent,
         systemNavigationBarColor: Colors.transparent,
         systemNavigationBarContrastEnforced: false,
         systemStatusBarContrastEnforced: false,
         systemNavigationBarDividerColor: Colors.white,
         statusBarBrightness: Brightness.light,
       ),);
       User?user=await FirebaseAuth.instance.currentUser;
       QuerySnapshot<Map<String,dynamic>> snapshot=await FirebaseFirestore.instance.collection("AllShops").doc(user!.uid).collection('MyShop').get();
       final docs=snapshot.docs;

       for(int i=0;i<docs.length;++i){
         final data=docs[i].data();
         ProductNames.add(data['ProductName']);
         ProductImageUrls.add(data['ProductImageUrl']);
         ProductPrices.add(data['ProductPrice']);
       }

     }
     catch(e){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color: Colors.white, weight:FontWeight.normal, size:13),duration: Duration(seconds: 10),));
     }

  }

bool loaded=false;
  @override
  initState(){
    super.initState();
    getProducts().then((value){
      setState((){
        loaded=true;
      });
    });

  }

  List<TextEditingController> controllers=[];

  bool isSavingProgressVisible=false;

  List<String> ProductNamesSelected=[];
  List<String> ProductPricesSelected=[];
  List<String> ProductImageUrlsSelected=[];
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
        title: styled(text: 'Set Prices', color: Colors.black, weight: FontWeight.bold, size: h*0.02),

        leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            }
            ,child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.grey[400],size: h*0.02,)),
      ),

      body: loaded==true?SafeArea(
        child: isSavingProgressVisible?Center(child: CircularProgressIndicator(),):Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.03,vertical: h*0.02),
          child: Material(
            elevation: 7,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: w,
              height: h*0.9,
              decoration: BoxDecoration(
            color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),

              child:Stack(
                children: [
                  ProductNames.length>0?
                  ListView.builder(itemBuilder: (context,index){

                  if(index<ProductNames.length){
                    controllers.add(TextEditingController(text: ProductPrices[index]));

                    _checkBoxValue.add(false);

                  }

                    return index<ProductNames.length? Padding(
                      padding:  EdgeInsets.only(bottom: h*0.01,top: index==0?h*0.02:0 ,left: w*0.02,right: w*0.02),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        elevation: 2.4,
                        child: Container(
                          width: w,
                          height: h*0.1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: w*0.03),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child: styled(text: ProductNames[index], color: Colors.black, weight: FontWeight.w600, size: h*0.017)),


                                Container(
                                  width: w*0.4,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: w*0.25 ,
                                        height: h*0.05,
                                        child: TextFormField(
                                          controller: controllers[index],
                                          keyboardType: TextInputType.phone,
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return 'Empty price field';
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
                                            // hintText: ProductPrices[index],
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5),
                                                borderSide: BorderSide(color: Colors.grey[700]!,width: 0.8)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5),
                                                borderSide: BorderSide(color: Colors.black,width: 1.5)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5),
                                                borderSide: BorderSide(color: Colors.grey[700]!,width: 1)
                                            ),
                                          ),
                                        ),
                                      ),

                                      Checkbox(activeColor: Colors.grey[700]!,value: _checkBoxValue[index], onChanged: (value){
                                        setState((){
                                          _checkBoxValue[index]=value!;
                                        });
                                      },
                                        // tristate: false,
                                      )
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
                      padding: EdgeInsets.symmetric(horizontal: w*0.02),
                      child: OutlinedButton(onPressed:isSavingProgressVisible?(){}: ()async{
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: widget.shopEmail, color:Colors.white, weight: FontWeight.normal, size: h*0.015)));
                        setState((){
                          isSavingProgressVisible=true;});
                        try{


                            for(int i=0;i<ProductNames.length;++i){

                              if((_checkBoxValue[i]==true)&&(controllers[i].text!="")){

                                ProductNamesSelected.add(ProductNames[i]);

                                ProductImageUrlsSelected.add(ProductImageUrls[i]);

                                ProductPricesSelected.add(controllers[i].text.toString());

                              }

                            }

                            User? user=await FirebaseAuth.instance.currentUser;
                            await FirebaseFirestore.instance.collection('Shops').doc(user!.uid).collection('regShops').doc(widget.shopEmail).set({
                              "ProductNames":ProductNamesSelected.toList(),
                              "ProductPrices":ProductPricesSelected.toList(),
                              "ProductImageUrls":ProductImageUrlsSelected.toList()
                            }).then((value)async{
                              try{
                                await FirebaseFirestore.instance.collection('AllShopsReg').doc(widget.shopEmail).set(
                                    {
                                      'ShopEmail':widget.shopEmail,
                                      'ShopName':widget.shopName,
                                      'Owner':widget.owner,
                                      'RegNo':widget.regNo,
                                      'Address':widget.address,
                                      'Uid':user.uid
                                    }).then((value) {
                                  setState((){
                                    isSavingProgressVisible=false;});
                                });
                              }
                              catch(e){    setState((){
                                isSavingProgressVisible=false;});
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color: Colors.white, weight:FontWeight.normal, size:h*0.015),duration: Duration(seconds: 2),));

                              }

                            }).then((value) {
                              setState((){
                                isSavingProgressVisible=false;});

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: 'Shop has been set successfully', color: Colors.white, weight:FontWeight.normal, size:h*0.015),duration: Duration(seconds: 2),));
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                            });










                        }

                        catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color: Colors.white, weight:FontWeight.normal, size:h*0.015),duration: Duration(seconds: 7),));
                        }
                      }, child: styled(text: 'Save', color: Colors.black, weight: FontWeight.bold, size:h*0.015),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(w, h*0.045),
                          side: BorderSide(color: Colors.black,width: 1.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          )
                        ),
                       ),
                    );
                  },itemCount: ProductNames.length+1
                  ):Center(child: styled(text: 'No product(s) found', color: Colors.grey[700]!, weight: FontWeight.bold, size:h*0.0167),)
                ],
              )
            ),
          ),
        ),
      ):Center(child: CircularProgressIndicator(),)
    );
  }
}
