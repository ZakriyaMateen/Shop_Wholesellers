import 'package:chachukishop/viewImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginScreen.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {

  List<String> emailsForDocs=[];
  List<String> Total=[];
  List<String> usableName=[];
  List<String> emailsForOrders=[];
  List<String> namesForOrders=[];
  User?user;
  Future<void> getShopInfo()async{
    user=await FirebaseAuth.instance.currentUser;
    var snapshot= await FirebaseFirestore.instance.collection('ShopInfo').get();
    final docs= snapshot.docs;
    for(int i=0;i<docs.length;++i){
      final data=docs[i].data();
      namesForOrders.add(data['ShopName']);
      emailsForOrders.add(data['ShopEmail']);
    }

  }

  bool isLoaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShopInfo().then((value){
      setState((){
        isLoaded=true;
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
          leading: InkWell(onTap: (){
            Navigator.of(context).pop();
          },child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.grey[700],size: h*0.02,)),
        ),
        body:isLoaded? StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
            stream:  FirebaseFirestore.instance.collection('Orders').doc(user!.uid).collection('MyOrders').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: styled(text: snapshot.error.toString(), color: Colors.black, weight:FontWeight.bold, size:h*0.02),);
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

                  return    Padding(
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
                                data['Status']=='Pending'?  TextButton(onPressed: ()async{
                                  try{
                                    await FirebaseFirestore.instance.collection('Orders').doc(user!.uid).collection('MyOrders').doc(emailsForDocs[indexx]).update({
                                      "Status":"Done"
                                    });

                                  }
                                  catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 10),));
                                  }

                                }, child:styled(text: 'Mark as done', color: Colors.black, weight: FontWeight.bold, size:h*0.016))
                                :
                          SizedBox(height:h*0.018),
                                

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
                                      styled(text:data['Status'], color:data['Status']=='Pending'? Colors.red:Colors.green, weight: FontWeight.normal, size:h*0.02),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ),
                    ),
                  );
                },itemCount: docs.length,);
              }
              return styled(text: 'No orders yet', color: Colors.black, weight:FontWeight.bold, size:h*0.016);
            }
        ):Center(child: Container(width: 40,height: 40,
          child: CircularProgressIndicator(),),)
    );
  }
}
