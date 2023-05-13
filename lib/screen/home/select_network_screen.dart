import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_myalgo_connect/myalgo_connect.dart';
// import 'package:flutter_myalgo_connect/myalgo_connect_web.dart';
import 'package:notiboy/screen/home/connect_wallet_screen.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/text_style.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/button.dart';
import 'package:responsive_builder/responsive_builder.dart';

// final algorand = Algorand(
//   algodClient: AlgodClient(apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL),
//   indexerClient: IndexerClient(apiUrl: AlgoExplorer.TESTNET_INDEXER_API_URL),
// );

class SelectNetworkScreen extends StatefulWidget {
  const SelectNetworkScreen({Key? key}) : super(key: key);

  @override
  State<SelectNetworkScreen> createState() => _SelectNetworkScreenState();
}

class _SelectNetworkScreenState extends State<SelectNetworkScreen> {
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
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 50),
                    child: Center(
                      child: Text(
                        Str.web3Communication,
                        style: TextStyle(
                          color: isDark ? Clr.white : Clr.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    Str.selectNetwork,
                    style: TextStyle(
                      color: isDark ? Clr.white : Clr.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? Clr.blackBg : Clr.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: networkCnt(
                            title: "Algorand",
                            image: "assets/algorand.png",
                            color: isDark ? Clr.black : Clr.blueBg,
                            onTap: () async {
                              AlgodClient algodClient = AlgodClient(
                                  apiUrl: PureStake.TESTNET_ALGOD_API_URL,
                                  tokenKey: PureStake.API_TOKEN_HEADER,
                                  debug: true
                              );
                              final indexerClient = IndexerClient(
                                apiUrl: PureStake.TESTNET_INDEXER_API_URL,
                                tokenKey: PureStake.API_TOKEN_HEADER,
                              );
                              final algorand = Algorand(
                                algodClient: algodClient,
                                indexerClient: indexerClient,
                              );


                              print(await algorand.status());
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: networkCnt(
                            title: "Ethereum",
                            image: "assets/ethereum.png",
                            color: isDark ? Clr.black : Clr.blueBg,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ConnectWalletScreen();
                                },
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildDesktopBody() {
    return SingleChildScrollView(
      child: Container(
        color: isDark ? Clr.dark : Clr.blueBgWeb,
        height: MediaQuery
            .of(context)
            .size
            .height,
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
                    changeMode(
                          () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Center(
                  child: Image.asset(
                    "assets/notiboy.png",
                    width: 200,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 50),
                  child: Center(
                    child: Text(
                      Str.web3Communication,
                      style: TextStyle(
                        color: isDark ? Clr.white : Clr.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: EdgeInsetsDirectional.all(30),
                    width: 800,
                    alignment: Alignment.center,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.5,
                    decoration: BoxDecoration(
                      color: isDark ? Clr.blackBg : Clr.blueBgWeb,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            Str.selectNetwork,
                            style: TextStyle(
                              color: isDark ? Clr.white : Clr.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              networkCnt(
                                title: "Algorand",
                                image: "assets/algorand.png",
                                color: isDark ? Clr.black : Clr.white,
                                onTap: () async {
                                  AlgodClient algodClient = AlgodClient(
                                      apiUrl: "https://mainnet-api.algonode.cloud",
                                      debug: true
                                  );
                                  final indexerClient = IndexerClient(
                                      apiUrl: "https://mainnet-idx.algonode.cloud",
                                      debug: true
                                  );
                                  // "https://testnet-idx.algonode.cloud",
                                  // "https://testnet-api.algonode.cloud"
                                  // final algorand = Algorand(
                                  //   algodClient: algodClient,
                                  //   indexerClient: indexerClient,
                                  // );
                                  // Account account = await algorand
                                  //     .createAccount();
                                  // Create a connector
                                  // final connector = WalletConnect(
                                  //   bridge: 'https://bridge.walletconnect.org',
                                  //   clientMeta: PeerMeta(
                                  //     name: 'WalletConnect',
                                  //     description: 'WalletConnect Developer App',
                                  //     url: 'https://walletconnect.org',
                                  //     icons: [
                                  //       'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
                                  //     ],
                                  //   ),
                                  // );
                                  // connector.on('connect', (session) {
                                  //   print('dqqwd' + session.toString());
                                  // });
                                  // connector.on('session_update', (payload) =>
                                  //     print(payload));
                                  // connector.on('disconnect', (session) =>
                                  //     print(session));
                                  //
                                  // if (!connector.connected) {
                                  //   final session = await connector
                                  //       .createSession(
                                  //     chainId: 4160,
                                  //     onDisplayUri: (uri) => print(uri),
                                  //   );
                                  // }
                                },
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              networkCnt(
                                title: "Ethereum",
                                image: "assets/ethereum.png",
                                color: isDark ? Clr.black : Clr.white,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ConnectWalletScreen();
                                    },
                                  ));
                                },
                              ),
                            ],
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
      ),
    );
  }
}
