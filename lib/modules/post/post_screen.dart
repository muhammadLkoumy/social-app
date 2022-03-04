import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/layout/screen/social_main_screen.dart';
import 'package:social_app/shared/components/main_components.dart';
import 'package:social_app/shared/components/navigators.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../../models/user_model.dart';

class PostScreen extends StatelessWidget {
  PostScreen({Key? key}) : super(key: key);

  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is CreatePostSuccessState) {
          MyNavigators.navigateTo(context, MainScreen());
        }
      },
      builder: (context, state) {
        // final height = MediaQuery.of(context).size.height;
        final now = DateTime.now();

        return Scaffold(
          appBar: myAppBar(title: 'Add Post', context: context, actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: TextButton(
                onPressed: () {
                  if (SocialCubit.get(context).postImage != null) {
                    SocialCubit.get(context).uploadPostImage(
                      text: postController.text,
                      dateTime: now.toString(),
                    );
                  } else {
                    SocialCubit.get(context).createPost(
                      text: postController.text,
                      dateTime: now.toString() ,
                    );
                  }
                },
                child: Text('post'.toUpperCase()),
              ),
            ),
          ]),
          // CustomScrollView =>> to put expanded inside scrollable Widget
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      if (state is UploadPostImageLoadingState)
                        const LinearProgressIndicator(),
                      if (state is UploadPostImageLoadingState)
                        SizedBox(
                          height: 5,
                        ),
                      _buildUserInfo(context),
                      SizedBox(
                        height: 30,
                      ),
                      _buildPost(),
                      if (SocialCubit.get(context).postImage != null)
                        _buildPostImage(
                            SocialCubit.get(context).userModel!, context),
                      _buildAddImageButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            '${SocialCubit.get(context).userModel!.profileImage}',
          ),
          radius: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      '${SocialCubit.get(context).userModel!.name}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildPost() {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "What's on your mind?",
          border: InputBorder.none,
        ),
        controller: postController,
        style: TextStyle(fontSize: 18),
        cursorHeight: 20,
        // this two lines =>> to enter a new line
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );
  }

  _buildAddImageButton(context) {
    return TextButton(
        onPressed: () {
          SocialCubit.get(context).getPostImage();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconBroken.Image),
            SizedBox(
              width: 10,
            ),
            Text('Add Image'),
          ],
        ));
  }

  Widget _buildPostImage(UserModel model, context) {
    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(SocialCubit.get(context).postImage!),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              radius: 18,
              child: IconButton(
                onPressed: () {
                  SocialCubit.get(context).removePostImage();
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
