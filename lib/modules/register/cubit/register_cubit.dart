import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool showPass = true;

  void changePassVisibility() {
    showPass = !showPass;
    emit(RegisterChangePassVisibilityState());
  }

  void userRegister({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(UserRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      // Create new user
      createUser(
        username: username,
        email: email,
        uId: value.user!.uid,
        phone: phone,
      );
    }).catchError((error) {
      emit(UserRegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String username,
    required String email,
    required String uId,
    required String phone,
  }) {
    UserModel user = UserModel(
      name: username,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'Write your bio...',
      profileImage: 'https://img.freepik.com/free-photo/beauty-smiling-sport-child-boy-showing-his-biceps_155003-1808.jpg?w=740',
      coverImage: 'https://img.freepik.com/free-photo/banner-with-surprised-children-peeking-edge_155003-10104.jpg?w=740',
    );
    emit(UserCreateLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(user.toMap())
        .then((value) {
      emit(UserCreateSuccessState(uId));
    }).catchError((error) {
      emit(UserCreateErrorState(error.toString()));
    });
  }
}
