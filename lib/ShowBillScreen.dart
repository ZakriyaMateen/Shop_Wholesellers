import 'package:chachukishop/LoginScreen.dart';
import 'package:chachukishop/viewImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowBillScreen extends StatefulWidget {

  final List<String> ProductNames,ProductPrices,ProductImageUrls,ProductQuantities;
  final String total,shopName,shopEmail,Uid;
  const ShowBillScreen({Key? key, required this.ProductNames, required this.ProductPrices, required this.ProductImageUrls, required this.ProductQuantities, required this.total, required this.shopName, required this.shopEmail, required this.Uid}) : super(key: key);

  @override
  State<ShowBillScreen> createState() => _ShowBillScreenState();
}

class _ShowBillScreenState extends State<ShowBillScreen> {

  List<String> totalForEach=[];
  int x=0;
  int y=0;

  getTotalForEach(){
    for(int i=0;i<widget.ProductNames.length;++i){

      x=int.parse(widget.ProductQuantities[i]) * int.parse(widget.ProductPrices[i]);
      totalForEach.add(x.toString());
    }
    for(int i=0;i<totalForEach.length;++i){
      y+=int.parse(totalForEach[i]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalForEach();
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w*0.04,vertical: h*0.02),
        child: Center(child:
          Material(
            color: Colors.white,

            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child:Column(
                children: [
                  Flexible(
                    child: ListView.builder(itemBuilder: (context,index){
                      return Container(
                        // top: index==0?BorderSide(color: Colors.grey,width: 1):BorderSide(color: Colors.grey,width: 0.5),left: BorderSide(color: Colors.grey,width: 1),right: BorderSide(color: Colors.grey,width: 1),
                        decoration: BoxDecoration(
                            border: Border(
                              bottom:BorderSide(color: Colors.grey[400]!,width: h*0.0005)
                            ),
                          // borderRadius:index==0?BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)):index==widget.ProductNames.length-1?BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)):null
                        ),
                        child: ListTile(
                          leading: InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>viewImage(imageUrl:widget.ProductImageUrls[index])));

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey,width: 1.2),
                                borderRadius: BorderRadius.circular(200)
                              ),
                              child: CircleAvatar(
                                radius: w*0.043,
                                backgroundColor: Colors.white,
                                foregroundImage: NetworkImage(widget.ProductImageUrls[index]),
                              ),
                            ),
                          ),
                          title: styled(text: widget.ProductQuantities[index]+' x '+ widget.ProductNames[index].toUpperCase(), color:Colors.black, weight:FontWeight.bold, size:h*0.0137),

                          trailing: styled(text:totalForEach[index], color:Colors.black, weight:FontWeight.bold, size:h*0.017),
                        ),
                      );
                    },itemCount: widget.ProductNames.length,),
                  ),

                    Padding(
                      padding:  EdgeInsets.only(bottom: h*0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          styled(text: 'Total  ', color: Colors.black, weight: FontWeight.bold, size:h*0.02),
                          styled(text: y.toString(), color: Colors.black, weight: FontWeight.normal, size:h*0.02),
                        ],
                      ),
                    ),

                    SizedBox(
                      height:h*0.02
                    ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: w*0.04,vertical: h*0.015),
                    child: OutlinedButton(child: styled(text: 'Order', color:Colors.black, weight:FontWeight.bold, size:h*0.016),
                    onPressed: ()async{

                      showDialog(context: context, builder:(context){
                        return Center(
                          child: Container(
                            width: w*0.7,
                            height: h*0.2,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    styled(text: 'Confirm Order', color: Colors.black, weight: FontWeight.bold, size: h*0.02),
                                  ],
                                ),
                                SizedBox(height: h*0.04,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    TextButton(onPressed: ()async{
                                      try{

                                        QuerySnapshot<Map<String, dynamic>> snapShot=await FirebaseFirestore.instance.collection('MyOrders').get();
                                        var length=snapShot.docs.length;



                                        User? user=FirebaseAuth.instance.currentUser;
                                        await FirebaseFirestore.instance.collection('Orders').doc(widget.Uid).collection('MyOrders').doc(widget.shopEmail).set({
                                          "ProductQuantities":widget.ProductQuantities.toList(),
                                          "ShopName":widget.shopName,
                                          "email":widget.shopEmail,
                                          "Status":"Pending",
                                          "ProductNames":widget.ProductNames.toList(),
                                          "ProductPrices":widget.ProductPrices.toList(),
                                          "ProductImageUrls":widget.ProductImageUrls.toList()
                                        }).then((value)async{

                                          Navigator.pop(context);

                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: 'Ordered Successfully', color: Colors.white, weight:FontWeight.normal, size: h*0.015),duration: Duration(seconds: 4),));

                                        });


                                      }
                                      catch(e){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color:Colors.white, weight:FontWeight.normal, size: h*0.015),duration: Duration(seconds: 10),));

                                      }

                                    }, child:styled(text: 'Confirm         ', color: Colors.green, weight: FontWeight.normal, size: h*0.017),
                                    ),
                                    styled(text: '|', color: Colors.black, weight: FontWeight.normal, size: h*0.014),
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child:styled(text: '         Cancel', color: Colors.red, weight: FontWeight.normal, size: h*0.017),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });





                    },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(w,h*0.042),
                        side: BorderSide(color: Colors.black,width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                    ),
                  ),


                ],
              )
            ),
          ),),
      ),
    );
  }
}
