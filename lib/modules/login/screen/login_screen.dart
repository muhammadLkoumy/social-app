import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/screen/social_main_screen.dart';
import 'package:social_app/modules/login/cubit/login_cubit.dart';
import 'package:social_app/modules/register/screen/register_screen.dart';
import 'package:social_app/shared/components/navigators.dart';
import 'package:social_app/shared/components/toast.dart';
import 'package:social_app/shared/constants/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

import '../../../shared/components/main_components.dart';
import '../cubit/login_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is UserLoginSuccessState) {
          uId = state.uId;
          CacheHelper.setData(key: 'uId', value: state.uId).then((value) {
            MyNavigators.navigateAndFinish(context, const MainScreen());
          });
        }
        if (state is UserLoginErrorState) {
          MyToast(
                  msg: state.error.replaceRange(0, 31, ''),
                  state: ToastStates.ERROR)
              .showToast();
        }
      },
      builder: (context, state) {
        var cubit = LoginCubit.get(context);
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'login'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _buildInputFields(cubit),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildLoginButton(state, cubit),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildBottomRow(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputFields(LoginCubit cubit) {
    return Column(
      children: [
        myTextField(
          labelText: 'Email',
          prefix: Icons.email,
          controller: emailController,
          type: TextInputType.emailAddress,
          validateTitle: 'Email',
        ),
        const SizedBox(
          height: 15,
        ),
        myTextField(
          labelText: 'Password',
          prefix: Icons.lock,
          controller: passwordController,
          type: TextInputType.visiblePassword,
          validateTitle: 'Password',
          isPassword: true,
          changeVisibility: () {
            cubit.changePassVisibility();
          },
          showPass: cubit.showPass,
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginStates state, LoginCubit cubit) {
    return Container(
      height: 45,
      width: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        child: state is UserLoginLoadingState
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(
                'login'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            cubit.userLogin(
              email: emailController.text,
              password: passwordController.text,
            );
          }
        },
      ),
    );
  }

  Widget _buildBottomRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have account?",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          child: Text(
            'register'.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
