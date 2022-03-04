import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/screen/social_main_screen.dart';
import '../../../shared/components/main_components.dart';
import '../../../shared/components/navigators.dart';
import '../../../shared/components/toast.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is UserCreateSuccessState) {
          uId = state.uId;
          CacheHelper.setData(key: 'uId', value: state.uId).then((value) {
            MyNavigators.navigateAndFinish(context, const MainScreen());
          });
        }
        if (state is UserRegisterErrorState) {
          if (state.error.contains('[firebase_auth/email-already-in-use]')) {
            MyToast(
                    msg: state.error.replaceRange(0, 37, ''),
                    state: ToastStates.ERROR)
                .showToast();
          } else if (state.error.contains('[firebase_auth/weak-password]')) {
            MyToast(
                    msg: state.error.replaceRange(0, 30, ''),
                    state: ToastStates.ERROR)
                .showToast();
          } else {
            MyToast(
                    msg: state.error.replaceRange(0, 30, ''),
                    state: ToastStates.ERROR)
                .showToast();
          }
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.black,
            ),
          ),
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
                        'register'.toUpperCase(),
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
                      _buildRegisterButton(state, cubit),
                      const SizedBox(
                        height: 15,
                      ),
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

  Widget _buildInputFields(RegisterCubit cubit) {
    return Column(
      children: [
        myTextField(
          labelText: 'Username',
          prefix: Icons.person,
          controller: usernameController,
          type: TextInputType.text,
          validateTitle: 'Username',
        ),
        const SizedBox(
          height: 15,
        ),
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
          labelText: 'Phone',
          prefix: Icons.phone_android_outlined,
          controller: phoneController,
          type: TextInputType.phone,
          validateTitle: 'Phone',
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

  Widget _buildRegisterButton(RegisterStates state, RegisterCubit cubit) {
    return Container(
      height: 45,
      width: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        child: state is UserRegisterLoadingState
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(
                'register'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            cubit.userRegister(
              email: emailController.text,
              password: passwordController.text,
              username: usernameController.text,
              phone: phoneController.text,
            );
          }
        },
      ),
    );
  }
}
