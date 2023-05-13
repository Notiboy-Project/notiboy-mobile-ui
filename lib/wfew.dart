import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:wallet_connect/models/session/wc_session.dart';
import 'package:wallet_connect/models/wc_peer_meta.dart';
import 'package:webviewx/webviewx.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  late WebViewXController _webViewController;
  late String walletAddress, privateKey;
  bool connected = false;

  @override
  Widget build(BuildContext context) {
    return WebViewX(
      initialContent: 'https://perawallet.github.io/pera-demo-dapp',
      initialSourceType: SourceType.url,
      dartCallBacks: {
        DartCallback(
          name: 'TestDartCallback',
          callBack: (msg) {
            print(msg.toString());
          },
        )
      },
      onWebViewCreated: (controller) {
        _webViewController = controller;

      },
      webSpecificParams: const WebSpecificParams(
        printDebugInfo: true,
        webAllowFullscreenContent: true,
        applyProxyLoadBalancing: true,
      ),
      navigationDelegate: (NavigationRequest request) {
        final url = request.content.source.toString();
        debugPrint('URL $url');
        if (url.contains('wc?uri=')) {
          final wcUri =
              Uri.parse(Uri.decodeFull(Uri.parse(url).queryParameters['uri']!));
          _qrScanHandler(wcUri.toString());
          return NavigationDecision.prevent;
        } else if (url.startsWith('wc:')) {
          _qrScanHandler(url);
          return NavigationDecision.prevent;
        } else {
          return NavigationDecision.navigate;
        }
      },
      width: 600,
      height: 600,
    );
  }

  _qrScanHandler(String value) {
    if (value.contains('bridge') && value.contains('key')) {
      final session = WCSession.from(value);
      debugPrint('session $session');
      final peerMeta = WCPeerMeta(
        name: "Example Wallet",
        url: "https://example.wallet",
        description: "Example Wallet",
        icons: [
          "https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png"
        ],
      );
      // _wcClient.connectNewSession(session: session, peerMeta: peerMeta);
    }
  }
}
