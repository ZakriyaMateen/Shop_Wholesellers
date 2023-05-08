import 'package:chachukishop/LoginScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'DbMethods.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  Color emailIconColor=Colors.grey[700]!;
  Color passwordIconColor=Colors.grey[700]!;
  Color ConfirmPasswordIconColor=Colors.grey[700]!;
  final formKey=GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();

  bool isObsecure=true;
  @override
  Widget build(BuildContext context) {

    double w = MediaQuery
        .of(context)
        .size
        .width;
    double h = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [

          Align(
            alignment: Alignment.topLeft,
            child: Material(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(w*0.5)),
              elevation: 5,
              child: Container(
                width: w,
                height: h*0.5,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(w*0.5))
                ),
                child: Center(
                  child: styled(text: 'Sign up', color:Colors.white, weight: FontWeight.bold, size: h*0.023),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Material(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(w*0.5)),
              elevation: 5,
              child: Container(
                width: w,
                height: h*0.2,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(w*0.5))
                ),
                child: Center(
                  child: styled(text: 'Login to Continue', color:Colors.white, weight: FontWeight.bold, size: h*0.023),
                ),
              ),
            ),
          ),

          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w*0.07,vertical: h*0.025),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: w,
                    height: h*0.6,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:EdgeInsets.only(left:w*0.05,right: w*0.05),
                          child: Form(
                            key: formKey,
                            child: Column(
                                children: [
                                  TextFormField(
                                    onTap: (){
                                      if(passwordIconColor==Colors.black){
                                        passwordIconColor=Colors.grey[700]!;
                                      }
                                      if(ConfirmPasswordIconColor==Colors.black){
                                        ConfirmPasswordIconColor=Colors.grey[700]!;
                                      }
                                      setState((){
                                        if(emailIconColor==Colors.grey[700]!){
                                          emailIconColor=Colors.black;
                                        }
                                        else{
                                          emailIconColor=Colors.grey[700]!;

                                        }
                                      });
                                    },
                                    onFieldSubmitted: (value){
                                      setState((){
                                        if(emailIconColor==Colors.grey[700]!){
                                          emailIconColor=Colors.black;
                                        }
                                        else{
                                          emailIconColor=Colors.grey[700]!;

                                        }
                                      });
                                    },
                                    controller: emailController,
                                    validator: (value){
                                      if(!EmailValidator.validate(value!)){
                                        return "Invalid email";
                                      }
                                      else{
                                        return null;
                                      }
                                    },
                                    style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold,fontSize: h*0.015),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email_rounded,color: emailIconColor,),
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey,width: 0.7),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
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
                                      if(value.length<6){
                                        return "Password is too week";
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
                                      if(ConfirmPasswordIconColor==Colors.black){
                                        ConfirmPasswordIconColor=Colors.grey[700]!;
                                      }
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
                                  SizedBox(height: h*0.02,),

                                  TextFormField(
                                    controller: confirmPasswordController,
                                    obscureText: isObsecure,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return "Please confirm your password";

                                      }
                                      if(value!=passwordController.text){
                                        return "Passwords do not match";
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
                                      if(passwordIconColor==Colors.black){
                                        passwordIconColor=Colors.grey[700]!;
                                      }
                                      setState((){
                                        if(ConfirmPasswordIconColor==Colors.grey[700]!){
                                          ConfirmPasswordIconColor=Colors.black;
                                        }
                                      });
                                    },
                                    onFieldSubmitted: (value){
                                      setState((){
                                        if(ConfirmPasswordIconColor==Colors.black){
                                          ConfirmPasswordIconColor=Colors.grey[700]!;
                                        }

                                      });
                                    },
                                    decoration: InputDecoration(

                                        prefixIcon: Icon(Icons.lock_clock_rounded,color: ConfirmPasswordIconColor,),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey,width: 0.7),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black,width: 1),
                                        ),
                                        labelText: "Confirm password",
                                        labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: h*0.02)
                                    ),

                                  ),

                                  SizedBox(height: h*0.017,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [styled(text: "Already have an account ", color: Colors.grey[600]!, weight: FontWeight.normal, size: h*0.015),
                                      InkWell(onTap: (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
                                      },child: styled(text: 'login?', color:Colors.black, weight:FontWeight.bold, size: h*0.015)),
                                    ],
                                  ),
                                  SizedBox(height: h*0.05  ,),
                                  OutlinedButton(onPressed: ()async{
                                    if(formKey.currentState!.validate()){
                                      formKey.currentState!.save();



                                      try{

                                        String val = await SignUp(email: emailController.text.toString(), password: passwordController.text.toString());

                                        if(val=="Success"){
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account Created Successfully")));
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                                        }
                                        else{
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error")));
                                        }
                                      }
                                      catch(e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(e.toString()),
                                          duration: const Duration(
                                              seconds: 7),));
                                      }
                                    }

                                  },child:styled(text: 'Register', color: Colors.black, weight: FontWeight.bold, size:h*0.019),
                                    style: OutlinedButton.styleFrom(

                                        minimumSize: Size(w,h*0.04,),
                                        side: BorderSide(color: Colors.black,width: 1.5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                        )
                                    ),),
                                ]
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )



          ) ],
      ),
    );
  }}
// aclonica
Text styled({required String text,required Color color, required FontWeight weight, required double size}){
  return Text(text, style: GoogleFonts.adamina(textStyle: TextStyle(color: color,fontSize: size,fontWeight: weight)),);
}