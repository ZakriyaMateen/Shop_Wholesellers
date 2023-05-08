import 'package:flutter/material.dart';

class viewImage extends StatefulWidget {
  final String imageUrl;
  const viewImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<viewImage> createState() => _viewImageState();
}

class _viewImageState extends State<viewImage> {
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

      body:  Center(
        child: InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: Image.network(
            widget.imageUrl,
            width: w,
            height: h*0.5,
            fit: BoxFit.cover,
          ),
        ),
      ),

    );
  }
}
