import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/layout/social_app/social_layout.dart';
import 'package:socialmediaapp/modules/social_app/social_login/social_login_screen.dart';
import 'package:socialmediaapp/modules/social_app/social_register/cubit/cubit.dart';
import 'package:socialmediaapp/modules/social_app/social_register/cubit/states.dart';
import 'package:socialmediaapp/shared/components/components.dart';

class SocialRegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) => {
          if (state is SocialCreateUserSuccessState)
            {
              navigateTo(context, SocialLayout()),
            }
        },
        builder: (context, state) {
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
                          "REGISTER now to communicate with you Friends",
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
                              SocialRegisterCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }*/
                            },
                            suffix: SocialRegisterCubit.get(context).suffix,
                            isPassword:
                                SocialRegisterCubit.get(context).isPassword,
                            suffixPressed: () {
                              SocialRegisterCubit.get(context)
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
                                  SocialRegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: "REGISTER",
                              isUpperCase: true),
                          condition: state is! SocialRegisterLoadingState,
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
                                navigateTo(context, SocialLoginScreen());
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
      ),
    );
  }
}
