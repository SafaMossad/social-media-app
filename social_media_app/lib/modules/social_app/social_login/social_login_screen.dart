import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/layout/social_app/social_layout.dart';
import 'package:socialmediaapp/modules/social_app/social_login/cubit/cubit.dart';
import 'package:socialmediaapp/modules/social_app/social_login/cubit/states.dart';
import 'package:socialmediaapp/modules/social_app/social_register/social_register_screen.dart';
import 'package:socialmediaapp/shared/components/components.dart';
import 'package:socialmediaapp/shared/network/local/cache_helper.dart';

class SocialLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
          listener: (context, state) {
        if (state is SocialLoginErrorState) {
          showToast(text: state.error, state: ToastState.ERROR);
        }

        if (state is SocialLoginSuccessState) {
          CacheHelper.saveData(
            key: "uId",
            value: state.uId,
          ).then((value) {
            navigateAndFinish(
              context,
              SocialLayout(),
            );
          });
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("login"),
          ),
          body: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        "login now to communicate with you Friends",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Please Inter Your Email";
                            }
                          },
                          label: "Email Address",
                          prefix: Icons.email_outlined),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Password is to Short";
                            }
                          },
                          onSubmit: (String value) {
                            if (formKey.currentState.validate()) {
                              /*  SocialLoginCubit.get(context).userLogin(
                              email: emailController.text,
                              password: passwordController.text);*/
                            }
                          },
                          suffix: SocialLoginCubit.get(context).suffix,
                          isPassword: SocialLoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            SocialLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          label: "Password",
                          prefix: Icons.lock_outline),
                      SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            text: "Login",
                            isUpperCase: true),
                        condition: state is! SocialLoginLoadingState,
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an Account?"),
                          defaultTextButton(
                            function: () {
                              navigateTo(context, SocialRegisterScreen());
                            },
                            text: "Register",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
