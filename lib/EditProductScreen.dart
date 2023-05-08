import 'dart:io';

import 'package:chachukishop/DbMethods.dart';
import 'package:chachukishop/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'LoginScreen.dart';

class EditProductScreen extends StatefulWidget {

  final String uidWithIndex,myUid;
  const EditProductScreen({Key? key, required this.uidWithIndex, required this.myUid}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  File ?_imageFile;

  bool imageSet=false;

  _addImage()async{
    PickedFile? imageFile=await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if(imageFile!=null){
      setState((){
        _imageFile=File(imageFile.path);
        imageSet=true;
      });
    }
  }

  String imageUrl="";
  String productName='';
  String productPrice='';
  String productQuantity='';
  TextEditingController ?productController;
  TextEditingController? quantityController;
  TextEditingController ?priceController;
Future<void>  getThisProductDetails()async{
  try{
    var snapshot=await FirebaseFirestore.instance.collection("AllShops").doc(widget.myUid).collection('MyShop').doc(widget.uidWithIndex).get();
    if(snapshot.exists){
      Map<String, dynamic>? data=snapshot.data();
      imageUrl=data!['ProductImageUrl'];
      productName=data['ProductName'];
      productPrice=data['ProductPrice'];
      productQuantity=data['ProductQuantity'];

    }
  }
  catch(e){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color:Colors.white, weight: FontWeight.normal, size: 13)));
  }
  }
