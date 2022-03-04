abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterChangePassVisibilityState extends RegisterStates {}

class UserRegisterSuccessState extends RegisterStates {}

class UserRegisterLoadingState extends RegisterStates {}

class UserRegisterErrorState extends RegisterStates {
  final String error;

  UserRegisterErrorState(this.error);
}

class UserCreateSuccessState extends RegisterStates {
  final String uId;

  UserCreateSuccessState(this.uId);
}

class UserCreateLoadingState extends RegisterStates {}

class UserCreateErrorState extends RegisterStates {
  final String error;

  UserCreateErrorState(this.error);
}
