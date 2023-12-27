import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notiboy/screen/home/SplashScreen.dart';
import 'package:notiboy/screen/home/bottom_bar_screen.dart';
import 'package:notiboy/screen/home/setting/setting_screen.dart';
import 'package:notiboy/service/notifier.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'service/pushnotification.dart';

SharedPreferences? pref;

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   await PushNotificationsManager().init();
//   PushNotificationsManager().showFlutterNotification(message);
// }
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  BottomNavigationBar navigationBar =
      bottomWidgetKey.currentWidget as BottomNavigationBar;
  navigationBar.onTap!(0);
  // handle action
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          iosBundleId: 'com.notiboy',
          iosClientId:
              '181309936963-79q89apcisvbbema2g7n73ebbpvvpofv.apps.googleusercontent.com',
          apiKey: 'AIzaSyDsuqxNUHDTWy0IwC0Btj7OaftfpVe1awY',
          appId: '1:181309936963:ios:a32e1f3f77cc1ff5c64bf6',
          messagingSenderId: '181309936963',
          projectId: 'notiboy-project'));
  await PushNotificationsManager().init();

  pref = await SharedPreferences.getInstance();
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    ScreenBreakpoints(desktop: 800, tablet: 550, watch: 200),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyChangeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(fontFamily: 'sf'),
          home: SplashScreen(),
          // home: BottomBarScreen(),
          // theme: ThemeClass.lightTheme,
          builder: EasyLoading.init(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
