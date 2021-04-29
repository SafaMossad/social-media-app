// POST
// UPDATE
// DELETE

// GET

// base url : https://newsapi.org/
// method (url) : v2/top-headlines?
// queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

// https://newsapi.org/v2/everything?q=tesla&apiKey=65f7f556ec76449fa7dc7c0069f040ca

import '../../modules/shop_app/on_boarding/login/login_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';

void signOut(context) {
  CacheHelper.removeData(key: "token").then((value) => {
        if (value) {navigateAndFinish(context, ShopLoginScreen())}
      });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((element) => print(element.group(0)));
}

String token = '';
String uId = '';
