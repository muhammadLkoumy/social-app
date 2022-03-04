abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class GetUserSuccessState extends SocialStates {}
class GetUserLoadingState extends SocialStates {}
class GetUserErrorState extends SocialStates {
  final String error;

  GetUserErrorState(this.error);
}

class ChangeBottomNavState extends SocialStates {}

class NavigateToPostScreenState extends SocialStates {}

// pick images

class PickProfileImageSuccessState extends SocialStates {}
class PickProfileImageErrorState extends SocialStates {}

class PickCoverImageSuccessState extends SocialStates {}
class PickCoverImageErrorState extends SocialStates {}

// remove Picked

class RemovePickedImagesState extends SocialStates {}


// upload images

class UploadProfileImageSuccessState extends SocialStates {}
class UploadProfileImageErrorState extends SocialStates {}
class UploadProfileImageLoadingState extends SocialStates {}

class UploadCoverImageSuccessState extends SocialStates {}
class UploadCoverImageErrorState extends SocialStates {}
class UploadCoverImageLoadingState extends SocialStates {}

// update user

class UpdateUserSuccessState extends SocialStates {}
class UpdateUserErrorState extends SocialStates {}
class UpdateUserLoadingState extends SocialStates {}

// post

class GetPostImageSuccessState extends SocialStates {}
class GetPostImageErrorState extends SocialStates {}

class CreatePostSuccessState extends SocialStates {}
class CreatePostErrorState extends SocialStates {}

class UploadPostImageSuccessState extends SocialStates {}
class UploadPostImageLoadingState extends SocialStates {}
class UploadPostImageErrorState extends SocialStates {}

class RemovePostImageState extends SocialStates {}

class GetPostsSuccessState extends SocialStates {}
class GetPostsErrorState extends SocialStates {}

// likes

class LikePostSuccessState extends SocialStates {}
class LikePostErrorState extends SocialStates {}

class UnlikePostSuccessState extends SocialStates {}
class UnlikePostErrorState extends SocialStates {}

// comments

class WriteCommentSuccessState extends SocialStates {}
class WriteCommentErrorState extends SocialStates {}

class GetCommentsSuccessState extends SocialStates {}
class GetCommentsErrorState extends SocialStates {}

// get users

class GetAllUsersSuccessState extends SocialStates {}
class GetAllUsersErrorState extends SocialStates {}

// send messages

class SendMessageSuccessState extends SocialStates {}
class SendMessageErrorState extends SocialStates {}

class GetMessagesSuccessState extends SocialStates {}
