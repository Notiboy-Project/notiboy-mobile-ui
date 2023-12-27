import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notiboy/constant.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/widget/toast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scan/scan.dart';
import '../../service/notifier.dart';
import '../../utils/shared_prefrences.dart';
import '../../widget/button.dart';
import 'bottom_bar_screen.dart';
import 'channel/controllers/api_controller.dart';

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
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
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
    if (mounted) setState(() {});
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
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
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
                      SizedBox(
                        height: 25,
                      ),
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
                          _showPicker(context);
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
          ),
        ],
      ),
    );
  }

  pickQrForGallray() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((file) async {
      if ((file?.path ?? '').isNotEmpty) {
        String? result = await Scan.parse(file?.path ?? '');
        print(result);
        if (result?.isNotEmpty ?? false) {
          storeDataAndNavigate(result);
        }
      }
    });
  }

  pickQrForCamera() async {
    String? barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', false, ScanMode.QR);
    if (barcodeScanRes.isNotEmpty) storeDataAndNavigate(barcodeScanRes);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, _setState) {
            return SafeArea(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Gallery'),
                        onTap: () {
                          Navigator.of(context).pop();
                          pickQrForGallray();
                        }),
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Camera'),
                      onTap: () {
                        Navigator.of(context).pop();
                        pickQrForCamera();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  storeDataAndNavigate(barcodeScanRes) async {
    List<Map> list = [];
    Map dataQrcode = json.decode(barcodeScanRes);
    String? loginOldData = await SharedPrefManager().getString('Login');
    List<dynamic> oldata = json.decode(loginOldData ?? '[{}]');
    List checkAlreadyExist = oldata
        .where((element) => element['address'] == dataQrcode['address'])
        .toList();
    if (checkAlreadyExist.isEmpty) {
      oldata = oldata.where((element) => element['currentlogin'] == 0).toList();
      if (oldata.isNotEmpty) {
        oldata.first['currentlogin'] = 1;
        list.add(oldata.first);
      }
      dataQrcode['currentlogin'] = 0;
      list.add(dataQrcode);

      await SharedPrefManager().setString('Login', jsonEncode(list));
      Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
              listen: false)
          .settoken = dataQrcode['accessKey'];
      Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
              listen: false)
          .setXUSERADDRESS = dataQrcode['address'];
      Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
              listen: false)
          .setchain = dataQrcode['chain'];

      FirebaseMessaging.instance.getToken().then((token) {
        ChannelApiController().storeFCM(token ?? '');
      }).catchError((onError) {});
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBarScreen(),
          ));
    } else {
      MyToast()
          .errorToast(toast: 'You have already logged In with same network.');
    }
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