bool isLoaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getThisProductDetails().then((value) {
      setState((){
        productController=new TextEditingController(text: productName);
        priceController= new TextEditingController(text: productPrice);
        quantityController=new TextEditingController(text: productQuantity);
        isLoaded=true;
      });
    });
  }
  final formKey=GlobalKey<FormState>();

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
        title: styled(text: 'Add Product', color: Colors.black, weight: FontWeight.bold, size: h*0.02),
        leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            }
            ,child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.grey[700],size: h*0.02,)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.015),
          child: isLoaded?Material(
            color: Colors.white,
            elevation: 5.5,
            borderRadius: BorderRadius.circular(10),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top: h*0.04),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: imageSet==false?Tooltip(
                            showDuration: Duration(seconds: 2),
                            message: 'Add Image',
                            child: Material(elevation: 3,borderRadius: BorderRadius.circular(200),child:
                            InkWell(
                              onTap: (){
                                _addImage();
                              },
                              child: Container(
                                width: h*0.15,
                                  height: h*0.15,
                                  padding: EdgeInsets.all(h*0.02),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(200),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          imageUrl,
                                        ),
                                        fit: BoxFit.fill
                                      )
                                  )
                                  ),
                            )),
                          ):
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w*0.05  ),
                            child: Material(
                              elevation: 3.5,
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              child: Container(
                                width: w,
                                height: h*0.2,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                        image: FileImage(_imageFile!),
                                        fit: BoxFit.fitWidth
                                    )
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: h*0.15,left: w*0.05,right: w*0.05),
                      child: TextFormField(controller: productController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Empty product field';
                          }
                          else{
                            return null;
                          }
                        },
                        cursorColor: Colors.grey[800],
                        style:  GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0164,fontWeight: FontWeight.normal)),
                        decoration: InputDecoration(
                          hintStyle:   GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0174,fontWeight: FontWeight.normal)),
                          hintText: 'Product...',
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
                    Padding(
                      padding: EdgeInsets.only(top: h*0.015,left: w*0.05,right: w*0.05),
                      child: TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.phone,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Empty quantity field';
                          }
                          else{
                            return null;
                          }
                        },
                        cursorColor: Colors.grey[800],
                        style:  GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0164,fontWeight: FontWeight.normal)),
                        decoration: InputDecoration(
                          hintStyle:   GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0174,fontWeight: FontWeight.normal)),
                          hintText: 'Quantity...',
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
                    Padding(
                      padding: EdgeInsets.only(top: h*0.015,left: w*0.05,right: w*0.05),

                      child: TextFormField(
                        controller: priceController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Empty price field';
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.grey[800],
                        style:  GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0164,fontWeight: FontWeight.normal)),
                        decoration: InputDecoration(
                          hintStyle:   GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0174,fontWeight: FontWeight.normal)),
                          hintText: 'Price...',
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

                    Padding(
                      padding: EdgeInsets.only(left: w*0.05,right: w*0.05,top: h*0.2,bottom: h*0.07),
                      child: OutlinedButton(onPressed: ()async{
                        if(formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                            if(_imageFile!=null){
                              try{
                                User? user= await FirebaseAuth.instance.currentUser;

                                var c = await FirebaseFirestore.instance.collection("Stock").doc(user!.uid).collection('myStock');
                                var snapshot = await c.where('ProductName', isEqualTo: productController!.text.toString()).get();
                                String idd='';
                                for (var d in snapshot.docs) {
                                  idd=await d.id;
                                }
                                await FirebaseFirestore.instance.collection('Stock').doc(user!.uid).collection('myStock').doc(idd).update(
                                    {
                                      'ProductQuantity':quantityController!.text.toString(),
                                    });
                              }
                              catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color:Colors.white, weight: FontWeight.normal, size:h*0.015),duration: Duration(seconds: 2),),);

                              }
                              String response=await editProductImageAsWell(myUid:widget.myUid,ProductName: productController!.text.toString(), ProductPrice:priceController!.text.toString(), ProductQuantity: quantityController!.text.toString(), imageFile: _imageFile!, uidWithIndex: widget.uidWithIndex);


                              if(response=="success"){
                                ScaffoldMessenger.of(context)..showSnackBar(SnackBar(content: styled(text: 'Saved', color:Colors.white, weight: FontWeight.normal, size:h*0.015),duration: Duration(seconds: 2),),);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                              }
                              else{
                                ScaffoldMessenger.of(context)..showSnackBar(SnackBar(content: styled(text: 'Failed to save product', color:Colors.white, weight: FontWeight.normal, size:h*0.015),duration: Duration(seconds: 5),),);

                              }
                            }
                            else{
                              try{
                                User? user= await FirebaseAuth.instance.currentUser;

                                var c = await FirebaseFirestore.instance.collection("Stock").doc(user!.uid).collection('myStock');
                                var snapshot = await c.where('ProductName', isEqualTo: productController!.text.toString()).get();
                                String idd='';
                                for (var d in snapshot.docs) {
                                  idd=await d.id;
                                }
                                await FirebaseFirestore.instance.collection('Stock').doc(user!.uid).collection('myStock').doc(idd).update(
                                    {
                                      'ProductQuantity':quantityController!.text.toString(),
                                    });
                              }
                              catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color:Colors.white, weight: FontWeight.normal, size:h*0.015),duration: Duration(seconds: 2),),);

                              }
                              String response=await editProductWithoutImage(myUid:widget.myUid,ProductName: productController!.text.toString(), ProductPrice:priceController!.text.toString(), ProductQuantity: quantityController!.text.toString(), uidWithIndex: widget.uidWithIndex);
                              if(response=="success"){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: 'Edited successfully', color:Colors.white, weight: FontWeight.normal, size:h*0.015),duration: Duration(seconds: 2),),);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

                              }
                              else{
                                ScaffoldMessenger.of(context)..showSnackBar(SnackBar(content: styled(text: 'Failed to save product', color:Colors.white, weight: FontWeight.normal, size:h*0.015),duration: Duration(seconds: 5),),);

                              }
                            }
                          }


                      }, child: styled(text: 'Save', color: Colors.black, weight: FontWeight.bold, size:h*0.02),
                        style: OutlinedButton.styleFrom(minimumSize: Size(w,h*0.045),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10 ),
                            ),
                            side: BorderSide(color: Colors.black,style: BorderStyle.solid,width: 1.2)
                        ),),
                    )
                  ],
                ),
              ),
            ),
          ):Center(child: CircularProgressIndicator(),)
        ),
      ),
    );
  }
}
