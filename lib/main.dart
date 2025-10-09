import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:health_app/admin_screens/create_container.dart';
import 'package:health_app/admin_screens/edit_aricle_screen.dart';
import 'package:health_app/admin_screens/edit_video.dart';
// import 'package:health_app/admin_screens/edit_article.dart';
import 'package:health_app/colors.dart';
import 'package:health_app/firebase_options.dart';
import 'package:health_app/screens/article_screen.dart';
import 'package:health_app/screens/categories.dart';
import 'package:health_app/screens/chat/chat_screen.dart';
import 'package:health_app/screens/container_screen.dart';
import 'package:health_app/screens/login_screen.dart';
import 'package:health_app/screens/profile_screen.dart';
import 'package:health_app/screens/search_screen.dart';
import 'package:health_app/screens/show_video.dart';
import 'package:health_app/screens/signup_screen.dart';
import 'package:health_app/screens/splash_screen.dart';
import 'package:health_app/screens/user_profile.dart';
import 'package:health_app/utils/app_route.dart';
import 'admin_screens/admin_container_screen.dart';
import 'screens/category_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

bool isLogin = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('555555555    $fcmToken');

  if (user == null) {
    isLogin = false;
    // await FirebaseAuth.instance.signInAnonymously();
  } else {
    isLogin = true;
  }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  // Optional: set a background color for system bars
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // your desired color
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final List<Locale> appSupportedLocales = [
    const Locale('ar'),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: background2, // navigation bar color
      statusBarColor: primary, // status bar color
    ));

    return GetMaterialApp(
      locale: const Locale('ar'),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: appSupportedLocales,
      title: 'تطبيق الرعاية التلطيفية',
      theme: ThemeData(
          primarySwatch: primary,
          fontFamily: 'Amiri',
          textTheme: ThemeData().textTheme.copyWith(
              headlineSmall: const TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontFamily: 'ElMessiri',
                fontWeight: FontWeight.bold,
              ),
              titleLarge: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'ElMessiri',
                fontWeight: FontWeight.w600,
              ))),

      // home: ,
      initialRoute: '/',
      // routes: {
      //   '/': (ctx) => const SplashScreen(),
      //   AppRoute.categoryDetails: (ctx) => const CategoryDetails(),
      //   AppRoute.categories: (ctx) => const Categories(),
      //   AppRoute.homePage: (ctx) => const ContainerScreen(),
      //   AppRoute.adminHomePage: (ctx) => const AdminContainerScreen(),
      //   AppRoute.login: (ctx) => const Login(),
      //   AppRoute.signup: (ctx) => const SignUp(),
      //   AppRoute.profile: (ctx) => const ProfileScreen(),
      //   AppRoute.userProfile: (ctx) => const UserProfile(),
      //   AppRoute.searchPage: (ctx) => const SearchScreen(),
      //   AppRoute.chatScreen: (ctx) => const ChatScreen(),
      //   AppRoute.createContainer: (ctx) => const CreateContainer(),
      //   AppRoute.showVideo: (ctx) => const VideoApp(),
      //   AppRoute.showArticle: (ctx) => const ArticleScreen(),
      //   // AppRoute.editArticle: (ctx) =>  EditArticleScreen(),
      // },
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(
            name: AppRoute.categoryDetails,
            page: () => const CategoryDetails()),
        GetPage(name: AppRoute.categories, page: () => const Categories()),
        GetPage(name: AppRoute.homePage, page: () => const ContainerScreen()),
        GetPage(
            name: AppRoute.adminHomePage,
            page: () => const AdminContainerScreen()),
        GetPage(name: AppRoute.login, page: () => const Login()),
        GetPage(name: AppRoute.signup, page: () => const SignUp()),
        GetPage(name: AppRoute.profile, page: () => const ProfileScreen()),
        GetPage(name: AppRoute.userProfile, page: () => const UserProfile()),
        GetPage(name: AppRoute.searchPage, page: () => const SearchScreen()),
        GetPage(name: AppRoute.chatScreen, page: () => const ChatScreen()),
        GetPage(
            name: AppRoute.createContainer,
            page: () => const CreateContainer()),
        GetPage(name: AppRoute.showVideo, page: () => const VideoApp()),
        GetPage(name: AppRoute.showArticle, page: () => const ArticleScreen()),
        GetPage(name: AppRoute.editArticle, page: () => EditArticleScreen()),
        GetPage(name: AppRoute.editvideo, page: () => EditVideoWidget()),
      ],
    );
  }
}
