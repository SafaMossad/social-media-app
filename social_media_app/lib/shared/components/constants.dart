// POST
// UPDATE
// DELETE

// GET

// base url : https://newsapi.org/
// method (url) : v2/top-headlines?
// queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

// https://newsapi.org/v2/everything?q=tesla&apiKey=65f7f556ec76449fa7dc7c0069f040ca

import 'package:socialmediaapp/layout/social_app/cubit/cubit.dart';
import 'package:socialmediaapp/modules/social_app/social_login/social_login_screen.dart';

import '../../modules/shop_app/login/shop_login_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';

void signOut(context)
{
  CacheHelper.removeData(
    key: 'uId',
  ).then((value)
  {
    if (value)
    {
      //SocialCubit
      navigateAndFinish(
        context,
        SocialLoginScreen(),
      );
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token = '';

String uId = '';