import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../constant.dart';

class Loader {
  static sw() {
    return navigatorKey?.currentContext!.loaderOverlay.show(widget: MyLoader());
  }

  static hd() {
    return navigatorKey?.currentContext!.loaderOverlay.hide();
  }
}

class MyLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(200),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}
