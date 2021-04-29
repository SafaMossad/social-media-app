import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../layout/shop_app/shop_layout.dart';
import '../../../../modules/shop_app/on_boarding/login/login_screen.dart';
import '../../../../modules/shop_app/on_boarding/register/cubit/cubit.dart';
import '../../../../modules/shop_app/on_boarding/register/cubit/states.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/network/local/cache_helper.dart';


class ShopRegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context)=> ShopRegisterCubit(),
    child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
      listener: (context, state) => {
        if (state is ShopRegisterSuccessState)
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
      builder: (context ,state){
        return Scaffold(
          appBar: AppBar(),
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
                        "REGISTER",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        "REGISTER now with browse our offers",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      defaultFormField(
                        controller: nameController,
                        label: "User Name",
                        prefix: Icons.person,
                        type: TextInputType.name,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return "Please Inter Your Name";
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.0,
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
                        controller: phoneController,
                        label: "User Phone",
                        prefix: Icons.phone,
                        type: TextInputType.phone,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return "Please Inter Your Phone Number";
                          }
                        },
                      ),
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
                          /*  if (formKey.currentState.validate()) {
                              ShopRegisterCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }*/
                          },
                          suffix: ShopRegisterCubit.get(context).suffix,
                          isPassword: ShopRegisterCubit.get(context).isPassword,
                          suffixPressed: () {
                            ShopRegisterCubit.get(context).changePasswordVisibility();
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
                                ShopRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                    phone: phoneController.text,
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            text: "REGISTER",
                            isUpperCase: true),
                        condition: state is! ShopRegisterLoadingState,
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(" have an Account?"),
                          defaultTextButton(
                            function: () {
                              navigateTo(context, ShopLoginScreen());
                            },
                            text: "LOGIN",
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
      },
    ) ,
    );
  }
}
