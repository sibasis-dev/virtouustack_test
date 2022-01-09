import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtoustack_test/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:virtoustack_test/provider/api_provider.dart';
import 'package:virtoustack_test/screens/home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var facebookLogin = FacebookLogin();
  SharedPreferences prefs;
  bool loginCheck=true;

  authDataStore(FacebookUserProfile _profile) async{
    prefs= await SharedPreferences.getInstance();
    prefs.setBool("login", true);
    prefs.setString("name", _profile.name);
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
              Text("Sign In",style: signInTextStyle),
              Text("Sign in with your facebook account",style: signInWithFBAccTextStyle),
              const SizedBox(height: 18,),
              Consumer<ApiProvider>(
                builder: (context, value, child) {
                  if(value.loginLoader){
                    return const CircularProgressIndicator(color: fbBgColor,);
                  }else if(value.fbProfile!=null && loginCheck){
                    loginCheck=false;
                    authDataStore(value.fbProfile);
                    Future.delayed(Duration.zero,(){
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeScreen(name: value.fbProfile.name,)),
                              (Route<dynamic> route) => false);
                    });

                    return const SizedBox();
                  }else{
                    return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Provider.of<ApiProvider>(context,listen: false).fbLogin();
                      },
                      child: ColoredBox(
                        color: fbBgColor,
                        child: SizedBox(
                          width: 80.w,
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(fbLogo,width: 20,),
                              Text("     Sign in with facebook",style: signInWithFBTextStyle),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },),

            ],
          ),
        ),
      ),
    );
  }
}
