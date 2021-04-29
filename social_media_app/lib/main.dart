import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/layout/social_app/social_layout.dart';
import 'package:socialmediaapp/modules/social_app/social_login/social_login_screen.dart';
import '././layout/shop_app/cubit/cubit.dart';
import '././layout/shop_app/shop_layout.dart';
import '././modules/shop_app/on_boarding/login/login_screen.dart';
import '././modules/shop_app/on_boarding/on_boarding_screen.dart';
import '././shared/components/constants.dart';
import '././shared/styles/themes.dart';

import './layout/news_app/cubit/cubit.dart';
import './shared/bloc_observer.dart';
import './shared/cubit/cubit.dart';
import './shared/cubit/states.dart';
import './shared/network/local/cache_helper.dart';
import './shared/network/remote/dio_helper.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;
  var uId = CacheHelper.getData(key: 'uId');
  print(u)
  bool isDark = false;

  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  // CacheHelper.getData(key: 'isDark');
  // bool onBoarding = CacheHelper.getData(key: 'onBoarding');

  // print("Token  : $token");

//  Widget startWidget;
/*  //print("onBoarding : $startWidget");
  if (onBoarding != null) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = ShopLoginScreen();
  } else
    widget = OnBoardingScreen();*/

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({this.isDark, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit()
            ..getBusiness()
            ..getSports()
            ..getScience(),
        ),
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: AppCubit.get(context).isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: SocialLoginScreen(),
            );
          }),
    );
  }
}
