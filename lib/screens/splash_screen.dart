import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtoustack_test/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:virtoustack_test/screens/home_screen.dart';
import 'package:virtoustack_test/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SharedPreferences prefs;

  @override
  void initState() {
    autoLoginCheck();
    super.initState();
  }

  autoLoginCheck() async{
    prefs= await SharedPreferences.getInstance();
    Future.delayed(const Duration(seconds: 3),(){
      if(prefs.getBool("login")??false){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,

        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(splashDogImage,height: 40.w,width: 40.w,),
              Text("Dog's Path",style: dogsPathTextStyle),
              Text("by",style: dogsPathByTextStyle),
              Text("VirtouStack Softwares Pvt. Ltd.",style: virtouStackTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}
