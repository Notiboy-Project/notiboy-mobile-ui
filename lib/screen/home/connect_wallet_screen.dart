import 'package:flutter/material.dart';
import 'package:flutter_myalgo_connect/myalgo_connect.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:notiboy/screen/home/bottom_bar_screen.dart';
import 'package:notiboy/screen/web/web_default_screen.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:wasm_interop/wasm_interop.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:js' as js;

import '../../wfew.dart';

class ConnectWalletScreen extends StatefulWidget {
  const ConnectWalletScreen({Key? key}) : super(key: key);

  @override
  State<ConnectWalletScreen> createState() => _ConnectWalletScreenState();
}

class _ConnectWalletScreenState extends State<ConnectWalletScreen> {
  late String walletAddress, privateKey;
  bool connected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Clr.dark : Clr.blueBg,
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return _mainBody(sizingInformation.deviceScreenType);
        },
      ),
    );
  }

  Widget _mainBody(DeviceScreenType deviceScreenType) {
    switch (deviceScreenType) {
      case DeviceScreenType.desktop:
        return _buildDesktopBody();
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
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Image.asset("assets/nb.png"),
                  Spacer(),
                  changeMode(
                    () {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 30),
                      child: Text(
                        Str.connectWallet,
                        style: TextStyle(
                          color: isDark ? Clr.white : Clr.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    peraConnection(),
                    walletCnt(
                      title: "Defly Wallet",
                      image: "assets/defly.png",
                      color1: 0xffF6851C,
                      color2: 0xffF6B71B,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return BottomBarScreen();
                          },
                        ));
                      },
                    ),
                    walletConnection(),
                    SizedBox(
                      height: 250,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "By connecting your wallet, you agree to ",
                          style: TextStyle(
                              color: isDark ? Clr.white : Clr.black,
                              fontSize: 17),
                          children: [
                            TextSpan(
                              text: Str.termsCnd,
                              style: TextStyle(
                                color: Clr.blue,
                              ),
                            ),
                            TextSpan(
                              text: " and ",
                              style: TextStyle(
                                  color: isDark ? Clr.white : Clr.black,
                                  fontSize: 17),
                            ),
                            TextSpan(
                              text: Str.privacy,
                              style: TextStyle(color: Clr.blue, fontSize: 17),
                            ),
                          ],
                        ),
                      ),
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

  _buildDesktopBody() {
    return Container(
      color: isDark ? Clr.dark : Clr.blueBgWeb,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 30, left: 20, right: 20),
        decoration: BoxDecoration(
          color: isDark ? Clr.black : Clr.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10, top: 10),
                    child: changeMode(() {
                      setState(() {});
                    }),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: EdgeInsetsDirectional.all(20),
                  width: 500,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: isDark ? Clr.blackBg : Clr.blueBgWeb,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset("assets/algorand.png"),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          Str.connectWallet,
                          style: TextStyle(
                            color: isDark ? Clr.white : Clr.black,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          child: peraConnection(
                            width: 300,
                          ),
                        ),
                        walletCnt(
                          title: "Defly Wallet",
                          width: 300,
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          image: "assets/defly.png",
                          color1: 0xffF6851C,
                          color2: 0xffF6B71B,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return WebDefaultScreen();
                              },
                            ));
                          },
                        ),
                        Container(
                          child: walletConnection(width: 300),
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "By connecting your wallet, you agree to ",
                              style: TextStyle(
                                  color: isDark ? Clr.white : Clr.black,
                                  fontSize: 15),
                              children: [
                                TextSpan(
                                  text: Str.termsCnd,
                                  style: TextStyle(
                                    color: Clr.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(
                                      color: isDark ? Clr.white : Clr.black,
                                      fontSize: 15),
                                ),
                                TextSpan(
                                  text: Str.privacy,
                                  style:
                                      TextStyle(color: Clr.blue, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget walletConnection({double? width}) {
    return walletCnt(
      title: "Wallet Connect",
      image: "assets/connect.png",
      color1: 0xffFF5DA0,
      width: width,
      color2: 0xffFF5DF9,
      onTap: () async {
        final infuraWc = WalletConnectProvider.fromRpc(
          {416001: 'https://web.perawallet.app/connect&algorand=true'},
          bridge: 'https://bridge.walletconnect.org',
          chainId: 416001,
        );
      },
    );
  }

  Widget peraConnection({double? width}) {
    return walletCnt(
      title: "Pera Wallet",
      image: "assets/pera.png",
      width: width,
      color1: 0xff0B8BE6,
      color2: 0xff0B70E6,
      onTap: () async {
        // js.context.callMethod('App');

        Navigator.push(context, MaterialPageRoute(builder: (context) => Demo(),));
        // const peraWallet = PeraWalletConnect();
        // final accounts = await MyAlgoConnect.connect();
        //
        // final infuraWc = WalletConnectProvider.fromInfura(
        //   'https://trustwallet.com',
        //   bridge: 'perawallet-wc://wc?uri=wc:5a2ca436-ae36-44e5-8191-3aeba214643b@1?bridge=https%3A%2F%2Fmainnet-api.algonode.cloud&key=4c1b314a40c29df7f66883df32ce12e2b78995fbed07ae8e930804920e599265',
        //   network: 'algorand',
        //   qrCode:true,
        // );
        // infuraWc.connect();

        // WasmLoader loader = WasmLoader(path: 'wasm/release.wasm');
        // final isLoaded = await loader.initialized();
        // print(isLoaded);
      },
    );
  }
}

class WasmLoader {
  WasmLoader({required this.path});

  late Instance? _wasmInstance;
  final String path;

  Future<bool> initialized() async {
    try {
      final bytes = await rootBundle.load(path);
      _wasmInstance = await Instance.fromBufferAsync(bytes.buffer);
      return isLoaded;
    } catch (exc) {
      // ignore: avoid_print
      print('Error on wasm init ${exc.toString()}');
    }
    return false;
  }

  bool get isLoaded => _wasmInstance != null;

  Object callfunction(String name, int input) {
    final func = _wasmInstance?.functions[name];
    return func?.call(input);
  }
}
