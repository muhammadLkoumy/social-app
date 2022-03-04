import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/modules/update_info/update_profile_screen.dart';
import 'package:social_app/shared/components/navigators.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // we created this builder to get user after login again
    return Builder(
      builder: (BuildContext context) {
        // this instance to get user after login
        SocialCubit.get(context).getUser();

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var userModel = SocialCubit.get(context).userModel;
            return Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildCoverAndProfileImages(userModel!, context),
                      _buildUsernameAndBio(userModel, context),
                      SizedBox(
                        height: 30,
                      ),
                      _buildSectionHead(),
                      SizedBox(
                        height: 20,
                      ),
                      _addAndEditRow(context, userModel),
                      // here you subscribe to topic to get notified by it
                      // Row(
                      //   children: [
                      //     OutlinedButton(onPressed: (){
                      //       FirebaseMessaging.instance.subscribeToTopic('new');
                      //     }, child: Text('Subscribe')),
                      //     OutlinedButton(onPressed: (){
                      //       FirebaseMessaging.instance.unsubscribeFromTopic('new');
                      //     }, child: Text('Unsubscribe')),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCoverAndProfileImages(UserModel model, context) {
    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage('${model.coverImage}'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              radius: 54,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: CircleAvatar(
                backgroundImage: NetworkImage('${model.profileImage}'),
                backgroundColor: Colors.white,
                radius: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameAndBio(UserModel model, context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${model.name}',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            '${model.bio}',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHead() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                '100',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Posts',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '250',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Photos',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '10k',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Followers',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '300',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Following',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _addAndEditRow(context, userModel) {
    return Row(
      children: [
        Expanded(
            child: OutlinedButton(
          onPressed: () {},
          child: Text('Add Photos'),
        )),
        SizedBox(
          width: 10,
        ),
        OutlinedButton(
          onPressed: () {
            MyNavigators.navigateTo(
              context,
              UpdateProfileScreen(),
            );
          },
          child: Icon(IconBroken.Edit),
        ),
      ],
    );
  }
}
