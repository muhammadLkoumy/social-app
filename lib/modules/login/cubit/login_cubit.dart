import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/login_state.dart';

import '../../../models/user_model.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool showPass = true;

  void changePassVisibility() {
    showPass = !showPass;
    emit(LoginChangePassVisibilityState());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(UserLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(UserLoginSuccessState(value.user!.uid));
      getUser();
    }).catchError((error) {
      emit(UserLoginErrorState(error.toString()));
      print(error);
    });
  }

  UserModel? userModel;

  void getUser() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(GetUserErrorState(error.toString()));
    });
  }
}
