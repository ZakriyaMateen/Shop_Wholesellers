import 'package:chachukishop/LoginScreen.dart';
import 'package:chachukishop/viewImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockDetails extends StatefulWidget {
  final String uid;
  const StockDetails({Key? key, required this.uid}) : super(key: key);

  @override
  State<StockDetails> createState() => _StockDetailsState();
}


class _StockDetailsState extends State<StockDetails> {

  List<String> quantitiesString=[];
  List<int> quantities=[];
  List<String> ProductNames=[];
  List<String> ProductImages=[];
  
  bool NoProuductFound=false;
  Future<void>  getMyProducts()async{

     try{
       QuerySnapshot<Map<String,dynamic>> snapShot=await FirebaseFirestore.instance.collection("AllShops").doc(widget.uid).collection('MyShop').get();
       final docs=await snapShot.docs;

       
         for (int i = 0; i < docs.length; ++i) {
           final data = docs[i].data();
           ProductImages.add(data['ProductImageUrl']);
           ProductNames.add(data['ProductName']);
           quantitiesString.add(data['ProductQuantity']);
         }
         for(int i=0;i<quantitiesString.length;++i){
           quantities.add(int.parse(quantitiesString[i]));
         }
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text:'$quantities', color: Colors.white, weight:FontWeight.normal, size: 13),duration: Duration(seconds: 12),));
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: '$ProductNames', color: Colors.white, weight:FontWeight.normal, size: 13),duration: Duration(seconds: 12),));
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: '$ProductImages', color: Colors.white, weight:FontWeight.normal, size: 13),duration: Duration(seconds: 12),));

     }
     catch(e){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: styled(text: e.toString(), color: Colors.white, weight:FontWeight.normal, size: 13),duration: Duration(seconds: 12),));
     }
   }
  
  bool isLoaded=false;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();

   getMyProducts().then((value) {
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
        title: styled(text: 'Stock Status', color: Colors.black, weight: FontWeight.bold, size:h*0.017),

        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: InkWell(onTap: (){
          Navigator.of(context).pop();
        },child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.grey[700],size: h*0.02,)),
      ),

      body: isLoaded==false?Center(child: Container(width:50,height:50,child: Center(child: CircularProgressIndicator(),))):NoProuductFound==true?Center(child: styled(text: 'Please add a product', color:Colors.grey[600]!, weight: FontWeight.normal, size:h*0.014)): Padding(
        padding: EdgeInsets.only(left:  w*0.03,right:  w*0.03,top: h*0.014),
        child: ListView.builder(itemBuilder: (context,index){
          return Padding(
            padding:  EdgeInsets.only(bottom: h*0.01),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              child: Container(
                height: h*0.091,
                width: w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: w*0.04),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(200),
                        border: Border.all(color: Colors.grey[600]!,width: 1)
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>viewImage(imageUrl: ProductImages[index]),));
                        },
                        child: CircleAvatar(
                          radius: h*0.01926,



                          backgroundColor: Colors.white,
                          foregroundImage: NetworkImage(
                            ProductImages[index]
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: h*0.01,),
                        SizedBox(height: h*0.01,),

                        Container(
                          margin: EdgeInsets.only(left: w*0.04),
                          width: (quantities[index]==0)?w*0.05:((quantities[index]>=20)&&(quantities[index]<50))?w*0.3:((quantities[index]>0)&&(quantities[index]<20))?w*0.15:((quantities[index]>=50)&&(quantities[index]<70))?w*0.55:w*0.7,
                          height: h*0.008,
                          decoration: BoxDecoration(
                            color: ((quantities[index]>=20)&&(quantities[index]<50))?Colors.blue:((quantities[index]>0)&&(quantities[index]<20))?Colors.red:(quantities[index]==0)?Colors.red[900]:((quantities[index]>=50)&&(quantities[index]<70))?Colors.green[500]:Colors.green[800],
                                borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                          SizedBox(height: h*0.005,),
                        Padding(
                          padding:  EdgeInsets.only(left: w*0.04),
                          child: Text(ProductNames[index], style: GoogleFonts.adamina(textStyle: TextStyle(color: Colors.grey[700],fontSize: h*0.016,fontWeight: FontWeight.normal,fontStyle: FontStyle.italic)),),
                        )
                      ],
                    ),
                    (quantities[index]==0)?SizedBox(width: w*0.3,):SizedBox(width: 0,),
                    styled(text: (quantities[index]==0)?'Empty':'', color: Colors.grey[600]!, weight:FontWeight.bold, size: h*0.015)
                  ],
                )
              ),
            ),
          );
        },itemCount: quantities.length,),
      ),
    );
  }
}
