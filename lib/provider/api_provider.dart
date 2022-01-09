import 'package:flutter/cupertino.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:virtoustack_test/service/api_services.dart';

class ApiProvider extends ChangeNotifier{
  /// initialization

  APIService _apiService;
  String _apiError = "";
  List _listData;
  FacebookUserProfile _fbProfile;
  final FacebookLogin _facebookLogin = FacebookLogin();


  /// initializing loader status
  bool _getListDataLoader = false;
  bool _loginLoader = false;


  ///constructor
  ApiProvider() {
    _apiService = APIService();
  }


  ///getters

  bool get getListDataLoader => _getListDataLoader;

  bool get loginLoader => _loginLoader;

  List get listData => _listData;

  FacebookUserProfile get fbProfile => _fbProfile;

  String get error => _apiError;

  ///setters
  set error(String val) {
    _apiError = val;
    notifyListeners();
  }

  void _setError(err) {
    print('error of type (${err.runtimeType}) in Api provider $err');
    try {
        error = err.message.toString();
    } catch (e) {
      error = "Something Went Wrong";
    }
  }


  /// methods

  Future<bool> getListData() async {
    error = '';
    _getListDataLoader=true;
    try {
      _listData = await _apiService.getListData();
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _getListDataLoader=false;
      notifyListeners();
    }
    return true;
  }

  Future<bool> fbLogin() async {
    error = '';
    _loginLoader=true;
    try {
      _fbProfile = await _apiService.fbLogin(_facebookLogin);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _loginLoader=false;
      notifyListeners();
    }
    return true;
  }

  Future<bool> fbLogout() async {
    error = '';
    try {
      _fbProfile=null;
       _apiService.fbLogout(_facebookLogin);
    } catch (err) {
      _setError(err);
      return false;
    }
    return true;
  }




}