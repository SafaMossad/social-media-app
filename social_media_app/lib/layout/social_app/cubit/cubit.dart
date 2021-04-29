import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/layout/social_app/cubit/state.dart';
import 'package:socialmediaapp/models/social_app/social_user_model.dart';
import 'package:socialmediaapp/shared/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);
  SocialUserModel model;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
      print(value.data());

      model = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print("error => $error");
      emit(SocialGetUserErrorState());
    });
  }
}
