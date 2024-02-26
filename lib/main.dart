import 'dart:async';
import 'dart:io';
import 'utils/logger_x.dart';
import 'viewmodels/demo_anti_jailbreak_vm.dart';
import 'viewmodels/demo_preferences_vm+users.dart';
import 'viewmodels/demo_preferences_vm.dart';
import 'viewmodels/demo_reachability_vm.dart';
import 'viewmodels/demo_session_vm.dart';
import 'views/demo_screen/demo_screen.dart';
import 'widgets/all_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DemoAntiJailbreakVM.check();
  DemoReachabilityVM.startListening();

  final freshInstall = await DemoPreferencesVM.getFreshInstall();
  if (freshInstall == true) {
    await DemoPreferencesVM.setFreshInstall(false);
    await DemoUserPreferencesVM.resetAll();
  }

  await DemoSessionVM.load();

  Widget firstScreen;

  /*
  if (firstInstall == true) {
    firstScreen = DemoOnboardingScreen();
  } else {
    if (DemoSessionVM.token.isNotEmpty) {
      if (biometricEnabled == true) {
        firstScreen = DemoLoginScreen();
      } else {
        firstScreen = DemoBottomNavBarScreen();
      }
    } else {
      firstScreen = DemoLoginScreen();
    }
  } */

  firstScreen = DemoScreen();
//  firstScreen = DemoBottomNavBarScreen();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    runApp(
      ContainerX(
        backgroundColor: ColorX.white,
        child: Center(
          child: Container(
            width: kIsWeb ? 400.0 : double.infinity,
            child: MyApp(firstScreen),
          ),
        ),
      ),
    );
  });
/*
  if (DemoSessionVM.token.isNotEmpty) {
    DemoSessionVM.checkPinAndBiometric();
  } */
}

class MyApp extends StatelessWidget {
  final Widget firstScreen;
  MyApp(this.firstScreen);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale, //for setting localization strings
      fallbackLocale: Locale('en', 'US'),
      scrollBehavior: AppScrollBehavior(),
      title: 'BisnisX',
      home: firstScreen,
      theme: ThemeData(
          visualDensity: VisualDensity.standard,
          primarySwatch: Colors.grey,
          fontFamily: 'Roboto',
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          })),
    );
  }
}

void forceQuit() {
  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else if (Platform.isIOS) {
    exit(0);
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

processLink(String? link) async {
  // parse link and decide what to do:
  // - use setState
  // - or use Navigator.pushReplacement
  // - or whatever mechanism if you have in your app for routing to a page
  if (link != null && link.isNotEmpty) {
    LoggerX.log('Universal link clicked: $link');
    final path = Uri.parse(link).pathSegments;
    if (path.length >= 2) {
      final code = path[1];
    }
  }
}
