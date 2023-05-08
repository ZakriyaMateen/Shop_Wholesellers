import 'package:chachukishop/LoginScreen.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:w*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            styled(text: 'Nothing to show', color: Colors.grey, weight: FontWeight.normal, size:h*0.016),
          ],
        ),
      ),
    );
  }
}
