import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:notiboy/constant.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../utils/shared_prefrences.dart';
import '../../widget/button.dart';
import 'bottom_bar_screen.dart';
import 'channel/controllers/api_controller.dart';

enum NetworkType {
  ethereum,
  algorand,
}

enum TransactionState {
  disconnected,
  connecting,
  connected,
  connectionFailed,
  transferring,
  success,
  failed,
}

class SelectNetworkScreen extends StatefulWidget {
  const SelectNetworkScreen({Key? key}) : super(key: key);

  @override
  State<SelectNetworkScreen> createState() => _SelectNetworkScreenState();
}

class _SelectNetworkScreenState extends State<SelectNetworkScreen> {
  bool mode = false;
  int count = 0;

  @override
  void initState() {
    count = pref?.getInt('count') ?? 0;
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    mode = brightness == Brightness.dark;
    print("---${mode}");
    wait();
    super.initState();
  }

  wait() async {
    await getTheme();
  }

  getTheme() async {
    count == 0 ? await pref?.setBool('mode', mode) : null;
    count == 0 ? isDark = mode : isDark = await pref?.getBool('mode') ?? false;
    await pref?.setInt('count', 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Clr.dark : Clr.blueBg,
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/notiboy_cover.png'),
              ),
            ),
            child: _mainBody(sizingInformation.deviceScreenType),
          );
        },
      ),
    );
  }

  Widget _mainBody(DeviceScreenType deviceScreenType) {
    switch (deviceScreenType) {
      case DeviceScreenType.mobile:
      default:
        return _buildMobileBody();
    }
  }

  _buildMobileBody() {
    return SafeArea(
      child: Column(
        children: [
          // Expanded(
          //   flex: 1,
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 20),
          //     child: Row(
          //       children: [
          //         Spacer(),
          //         changeMode(
          //           () {
          //             setState(() {});
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 9,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/notiboy_logo.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 20),
                    //   child: Center(
                    //     child: Text(
                    //       Str.web3Communication,
                    //       style: TextStyle(color: isDark ? Clr.white : Clr.black, fontWeight: FontWeight.bold, fontSize: 20),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 25,
                    ),
                    // GradientText(
                    //   Str.connectWallet,
                    //   style: TextStyle(
                    //     color: isDark ? Clr.white : Clr.black,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 30,
                    //     fontStyle: FontStyle.italic,
                    //   ),
                    //   gradient: LinearGradient(colors: [
                    //     Colors.blue.shade400,
                    //     Colors.blue.shade900,
                    //   ]),
                    // ),
                    Center(
                      child: Text(
                        Str.connectWallet,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Clr.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '1.',
                                    style: TextStyle(
                                      color: !isDark ? Clr.white : Clr.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: Text(
                                    Str.firstStep,
                                    style: TextStyle(
                                      color: !isDark ? Clr.white : Clr.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '2.',
                                    style: TextStyle(
                                      color: !isDark ? Clr.white : Clr.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: Text(
                                    Str.secondStep,
                                    style: TextStyle(
                                      color: !isDark ? Clr.white : Clr.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '3.',
                                    style: TextStyle(
                                      color: !isDark ? Clr.white : Clr.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: Text(
                                    Str.thirdStep,
                                    style: TextStyle(
                                      color: !isDark ? Clr.white : Clr.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '4.',
                                    style: TextStyle(
                                      color: !isDark ? Clr.white : Clr.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: Text(
                                    Str.fourthStep,
                                    style: TextStyle(
                                      color: !isDark ? Clr.white : Clr.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MyButton(
                      height: 50,
                      textColor: !isDark ? Clr.white : Clr.black,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      title: 'Scan QR Code',
                      buttonClr: !isDark ? Clr.dark : Clr.blueBg,
                      onClick: () async {
                        String? barcodeScanRes = '';
                        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', false, ScanMode.QR);
                        Map dataQrcode = json.decode(barcodeScanRes);
                        await SharedPrefManager().setString('Login', barcodeScanRes);
                        token = dataQrcode['accessKey'];
                        XUSERADDRESS = dataQrcode['address'];
                        chain = dataQrcode['chain'];
                        FirebaseMessaging.instance.getToken().then((token) {
                          ChannelApiController().storeFCM(token ?? '');
                        }).catchError((onError) {});
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomBarScreen(),
                            ));
                      },
                      width: 170,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cmnContainer(Widget widget) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Colors.blue[100],
        gradient: LinearGradient(
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
          colors: [
            Colors.blue[100]!,
            Colors.blue[200]!,
            Colors.blue[300]!,
            Colors.blue[400]!,
          ],
        ),
      ),
      child: widget,
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
