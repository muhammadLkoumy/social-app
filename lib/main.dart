import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/screen/social_main_screen.dart';
import 'package:social_app/modules/login/cubit/login_cubit.dart';
import 'package:social_app/modules/login/screen/login_screen.dart';
import 'package:social_app/modules/register/cubit/register_cubit.dart';
import 'package:social_app/shared/components/toast.dart';
import 'package:social_app/shared/constants/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio.dart';

import 'bloc_observer.dart';

// this func to handle the background notifications
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  MyToast(msg: 'onBackgroundMessages', state: ToastStates.SUCCESS).showToast();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DioHelper.init();

  token = await FirebaseMessaging.instance.getToken() ?? '';

  print('======================>>>>> $token');

  // when the app is opened <<Foreground>>
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    MyToast(msg: 'onMessage', state: ToastStates.SUCCESS).showToast();
  });

  // when the app is opened on the <<Background>>
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    MyToast(msg: 'onMessageOpenedApp', state: ToastStates.SUCCESS).showToast();
  });

  // <<Background>>
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await CacheHelper.init();

  uId = CacheHelper.getData(key: 'uId') ?? '';
  print(uId);

  Widget widget;

  if (uId == '') {
    widget = LoginScreen();
  } else {
    widget = const MainScreen();
  }

  BlocOverrides.runZoned(
    () {
      runApp(
        SocialApp(
          startScreen: widget,
        ),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}

class SocialApp extends StatelessWidget {
  final Widget startScreen;

  const SocialApp({Key? key, required this.startScreen}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => SocialCubit()
            ..getUser()
            ..getPosts(),
        ),
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => RegisterCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            color: Colors.white,
            elevation: 0.0,
          ),
        ),
        home: startScreen,
      ),
    );
  }
}
