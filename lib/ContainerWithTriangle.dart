import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
    class ContainerWithTriangle extends StatefulWidget {
      const ContainerWithTriangle({Key? key}) : super(key: key);

      @override
      State<ContainerWithTriangle> createState() => _ContainerWithTriangleState();
    }

    class _ContainerWithTriangleState extends State<ContainerWithTriangle> {
      @override
      Widget build(BuildContext context) {
        double h=MediaQuery.of(context).size.height;
        double w=MediaQuery.of(context).size.width;
        return Center(
          child: Container(
              width: w,
              height: h*0.08,
              child: ClipRect(
                child: Stack(
                  children: [


                     Transform(  //Default is left
                       transform: Matrix4.rotationX(math.pi),
                       child: Positioned(
                          left: w*0.475,
                          top: h*0.06,

                          child: CustomPaint(
                              size: Size(w*0.08, h*0.03),
                              painter: DrawTriangleShape()
                          ),
                      ),
                       ),

                    Align(
                      alignment: Alignment.topCenter,
                      child:  Container(
                          width: w*0.9,
                          height: h*0.05,
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(child: Text("your text",style: TextStyle(color: Colors.white,fontSize: h*0.015),)),
                        ),

                      ),



                  ],
                ),
              ),
          ),
        );
      }
    }
class DrawTriangleShape extends CustomPainter {

 late Paint painter;

  DrawTriangleShape() {

    painter = Paint()
      ..color = Colors.blue[800]!
      ..style = PaintingStyle.fill;

  }

  @override
  void paint(Canvas canvas, Size size) {

    var path = Path();

    path.moveTo(size.width/2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

