import 'package:chachukishop/AddProduct.dart';
import 'package:chachukishop/AddShopLogin.dart';
import 'package:chachukishop/AdminProfile.dart';
import 'package:chachukishop/ShowBillScreen.dart';
import 'package:chachukishop/StockDetails.dart';
import 'package:chachukishop/addShopInfo.dart';
import 'package:chachukishop/splashScreen.dart';
import 'package:chachukishop/test.dart';
import 'package:chachukishop/LoginScreen.dart';
import 'package:chachukishop/ShopScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddShop.dart';
import 'HomePage.dart';

void main()async {
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values,);
SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarContrastEnforced: false,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarDividerColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
),);
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    List<String>  ProductNames=['Infinix','Lcd'];
    List<String>  ProductPrices=['200','150'];
    List<String>  ProductImageUrls=['https://images.unsplash.com/photo-1661961111184-11317b40adb2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60','https://images.unsplash.com/photo-1661961111184-11317b40adb2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60'];
    List<String>  ProductQuantities=['2','3'];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Shop',

      home: AdminProfile()
    );
  }
}


