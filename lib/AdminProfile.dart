import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'LoginScreen.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
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

  TextEditingController ownerController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController regNoController=TextEditingController();
  TextEditingController shopNameController=TextEditingController();

  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: w*0.04,right: w*0.04,top: h*0.05),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     imageSet? Material(
                        borderRadius:  BorderRadius.circular(200),
                        elevation: 3.1,
                        child: Container(
                          width: h*0.1,
                          height: h*0.1,
                          decoration: BoxDecoration(
                              
                            borderRadius:  BorderRadius.circular(200),
                            image: DecorationImage(
                              image: FileImage(_imageFile!),
                              fit: BoxFit.cover
                            )
                          ),
                                                  ),
                      ):Material(
                       borderRadius:  BorderRadius.circular(200),
                       elevation: 3.1,
                       child: InkWell(
                         onTap: (){
                           _addImage();
                         },
                         child: Container(
                           width: h*0.1,
                           height: h*0.1,
                           decoration: BoxDecoration(
                             borderRadius:  BorderRadius.circular(200),
                           ),
                           child:Icon(Icons.camera,color: Colors.grey[500],size: h*0.1,)                  ,
                         ),
                       ),
                     )
                    ],
                  ),


                  SizedBox(height: h*0.09,),
                  TextFormField(
                    controller: ownerController,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Empty Name Field';
                      }
                      else{
                        return null;
                      }
                    },
                    cursorColor: Colors.grey[800],
                    style:  GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0164,fontWeight: FontWeight.normal)),
                    decoration: InputDecoration(
                      labelStyle:   GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0174,fontWeight: FontWeight.normal)),
                      label: styled(text: 'Owner', color: Colors.black, weight: FontWeight.normal, size: h*0.016),
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
                  SizedBox(height: h*0.018,),
                  TextFormField(
                    controller: shopNameController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Empty shop field";
                      }
                      else{
                        return null;
                      }
                    },
                    cursorColor: Colors.grey[800],
                    style:  GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0164,fontWeight: FontWeight.normal)),
                    decoration: InputDecoration(
                      labelStyle:   GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0174,fontWeight: FontWeight.normal)),
                      label: styled(text: "Shop's Name", color: Colors.black, weight: FontWeight.normal, size: h*0.016),
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
                  SizedBox(height: h*0.018,),
                  TextFormField(
                    controller: addressController,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Empty address field';
                      }
                      else{
                        return null;
                      }
                    },
                    cursorColor: Colors.grey[800],
                    style:  GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0164,fontWeight: FontWeight.normal)),
                    decoration: InputDecoration(
                      labelStyle:   GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0174,fontWeight: FontWeight.normal)),
                      label: styled(text: 'Address', color: Colors.black, weight: FontWeight.normal, size: h*0.016),
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
                  // SizedBox(height: h*0.018,),
                  // TextFormField(
                  //   keyboardType: TextInputType.number,
                  //   controller: regNoController,
                  //   validator: (value){
                  //     if(value!.isEmpty){
                  //       return 'Empty reg no. field';
                  //     }
                  //     else{
                  //       return null;
                  //     }
                  //   },
                  //   cursorColor: Colors.grey[800],
                  //   style:  GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0164,fontWeight: FontWeight.normal)),
                  //   decoration: InputDecoration(
                  //     labelStyle:   GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize:h*0.0174,fontWeight: FontWeight.normal)),
                  //     label: styled(text: 'Reg no.', color: Colors.black, weight: FontWeight.normal, size: h*0.016),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5),
                  //         borderSide: BorderSide(color: Colors.grey[700]!,width: 0.8)
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5),
                  //         borderSide: BorderSide(color: Colors.black,width: 1.5)
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5),
                  //         borderSide: BorderSide(color: Colors.grey[700]!,width: 1)
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: h*0.07,),
                  OutlinedButton(onPressed: (){
                    if(_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                    }
                  },  style: OutlinedButton.styleFrom(
                      minimumSize: Size(w,h*0.045),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      side: BorderSide(color: Colors.black,style: BorderStyle.solid,width: 1.5)

                  ), child: styled(text: 'Save', color: Colors.black, weight: FontWeight.bold, size: h*0.02))
                ],
              ),
            ),
          ),
        )
    );
  }
}
