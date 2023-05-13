import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/screen/home/select_network_screen.dart';
import 'package:notiboy/utils/const.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(fontFamily: 'sf'),
      home: SelectNetworkScreen(),
      // theme: ThemeClass.lightTheme,
    );
  }
}
