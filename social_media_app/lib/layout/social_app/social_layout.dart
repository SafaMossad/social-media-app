import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/layout/social_app/cubit/cubit.dart';
import 'package:socialmediaapp/layout/social_app/cubit/state.dart';
import 'package:socialmediaapp/shared/components/components.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text("News Feed"),
                centerTitle: true,
              ),
              body: ConditionalBuilder(
                condition: SocialCubit.get(context).model != null,
                builder: (context) {
                  var model = SocialCubit.get(context).model;
                  return Column(
                    children: [
                      if (!FirebaseAuth.instance.currentUser.emailVerified)
                        Container(
                          color: Colors.amber.withOpacity(0.6),
                          height: 50.0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Icon(Icons.info),
                                Expanded(
                                    child: Text("Please Verify your Email")),
                                SizedBox(
                                  width: 20.0,
                                ),
                                defaultTextButton(
                                  function: () {
                                    FirebaseAuth.instance.currentUser
                                        .sendEmailVerification()
                                        .then((value) {
                                      showToast(
                                          text: "check Your Email",
                                          state: ToastState.SUCCESS);
                                    }).catchError((onError) {});
                                  },
                                  text: "Send",
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  );
                },
                fallback: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
              ));
        });
  }
}
