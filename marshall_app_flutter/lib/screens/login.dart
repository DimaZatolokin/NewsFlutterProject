import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marshallappflutter/colors.dart';
import 'package:marshallappflutter/constants.dart';
import 'package:marshallappflutter/strings.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(AppColors.COLOR_GREY_LOGIN),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 108, 20, 0),
          child: Column(
            children: <Widget>[
              buildImageLogo(),
              Expanded(
                  child: Center(
                      child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildNameHeader(),
                    buildUserNameTextField(),
                  ],
                ),
              )))
            ],
          ),
        ));
  }

  Image buildImageLogo() {
    return Image.asset(
      "${Constants.IMAGE_ASSET_PATH}img_app_logo.png",
      height: 67,
    );
  }

  Widget buildNameHeader() {
    return Text(
      Strings.USER_NAME,
      style: TextStyle(fontSize: 12, color: Color(AppColors.COLOR_PLAIN_TEXT)),
    );
  }

  Widget buildUserNameTextField() {
    return TextField(
        decoration: InputDecoration(
            fillColor: Colors.white, filled: true, border: InputBorder.none));
  }
}
