import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/modules/post/post_screen.dart';
import 'package:social_app/shared/components/toast.dart';
import 'package:social_app/shared/constants/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../modules/home/home_screen.dart';
import '../../modules/profile/profile_screen.dart';
import '../../modules/users/users_screen.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUser() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(GetUserErrorState(error.toString()));
    });
  }

  List<String> titles = [
    'Home',
    'Chats',
    'Add Post',
    'Users',
    'Profile',
  ];

  List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    PostScreen(),
    UsersScreen(),
    ProfileScreen(),
  ];

  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.Home,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.Chat,
      ),
      label: 'Chat',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.Paper_Upload,
      ),
      label: 'Post',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.User1,
      ),
      label: 'Users',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        IconBroken.User,
      ),
      label: 'Profile',
    ),
  ];

  int currentIndex = 0;

  void changeBottomNav(int index, context) {
    // if (index == 4) getUser();
    if (index == 1) getAllUsers();
    if (index == 2) {
      emit(NavigateToPostScreenState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNavState());
    }
  }

  // get image From Gallery

  File? profileImage;
  final picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PickProfileImageSuccessState());
    } else {
      MyToast(msg: 'No picked photo', state: ToastStates.ERROR);
      emit(PickProfileImageErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(PickCoverImageSuccessState());
    } else {
      MyToast(msg: 'No picked photo', state: ToastStates.ERROR);
      emit(PickCoverImageErrorState());
    }
  }

  // remove picked images

  void removePickedImages() {
    profileImage = null;
    coverImage = null;
    emit(RemovePickedImagesState());
  }

  // upload images to firebase storage and get downloadUrl

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          profileImage: imageUrl,
        );
        removePickedImages();
        //emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UploadCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          coverImage: imageUrl,
        );
        removePickedImages();
        //emit(UploadCoverImageSuccessState());
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  // update user info

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? profileImage,
    String? coverImage,
  }) {

    emit(UpdateUserLoadingState());
    userModel = UserModel(
      name: name,
      email: userModel!.email,
      phone: phone,
      uId: userModel!.uId,
      bio: bio,
      profileImage: profileImage ?? userModel!.profileImage,
      coverImage: coverImage ?? userModel!.coverImage,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(userModel!.toMap())
        .then((value) {
      emit(UpdateUserSuccessState());
    }).catchError((error) {
      emit(UpdateUserErrorState());
    });
  }

  // create post

  File? postImage;

  Future<void> getPostImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      postImage = File(pickedImage.path);
      emit(GetPostImageSuccessState());
    } else {
      emit(GetPostImageErrorState());
    }
  }

  void uploadPostImage({
    required String text,
    required String dateTime,
    String? image,
  }) {
    emit(UploadPostImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        createPost(
          text: text,
          dateTime: dateTime,
          image: imageUrl,
        );
        removePostImage();
      }).catchError((error) {
        emit(UploadPostImageErrorState());
      });
    }).catchError((error) {
      emit(UploadPostImageErrorState());
    });
  }

  PostModel? postModel;

  void createPost({
    String? text,
    required String dateTime,
    String? image,
  }) {
    postModel = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: image ?? '',
      profileImage: userModel!.profileImage,
      dateTime: dateTime,
      text: text ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel!.toMap())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  // get posts

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value) {
      for (var post in value.docs) {
        post.reference.collection('likes').get().then((value) {
          posts.add(PostModel.fromJson(post.data()));
          postsId.add(post.id);
          likes.add(value.docs.length);
          emit(GetPostsSuccessState());
        });
      }
    }).catchError((error) {
      emit(GetPostsErrorState());
    });
  }

  // likes

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc('${userModel!.uId}')
        .set({
      'like': true,
    }).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState());
    });
  }

  void unlikePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc('${userModel!.uId}')
        .delete()
        .then((value) {
      emit(UnlikePostSuccessState());
    }).catchError((error) {
      emit(UnlikePostErrorState());
    });
  }

  // comments

  CommentModel? commentModel;

  void writeComment({
    required String postId,
    required String dateTime,
    required String text,
  }) {
    commentModel = CommentModel(
      name: userModel!.name,
      uId: userModel!.uId,
      profileImage: userModel!.profileImage,
      dateTime: dateTime,
      text: text,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel!.toMap())
        .then((value) {
      emit(WriteCommentSuccessState());
    }).catchError((error) {
      emit(WriteCommentErrorState());
    });
  }

  List<CommentModel> comments = [];
  List<int> commentsNumber = [];

  void getComments({
    required String postId,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments = [];
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
      });
      emit(GetCommentsSuccessState());
    });
  }

  // get users

  late List<UserModel> users;

  void getAllUsers() {
    users = [];
    //if (users.isEmpty)
    FirebaseFirestore.instance.collection('users').get().then((value) {
      // if(value['uId'] != userModel!.uId) {
      //
      // }
      value.docs.forEach((element) {
        if (element['uId'] != userModel!.uId)
          users.add(UserModel.fromJson(element.data()));
      });

      emit(GetAllUsersSuccessState());
    }).catchError((error) {
      print('=======================>>>>>>> Error $error');
      emit(GetAllUsersErrorState());
    });
  }

  // send messages

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel messageModel = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    messages = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  // get messages

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessagesSuccessState());
    });
  }
}
