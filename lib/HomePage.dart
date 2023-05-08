import 'package:chachukishop/AdminProfile.dart';
import 'package:chachukishop/EditProductScreen.dart';
import 'package:chachukishop/PrivacyPolicy.dart';
import 'package:chachukishop/StockDetails.dart';
import 'package:chachukishop/viewImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddProduct.dart';
import 'AddShopLogin.dart';
import 'AllOrdersScreen.dart';
import 'DeliveredOrdersScreen.dart';
import 'LoginScreen.dart';
import 'ViewShop.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Route _createRouteAddCourse() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  AddProduct(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve,));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteAddShopLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  AddShopLogin(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve,));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


  Route _createRouteViewShop({required String email, required String name}) {

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  ViewShop(uid: user!.uid,shopEmail:email,shopName:name),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve,));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  int _currentIndex=0;
  Color ShopsColor=Colors.black;
  Color AccountColor=Colors.grey;
  List<String> names=[];
  List<String> emails=[];

  List<String> emailsForDocs=[];
  List<String> Total=[];


  User? user;
  List<String> usableName=[];
  List<String> emailsForOrders=[];
  List<String> namesForOrders=[];

  Future<void> getUid()async{
    try{

      user=await FirebaseAuth.instance.currentUser;
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> getShopInfo()async{

    var snapshot= await FirebaseFirestore.instance.collection('ShopInfo').doc(user!.uid).collection('regShopInfo').get();
    final docs= snapshot.docs;
    for(int i=0;i<docs.length;++i){
      final data=docs[i].data();
      namesForOrders.add(data['ShopName']);
      emailsForOrders.add(data['ShopEmail']);
    }

  }

  void showDialog({required double h, required int index,required var snapshots})
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
                try{
                  String id='';
                  for (var doc in snapshots.docs) {
                    await doc.reference.delete();
                    id=await doc.id;
                  }
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: 'Deleted successfully!', color:Colors.white, weight: FontWeight.normal, size:h*0.015)));
                }
                catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color:Colors.white, weight: FontWeight.normal, size:h*0.015)));

                }
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
  bool firstIsLoaded=false;
  bool isLoaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUid().then((value){
      setState((){
        firstIsLoaded=true;
      });
      getShopInfo().then((value){
        setState((){
          isLoaded=true;
        });
      });
    });


  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values,);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),);
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      animationDuration: const Duration(seconds: 1),

      child: Scaffold(

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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminProfile()));
                    },
                    leading: Icon(Icons.account_box_rounded,color:  Colors.grey[600]!,),
                    title: styled(text: 'Profile', color: Colors.grey[600]!, weight: FontWeight.normal, size: h*0.016),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: h*0.012,),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[500]!,width: 0.2))
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AllOrdersScreen()));
                    },
                    leading: Icon(Icons.shopping_cart,color:  Colors.grey[600]!,),
                    title: styled(text: 'All Orders', color:  Colors.grey[600]!, weight:    FontWeight.normal, size: h*0.016),
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
                    leading: Icon(Icons.remove_shopping_cart,color:  Colors.grey[600]!,),
                    title: styled(text: 'Delivered', color: Colors.grey[600]!, weight: FontWeight.normal, size: h*0.016),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: h*0.012,),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[500]!,width: 0.2))
                  ),
                  child: ListTile(
                    onTap: ()async{
                      // Icons.balance
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>StockDetails(uid:user!.uid)));
                    },
                    leading: Icon(Icons.bar_chart,color:  Colors.grey[600]!,),
                    title: styled(text: 'Stock Details', color: Colors.grey[600]!, weight: FontWeight.normal, size: h*0.016),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: h*0.012,),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[500]!,width: 0.2))
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy()));

                    },
                    leading: Icon(Icons.privacy_tip,color:  Colors.grey[600]!,),
                    title: styled(text: 'Privacy Policy', color:  Colors.grey[600]!, weight: FontWeight.normal, size: h*0.016),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: h*0.012,),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[500]!,width: 0.2))
                  ),
                  child: ListTile(
                    onTap: ()async{
                    try{
                      await FirebaseAuth.instance.signOut().then((value) async{
                        SharedPreferences pref=await SharedPreferences.getInstance();

                        await pref.setString("Email","");

                        await pref.setString("Password","").then((value) {

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

                        });

                      });

                    }
                    catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color: Colors.white, weight:FontWeight.normal, size:h*0.013)));
                    }
                    },
                    leading: Icon(Icons.logout,color:  Colors.grey[600]!,),
                    title: styled(text: 'Sign out', color: Colors.grey[600]!, weight: FontWeight.normal, size: h*0.016),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey[400],size: h*0.012,),
                  ),
                ),



              ],
            ),
          ),
        ),

        backgroundColor: Colors.white,
        body:    firstIsLoaded==false?Center(child: Container(width:50,height:50,child: Center(child: CircularProgressIndicator(),))): SafeArea(
          child: Stack(
            children:[

              Padding(
                padding: EdgeInsets.only(top: h*0.08),
                child: Align(
                  alignment: Alignment.center,
                  child: TabBarView(
                      children:[

                     isLoaded? StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                      stream: FirebaseFirestore.instance.collection('Orders').doc(user!.uid).collection('MyOrders').where('Status',isEqualTo: 'Pending').snapshots(),
                      builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return Center(child: styled(text: "No orders yet", color: Colors.black, weight:FontWeight.bold, size:h*0.02),);
                      }
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }
                      if(snapshot.hasData){
                        final docs=snapshot.data!.docs;
                        return ListView.builder(scrollDirection: Axis.vertical,itemBuilder: (context,indexx){

                            final data=docs[indexx].data();

                            var arrayurl=data['ProductImageUrls'];
                            var arraynames=data['ProductNames'];
                            var arrayprices=data['ProductPrices'];
                            var arrayqt=data['ProductQuantities'];

                            List<String> priceList=List<String>.from(arrayprices);
                            List<String> nameList=List<String>.from(arraynames);
                            List<String> qtList=List<String>.from(arrayqt);
                            List<String> urlList=List<String>.from(arrayurl);
                            emailsForDocs.add(data['email']);
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$emailsForDocs')));

                            int x=0;
                            int y=0;
                            List<String> totalForEach=[];
                            for(int i=0;i<nameList.length;++i){
                              x=int.parse(qtList[i]) * int.parse(priceList[i]);
                              totalForEach.add(x.toString());
                            }
                            for(int i=0;i<totalForEach.length;++i){
                              y+=int.parse(totalForEach[i]);
                            }
                            Total.add(y.toString());

                            return   docs.length>0? Padding(
                              padding: EdgeInsets.symmetric(horizontal: w*0.04,vertical: h*0.02),
                              child: Material(
                                color: Colors.white,

                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    width: w,
                                    // height: h*0.85,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton(onPressed: ()async{

                                              // await FirebaseFirestore.instance.collection('MyOrders').doc(emailsForDocs[indexx]).update({
                                              //   "Status":"Done"
                                              // });
                                              try{
                                                
                                                var snapshot = await FirebaseFirestore.instance.collection('AllShops').doc(user!.uid).collection('MyShop');
                                                String id='';
                                                int i=0;
                                                String eachProductQuantityString='';
                                                int eachProductQuantityInt=0;
                                                int remainingStock=0;
                                                nameList.forEach((element) async{
                                                 var snap=await snapshot.where('ProductName',isEqualTo: element).get();


                                                  for (var doc in snap.docs) {
                                                    id=await doc.id;
                                                  }
                                                  DocumentSnapshot<Map<String,dynamic>> docSnap=await FirebaseFirestore.instance.collection('AllShops').doc(user!.uid).collection('MyShop').doc(id).get();
                                                  if(docSnap.exists){
                                                    final data=docSnap.data();
                                                      eachProductQuantityString=data?['ProductQuantity'];
                                                      eachProductQuantityInt=int.parse(eachProductQuantityString);
                                                      remainingStock=eachProductQuantityInt-int.parse(qtList[i]);
                                                  }
                                                  await FirebaseFirestore.instance.collection('AllShops').doc(user!.uid).collection('MyShop').doc(id).update({
                                                      'ProductQuantity':remainingStock.toString()
                                                  });
                                                  i++;
                                                });
                                                await FirebaseFirestore.instance.collection('Orders').doc(user!.uid).collection('MyOrders').doc(emailsForDocs[indexx]).update({
                                                  "Status":"Done"
                                                });
                                              }
                                              catch(e){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color: Colors.white, weight: FontWeight.normal, size: 13)));
                                              }


                                              // await FirebaseFirestore.instance.collection("Stock").doc(user!.uid).collection('myStock').where('ProductName',isEqualTo:nameList[index]);


                                          }, child:styled(text: 'Mark as done', color: Colors.black, weight: FontWeight.bold, size:h*0.016)),
                                          styled(text:"-- "+ data['ShopName']+ " --", color: Colors.grey[700]!, weight: FontWeight.bold, size: h*0.016),
                                          SizedBox(height:h*0.02),
                                          ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),itemBuilder: (context,index){
                                            return Container(
                                              // top: index==0?BorderSide(color: Colors.grey,width: 1):BorderSide(color: Colors.grey,width: 0.5),left: BorderSide(color: Colors.grey,width: 1),right: BorderSide(color: Colors.grey,width: 1),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(color: Colors.grey[400]!,width:index==0? h*0.0005:0),
                                                    bottom:BorderSide(color: Colors.grey[400]!,width: h*0.0003)
                                                ),
                                                // borderRadius:index==0?BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)):index==widget.ProductNames.length-1?BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)):null
                                              ),
                                              child: ListTile(
                                                leading: InkWell(
                                                  onTap: (){
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>viewImage(imageUrl:urlList[index])));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey,width: 1.2),
                                                        borderRadius: BorderRadius.circular(200)
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: w*0.043,
                                                      backgroundColor: Colors.white,
                                                      foregroundImage: NetworkImage(urlList[index]),
                                                    ),
                                                  ),
                                                ),
                                                title: styled(text: qtList[index]+' x '+ nameList[index], color:Colors.black, weight:FontWeight.bold, size:h*0.017),

                                                trailing: styled(text:totalForEach[index], color:Colors.black, weight:FontWeight.bold, size:h*0.017),
                                              ),
                                            );
                                          },itemCount: nameList.length,),

                                          Padding(
                                            padding:  EdgeInsets.only(bottom: h*0.02,top: h*0.015),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                styled(text: 'Total  ', color: Colors.black, weight: FontWeight.bold, size:h*0.016),
                                                styled(text:Total[indexx], color: Colors.black, weight: FontWeight.normal, size:h*0.016),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(bottom: h*0.02),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                styled(text: 'Status  ', color: Colors.black, weight: FontWeight.bold, size:h*0.02),
                                                styled(text:data['Status'], color: Colors.red, weight: FontWeight.normal, size:h*0.02),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                ),
                              ),
                            ):Center(
                              child:styled(text: 'No orders yet', color: Colors.grey[700]!, weight: FontWeight.bold, size:h*0.016) ,
                            );
                        },itemCount: docs.length,);
                      }
                      return styled(text: 'No orders yet', color: Colors.black, weight:FontWeight.bold, size:h*0.016);
                      }
                    ):Center(child: Container(width: 40,height:40,child: CircularProgressIndicator())),
                    Padding(
                      padding:  EdgeInsets.only(top: h*0.02),
                      child: Scaffold(
                        backgroundColor: Colors.white,
                        floatingActionButton: FloatingActionButton(onPressed: (){
                          Navigator.of(context).push(_createRouteAddShopLogin());

                        },backgroundColor: Colors.black,child: Center(child: Icon(CupertinoIcons.add,color: Colors.white,),),),
                        body: Align(
                          alignment: Alignment.center,
                          child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                            stream: FirebaseFirestore.instance.collection('AllShopsReg').where('Uid',isEqualTo: user!.uid).snapshots(),
                            builder: (context, snapshot) {
                            if(snapshot.hasError){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: 'Please register a shop!', color: Colors.black, weight: FontWeight.normal, size: h*0.017)));
                            }
                            if(snapshot.connectionState==ConnectionState.waiting){
                                return CircularProgressIndicator();
                            }
                            if(snapshot.hasData){
                              final docs=snapshot.data!.docs;
                              return docs.length>0? ListView.builder(itemBuilder: (context,index){
                                final data=docs[index].data();
                                emails.add(data['ShopEmail']);
                                names.add(data['ShopName']);
                                return InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(_createRouteViewShop(email:emails[index],name:names[index]));
                                  },
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    style: ListTileStyle.list,
                                    leading: Material(
                                      borderRadius: BorderRadius.circular(200),
                                      elevation: 3,
                                      child: Container(width: w*0.1,
                                        height: w*0.1 ,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black,
                                                Colors.grey[900]!,
                                                Colors.grey[700]!,
                                                Colors.grey[800]!,
                                                Colors.grey[900]!,
                                                Colors.black,
                                              ],
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft
                                          ),
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                        child: Center(
                                          child: Icon(CupertinoIcons.person_fill,color: Colors.white,),
                                        ),
                                      ),
                                    ),
                                    title: styled(text: data['ShopName'], color: Colors.black, weight: FontWeight.bold, size: h*0.0165),
                                    subtitle: styled(text: data['ShopEmail'], color: Colors.grey[700]!, weight: FontWeight.normal, size:h*0.016),
                                    trailing: Icon(Icons.arrow_forward_ios_outlined,color: Colors.grey[700],size: w*0.027,),
                                  ),
                                );
                              },itemCount: docs.length,):
                                  Center(child:  styled(text: 'Please register a shop!', color: Colors.black, weight: FontWeight.normal, size: h*0.017),);

                            }
                            return       Center(child: Container(width: 40,height: 40,child: Center(child: CircularProgressIndicator(),),),);


                            }
                          ),
                        ),
                      ),
                    ),

                   Padding(
                     padding: EdgeInsets.only(top: h*0.015),
                     child: Scaffold(
                       floatingActionButton: FloatingActionButton(
                         tooltip: 'Add Product',
                         backgroundColor: Colors.black,
                         child: Center(
                           child: Icon(CupertinoIcons.add,color: Colors.white,),
                         ),
                         onPressed: (){
                           Navigator.of(context).push(_createRouteAddCourse());
                       },),
                       body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                         stream: FirebaseFirestore.instance.collection("AllShops").doc(user!.uid).collection('MyShop').snapshots(),
                         builder: (context, snapshot) {

                           if(snapshot.hasError){
                             return Center(child: styled(text: 'No Products', color: Colors.black, weight: FontWeight.normal, size:h*0.02),);
                           }
                           if(snapshot.connectionState==ConnectionState.waiting){
                             return Center(
                               child: CircularProgressIndicator(),
                             );
                           }
                           if(snapshot.hasData){
                             final docs=snapshot.data!.docs;
                             return docs.length>0?Padding(
                               padding:EdgeInsets.only(top: h*0.01),
                               child: ListView.builder(scrollDirection: Axis.vertical,itemBuilder: (context,index){
                                 final data=docs[index].data();
                                 return Padding(
                                   padding:  EdgeInsets.only(left: w*0.05,right: w*0.05,bottom: h*0.015,top: index==0?h*0.02:0),
                                   child: Material(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(10),
                                     elevation: 5,
                                     child: InkWell(
                                       borderRadius: BorderRadius.circular(10),
                                      onLongPress: ()async{
                                         try{
                                           var collection = FirebaseFirestore.instance.collection('AllShops').doc(user!.uid).collection('MyShop');
                                           var snapshots = await collection.where('ProductName', isEqualTo: data['ProductName']).get();

                                           return showDialog(h: h,index: index, snapshots: snapshots);
                                       //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: id, color: Colors.white, weight: FontWeight.normal, size:h*0.013)));
                                         }
                                         catch(e){
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color: Colors.white, weight: FontWeight.normal, size:h*0.013)));
                                         }



                                      },
                                       child: Container(
                                         width: w,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(10),
                                         ),
                                         child: Column(

                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                             Row(mainAxisAlignment: MainAxisAlignment.end,
                                               children: [
                                                 TextButton(onPressed: ()async{
                                                   try {
                                                     var collection =  FirebaseFirestore.instance.collection("AllShops").doc(user!.uid).collection('MyShop');
                                                     var snapshots = await collection.where('ProductName', isEqualTo: data['ProductName']).get();
                                                     String id='';
                                                     for (var doc in snapshots.docs) {
                                                       id=await doc.id;
                                                     }

                                                     Navigator.push(context,
                                                         MaterialPageRoute(
                                                             builder: (
                                                                 context) =>
                                                                 EditProductScreen(
                                                                   myUid: user!.uid,
                                                                     uidWithIndex: id)));
                                                   }
                                                   catch(e){
                                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color:Colors.white, weight: FontWeight.normal, size:h*0.015)));

                                                   }
                                                 }, child: styled(text: 'Edit', color:Colors.black, weight: FontWeight.normal, size:h*0.02)),
                                               ],),
                                             Image.network(data['ProductImageUrl'],
                                               fit: BoxFit.fitWidth,width: w,isAntiAlias: true,height: h*0.3,),



                                             SizedBox(height: h*0.13 ,),
                                             styled(text: "-- Name --", color: Colors.black, weight: FontWeight.bold, size: h*0.02),
                                             SizedBox(height: h*0.01,),
                                             Flexible(child: styled(text: data['ProductName'], color: Colors.black, weight: FontWeight.bold, size: h*0.015)),
                                             SizedBox(height: h*0.039,),


                                             styled(text: "-- Stock --", color: Colors.black, weight: FontWeight.bold, size: h*0.02),
                                             SizedBox(height: h*0.01,),
                                             Flexible(child: styled(text: data['ProductQuantity'], color: Colors.black, weight: FontWeight.bold, size: h*0.015)),
                                             SizedBox(height: h*0.039,),


                                             styled(text: "-- Price --", color: Colors.black, weight: FontWeight.bold, size: h*0.02),
                                             SizedBox(height: h*0.01,),
                                             Flexible(child: styled(text: data['ProductPrice'], color: Colors.black, weight: FontWeight.bold, size: h*0.015)),
                                             SizedBox(height: h*0.039,),

                                           ],

                                         ),
                                       ),
                                     ),
                                   ),
                                 );
                               },itemCount:docs.length,),
                             ):
                             Center(child: styled(text: 'No Products', color: Colors.black, weight: FontWeight.normal, size:h*0.02),);
                           }
                           return  Center(child: Container(width: 40,height: 40,child: Center(child: CircularProgressIndicator(),),),);

                         }
                       ),
                       backgroundColor: Colors.transparent,
                     ),
                   )
                  ]),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: h*0.02,bottom: h*0.01),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: TabBar(

                    indicatorSize:TabBarIndicatorSize.label ,
                    automaticIndicatorColorAdjustment: true,
                    indicatorColor: Colors.black,

                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    // unselectedLabelStyle: GoogleFonts.adamina(textStyle: TextStyle(fontSize:h*0.02,fontWeight:FontWeight.bold)),
                    tabs: [
                      // Text('Orders',style:GoogleFonts.adamina(textStyle: TextStyle(fontWeight:FontWeight.bold)) ,),
                      // Text('Shops',style:GoogleFonts.adamina(textStyle: TextStyle(fontWeight:FontWeight.bold)) ,),
                      // Text('Accounts',style:GoogleFonts.adamina(textStyle: TextStyle(fontWeight:FontWeight.bold))) ],
                      Padding(
                        padding:  EdgeInsets.only(bottom: h*0.01),
                        child: Text('Orders',style:GoogleFonts.adamina(textStyle: TextStyle(fontWeight:FontWeight.bold))),
                      ),
                      Padding(                    padding:  EdgeInsets.only(bottom: h*0.01),

                        child: Text('Shops',style:GoogleFonts.adamina(textStyle: TextStyle(fontWeight:FontWeight.bold))),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(bottom: h*0.01),
                        child: Text('Products',style:GoogleFonts.adamina(textStyle: TextStyle(fontWeight:FontWeight.bold))),
                      ),
                    ],
                    // enableFeedback: true,
                    // automaticIndicatorColorAdjustment: true,
                    onTap: (index){

                    },
                  ),
                ),
              ),


            ]
          ),
        ) ,
      ),
    );
  }
}
