import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtoustack_test/constants.dart';
import 'package:virtoustack_test/provider/api_provider.dart';
import 'package:sizer/sizer.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({Key key, this.name}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<ItemScrollController> _imageScrollController = [];
  final List<ItemScrollController> _textScrollController = [];
  bool initialCheck=true;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0),(){
      Provider.of<ApiProvider>(context,listen: false).getListData();
      if(widget.name!=null){
        _showLoginAlertDialog();
      }
    });

  }

  clearUserData() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Row(
            children: [
              Text("Dog's Path", style: appBarTextStyle,),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: splashTextColor,
                  size: 20,
                ),
                onPressed: () {
                  Provider.of<ApiProvider>(context, listen: false).fbLogout().then((value) {
                    if (value) {
                      clearUserData();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                      Fluttertoast.showToast(
                          msg: "You have successfully logged out",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 14.0);
                    }
                  });
                },
              )
            ],
          ),
          centerTitle: true,
        ),
        backgroundColor: bgColor,
        body: Consumer<ApiProvider>(
          builder: (context, value, child) {
            if(value.getListDataLoader){
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) => const ListTileShimmer(
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.all(15),
                ),
              );
            }else if(value.listData!=null){
              if(initialCheck){
                for(int i=0;i<2;i++){
                  _imageScrollController.add(ItemScrollController());
                  _textScrollController.add(ItemScrollController());
                }
                initialCheck=false;
              }
              return ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index1) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(value.listData[index1]['title'], style: headingTextStyle,),
                                const SizedBox(height:4,),
                                Text("${value.listData[index1]['sub_paths'].length} Sub Paths" , style: subHeadingTextStyle,),
                              ],
                            ),
                            ColoredBox(
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text("   Open Path   ",style: buttonTextStyle,),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 28.h,
                        child: ScrollablePositionedList.builder(
                          itemScrollController: _imageScrollController[index1],
                          scrollDirection: Axis.horizontal,
                          itemCount: value.listData[index1]['sub_paths'].length,
                          itemBuilder: (context, index) {
                          return Image.network(value.listData[index]['sub_paths'][index]['image'], width: 100.w,fit: BoxFit.cover,);
                        },),
                      ),
                      ColoredBox(
                        color: Colors.black,
                        child: SizedBox(
                          height: 50,
                          child: ScrollablePositionedList.separated(
                            itemScrollController: _textScrollController[index1],
                            scrollDirection: Axis.horizontal,
                            itemCount: value.listData[index1]['sub_paths'].length,
                            itemBuilder: (context, index) {
                            return Center(child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: InkWell(
                                  onTap: (){
                                    scrollToIndex(index, index1);
                                  },
                                  child: Text(value.listData[index]['sub_paths'][index]['title'], style: titleTextStyle,)),
                            ));
                          },
                          separatorBuilder: (context, index) {
                            return const Icon(Icons.arrow_forward_outlined, color: Colors.white,);
                          },),
                        ),
                      ),

                    ],
                  );
              },);
            }else{
              return Center(
                  child: Text(
                    "No Data Available",
                    style: virtouStackTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ));
            }
        },)
      ),
    );
  }
  
  scrollToIndex(int index, int imageIndex){
    _imageScrollController[imageIndex].scrollTo(index: index, duration: const Duration(milliseconds: 500));
    _textScrollController[imageIndex].scrollTo(index: index, duration: const Duration(milliseconds: 500));
  }

  _showLoginAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Alert"),
          content: Text("Signed in as ${widget.name}"),
          actions: <Widget>[
            CupertinoDialogAction(
                child: const Text("ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }
}
