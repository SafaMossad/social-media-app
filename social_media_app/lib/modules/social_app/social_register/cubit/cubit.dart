import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/models/social_app/social_user_model.dart';
import 'package:socialmediaapp/modules/social_app/social_register/cubit/states.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void userRegister({
    String email,
    String password,
    String name,
    String phone,
  }) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print("created email and password");

      print(value.user.email);
      userCreate(
        uId: value.user.uid,
        phone: phone,
        name: name,
        email: email,
      );
    }).catchError((onError) {
      print("error");
      emit(SocialRegisterErrorState());
    });
  }

  void userCreate({
    String email,
    String phone,
    String name,
    String uId,
  }) {
    SocialUserModel model = SocialUserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      print("created in fire Store");
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      print("error");

      emit(SocialCreateUserErrorState());
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialRegisterChangePasswordVisibilityState());
  }
}
