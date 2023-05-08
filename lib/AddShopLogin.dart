import 'package:chachukishop/DbMethods.dart';
import 'package:chachukishop/LoginScreen.dart';
import 'package:chachukishop/addShopInfo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AddShop.dart';

class AddShopLogin extends StatefulWidget {
  const AddShopLogin({Key? key}) : super(key: key);

  @override
  State<AddShopLogin> createState() => _AddShopLoginState();
}

class _AddShopLoginState extends State<AddShopLogin> {

  // Route _createRouteAddShop({required String shopEmail, required String shopName}) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) =>  AddShop(shopEmail: shopEmail,shopName: shopName, shopPassword: '', address: '', regNo: '', owner: '',),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       const begin = Offset(1.0, 0.0);
  //       const end = Offset.zero;
  //       const curve = Curves.easeIn;
  //
  //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve,));
  //
  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }
  bool isObsecure=true;
  TextEditingController passwordController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  // TextEditingController shopNameController=TextEditingController();

  setSystemColors(){
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values,);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.white,
      statusBarBrightness: Brightness.light,
    ),);
  }

  final formKey=GlobalKey<FormState>();

  Color passwordIconColor=Colors.grey[700]!;
  Color emailIconColor=Colors.grey[700]!;

  // Color shopNameIconColor=Colors.grey[700]!;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSystemColors();//
  }
  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          centerTitle: true,
          title: styled(text: 'Add Shop', color: Colors.white, weight: FontWeight.bold, size: h*0.02),
          leading: InkWell(
              onTap: (){
                Navigator.of(context).pop();
              }
              ,child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.grey[400],size: h*0.02,)),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: w,
                height: h*0.43,
                decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.only(topRight: Radius.circular(100),bottomLeft: Radius.circular(100))
                ),),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w *0.05),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: w,
                    height: h*0.43,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w *0.05),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SizedBox(height: h*0.025,),

                                                    SizedBox(height: h*0.01,),


                            TextFormField(
                              controller: emailController,
                              obscureText: false,
                              validator: (value){
                                if(!EmailValidator.validate(value!)){
                                  return "Please enter an email";
                                }

                                else {
                                  return null;
                                }
                              },
                              style:TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold,fontSize: h*0.015  ),
                              onTap: (){
                                if(passwordIconColor==Colors.black){
                                  passwordIconColor=Colors.grey[700]!;
                                }
                                // if(shopNameIconColor==Colors.black){
                                //   shopNameIconColor=Colors.grey[700]!;
                                // }
                                setState((){



                                  if(emailIconColor==Colors.grey[700]!){
                                    emailIconColor=Colors.black;
                                  }
                                });

                              },


                              onFieldSubmitted: (value){
                                setState((){
                                  if(emailIconColor==Colors.black){
                                    emailIconColor=Colors.grey[700]!;
                                  }

                                });
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email,color: emailIconColor,),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey,width: 0.7),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black,width: 1),
                                  ),

                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: h*0.02)
                              ),

                            ),
                            SizedBox(height: h*0.02,),


                            TextFormField(
                              controller: passwordController,
                              obscureText: isObsecure,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Please enter a password";
                                }

                                else {
                                  return null;
                                }
                              },
                              style:TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold,fontSize: h*0.015  ),
                              onTap: (){
                                if(emailIconColor==Colors.black){
                                  emailIconColor=Colors.grey[700]!;
                                }
                                // if(shopNameIconColor==Colors.black){
                                //   shopNameIconColor=Colors.grey[700]!;
                                // }
                                setState((){



                                  if(passwordIconColor==Colors.grey[700]!){
                                    passwordIconColor=Colors.black;
                                  }
                                });

                              },


                              onFieldSubmitted: (value){
                                setState((){
                                  if(passwordIconColor==Colors.black){
                                    passwordIconColor=Colors.grey[700]!;


                                  }

                                });
                              },
                              decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                      onTap: (){},
                                      child: InkWell(onTap: (){
                                        setState((){
                                          if(isObsecure){
                                            isObsecure=false;
                                          }
                                          else{
                                            isObsecure=true;
                                          }
                                        });
                                      },child: Icon(isObsecure?Icons.visibility_off:Icons.visibility,color: passwordIconColor,))),
                                  prefixIcon: Icon(Icons.lock,color: passwordIconColor,),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey,width: 0.7),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black,width: 1),
                                  ),

                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: h*0.02)
                              ),

                            ),
                            SizedBox(height: h*0.08,),
                            OutlinedButton(onPressed: ()async{
                              if(formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                String shopEmail = emailController.text
                                    .toString();
                                String response = await addShopLogin(
                                    email: emailController.text.toString(),
                                    password: passwordController.text.toString());
                                if (response == "success") {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) =>
                                          AddShopInfo(shopEmail: shopEmail,
                                            )));
                                  // String shopName=shopNameController.text.toString();
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: 'Could not create id for this shop', color:Colors.white, weight: FontWeight.normal, size: h*0.015),duration: Duration(seconds: 8),));
                                }
                              }
                            },
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size(w,h*0.045),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  side: BorderSide(color: Colors.black,style: BorderStyle.solid,width: 1.5)

                              ), child:styled(text: 'Continue', color: Colors.black, weight: FontWeight.bold, size: h*0.02),)


                          ],


                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        )

    );
  }
}
