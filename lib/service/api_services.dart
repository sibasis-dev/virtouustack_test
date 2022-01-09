import 'dart:async';
import 'dart:io';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:virtoustack_test/exception/api_exceptions.dart';
import 'dart:convert';

class APIService {

  Future<FacebookUserProfile> fbLogin(FacebookLogin facebookLogin) async {

      var facebookLoginResult =
      await facebookLogin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.success:
          print("LoggedIn");
          // TODO: Handle this case.
          break;
        case FacebookLoginStatus.cancel:
          print("Cancel");
          // TODO: Handle this case.
          break;
        case FacebookLoginStatus.error:
          print("error");
          // TODO: Handle this case.
          break;
      }
      final profile =await facebookLogin.getUserProfile();
      return profile;
  }

  Future<void> fbLogout(FacebookLogin facebookLogin) async{
    facebookLogin.logOut();
  }

  Future getListData() async {
    try {
      final response = await get(uri: Uri.parse("https://61c30cc09cfb8f0017a3e91f.mockapi.io/virtoustack/paths"));

      return json.decode(response.body);
      // return ResponseModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred :: $error');
      throw Exception('$error');
    }
  }

  Future<http.Response> get({@required Uri uri}) async {

    final response = await http.get(uri).timeout(const Duration(seconds: 30),
        onTimeout: () {
      throw TimeoutException('Request Timeout');
    });

    print("$uri API HTTP Status::  ${response.statusCode}, data:: ${json.decode(response.body).toString()}");
    return _response(response);
  }


  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(
            json.decode(response.body)['data']['message'].toString());
      case 404:
        throw NotFoundException(
            json.decode(response.body)['message'].toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

}
