import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../models/models_shop_app/login_model.dart';
import '../../../../../modules/shop_app/on_boarding/login/cubit/states.dart';
import '../../../../../modules/shop_app/on_boarding/register/cubit/states.dart';
import '../../../../../shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel loginModel;

  void userRegister({
    String email,
    String password,
    String name,
    String phone,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: "register",
      data: {
        "email": email,
        "name": name,
        "phone": phone,
        "password": password,
      },
    )
        .then(
      (value) => {
        loginModel = ShopLoginModel.fromJson(value.data),
        emit(
          ShopRegisterSuccessState(loginModel),
        ),
      },
    )
        .catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopRegisterChangePasswordVisibilityState());
  }
}
