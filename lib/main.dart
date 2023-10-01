import 'package:cliffordproperty/Screens/SplashScreen.dart';
import 'package:cliffordproperty/cache/cache_controller.dart';
import 'package:cliffordproperty/firebase/fb_notifications.dart';
import 'package:cliffordproperty/firebase_options.dart';
import 'package:cliffordproperty/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('1');
  /// Cache
  await CacheController().initCache;
  print('2');
  /// Firebase
  // await Firebase.initializeApp();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  //
  //   // Set the background messaging handler early on, as a named top-level function
  //

  print('3');

   await FbNotifications.initNotifications();

  print('4');
  // var fcm = await FirebaseMessaging.instance.getToken();
  // print(fcm);

  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    //String? token =
    await FirebaseMessaging.instance.getAPNSToken();
    await FirebaseMessaging.instance.getToken();
  print('5');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SystemUiOverlayStyle _style =
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(_style);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const MyMaterialApp(),
        );
      },
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('en')],
      locale: const Locale('en'),
      title: 'CliffordProperty',
      theme: ThemeData(
        fontFamily: 'Podkova',
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xffFF914D),
              secondary: const Color(0xffF0D2AE),
              surface: const Color(0xff747474),
              onSecondary: const Color(0xffCA0F0F),
              onSecondaryContainer: const Color(0xffD9D9D9),
              onPrimary: const Color(0xff3387DB),
              onBackground: const Color(0xffF4F4F4),
              primaryContainer: const Color(0xffE9E8E8),
            ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontSize: 12.sp,
            color: Colors.black,
          ),
          displaySmall: TextStyle(
            color: const Color(0xff747474),
            fontSize: 12.sp,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.sp,
          ),
        ),
      ),
      home: // const SplashScreen(),
          const SplashScreen(),
    );
  }
}
