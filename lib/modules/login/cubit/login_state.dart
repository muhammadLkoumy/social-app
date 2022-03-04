abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginChangePassVisibilityState extends LoginStates {}

class UserLoginSuccessState extends LoginStates {
  final String uId;

  UserLoginSuccessState(this.uId);
}
class UserLoginLoadingState extends LoginStates {}
class UserLoginErrorState extends LoginStates {
  final String error;

  UserLoginErrorState(this.error);
}

class GetUserSuccessState extends LoginStates {}
class GetUserErrorState extends LoginStates {
  final String error;

  GetUserErrorState(this.error);
}
class GetUserLoadingState extends LoginStates {}


