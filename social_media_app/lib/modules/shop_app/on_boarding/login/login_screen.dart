import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../layout/shop_app/shop_layout.dart';
import '../../../../modules/shop_app/on_boarding/login/cubit/cubit.dart';
import '../../../../modules/shop_app/on_boarding/login/cubit/states.dart';
import '../../../../modules/shop_app/on_boarding/register/shop_register_screen.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/network/local/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) => {
          if (state is ShopLoginSuccessState)
            {
              if (state.loginModel.status)
                {
                  showToast(
                    text: state.loginModel.message,
                    state: ToastState.SUCCESS,
                  ),
                  CacheHelper.saveData(
                    key: "token",
                    value: state.loginModel.data.token,
                  ).then((value) {
                    token = state.loginModel.data.token;
                    navigateAndFinish(
                      context,
                      ShopLayout(),
                    );
                  }),
                }
              else
                {
                  showToast(
                      text: state.loginModel.message, state: ToastState.ERROR),
                  // print(state.loginModel.message),
                }
            }
        },
        builder: (context, state) {
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
                          "login now with browse our offers",
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
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            suffix: ShopLoginCubit.get(context).suffix,
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            suffixPressed: () {
                              ShopLoginCubit.get(context)
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
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: "Login",
                              isUpperCase: true),
                          condition: state is! ShopLoginLoadingState,
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
                                navigateTo(context, ShopRegisterScreen());
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
        } ,
      ),
    );
  }
}
