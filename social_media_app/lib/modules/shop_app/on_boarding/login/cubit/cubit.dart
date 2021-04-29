import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../models/models_shop_app/login_model.dart';
import '../../../../../modules/shop_app/on_boarding/login/cubit/states.dart';
import '../../../../../shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  ShopLoginModel loginModel;

  void userLogin({String email, String password}) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
        url: "login", data: {"email": "$email", "password": "$password"})
        .then((value) =>
    {
      loginModel = ShopLoginModel.fromJson(value.data),
      /*  print(loginModel.data.image),
              print(loginModel.data.phone),
              print(loginModel.status),*/
      emit(ShopLoginSuccessState(loginModel)),
    })
        .catchError((error) {
      print("login Error is:${error.toString()}");
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }
}
