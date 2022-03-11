import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/modules/login/screen/login_screen.dart';
import 'package:social_app/shared/components/main_components.dart';
import 'package:social_app/shared/components/navigators.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import '../../models/user_model.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;

        nameController.text = userModel!.name != null ? userModel.name! : '';
        bioController.text = userModel.bio != null ? userModel.bio! : '';
        phoneController.text = userModel.phone != null ? userModel.phone! : '';

        return Scaffold(
          appBar: myAppBar(title: 'Update Info', context: context, actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: TextButton(
                  onPressed: () {
                    SocialCubit.get(context).updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  },
                  child: Text('update'.toUpperCase())),
            ),
          ]),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCoverAndProfileImages(userModel, context),
                  SizedBox(
                    height: 20,
                  ),
                  _buildUpdateProfileAndCoverImageButtons(state, context),
                  SizedBox(
                    height: 40,
                  ),
                  _inputFields(),
                  if (state is UpdateUserLoadingState)
                    const LinearProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        CacheHelper.removeData(key: 'uId').then((value) {
                          MyNavigators.navigateAndFinish(context, LoginScreen());
                        });
                      },
                      child: Text('Logout'.toUpperCase(), style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        CacheHelper.removeData(key: 'uId').then((value) {
                          SocialCubit.get(context).deleteUser();
                          MyNavigators.navigateAndFinish(context, LoginScreen());
                        });
                      },
                      child: Text('delete account'.toUpperCase(), style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          Stack(
            alignment: Alignment.topRight,
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
                    image: SocialCubit.get(context).coverImage == null
                        ? NetworkImage('${model.coverImage}')
                        : FileImage(SocialCubit.get(context).coverImage!)
                            as ImageProvider,
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
                          SocialCubit.get(context).getCoverImage();
                        },
                        icon: Icon(
                          IconBroken.Camera,
                          color: Colors.white,
                          size: 18,
                        ))),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: CircleAvatar(
                    backgroundImage:
                        SocialCubit.get(context).profileImage == null
                            ? NetworkImage('${model.profileImage}')
                            : FileImage(SocialCubit.get(context).profileImage!)
                                as ImageProvider,
                    backgroundColor: Colors.white,
                    radius: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 4,
                    bottom: 4,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 18,
                    child: IconButton(
                      onPressed: () {
                        SocialCubit.get(context).getProfileImage();
                      },
                      icon: Icon(
                        IconBroken.Camera,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _inputFields() {
    return Column(
      children: [
        myTextField(
          controller: nameController,
          prefix: IconBroken.User,
          validateTitle: 'Username',
          labelText: 'Username',
          type: TextInputType.name,
        ),
        SizedBox(
          height: 8,
        ),
        myTextField(
          controller: bioController,
          prefix: IconBroken.Info_Circle,
          validateTitle: 'Bio',
          labelText: 'Bio',
          type: TextInputType.text,
        ),
        SizedBox(
          height: 8,
        ),
        myTextField(
          controller: phoneController,
          prefix: IconBroken.Call,
          validateTitle: 'Phone',
          labelText: 'Phone',
          type: TextInputType.phone,
        ),
      ],
    );
  }

  _buildUpdateProfileAndCoverImageButtons(SocialStates state, context) {
    return Row(
      children: [
        if (SocialCubit.get(context).profileImage != null)
          Expanded(
            child: Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        SocialCubit.get(context).uploadProfileImage(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text,
                        );
                      },
                      child: Text('Update Profile'),
                    )),
                if (state is UploadProfileImageLoadingState)
                  const LinearProgressIndicator(),
              ],
            ),
          ),
        const SizedBox(
          width: 5,
        ),
        if (SocialCubit.get(context).coverImage != null)
          Expanded(
            child: Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        SocialCubit.get(context).uploadCoverImage(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text,
                        );
                      },
                      child: Text('Update Cover'),
                    )),
                if (state is UploadCoverImageLoadingState)
                  const LinearProgressIndicator(),
              ],
            ),
          ),
      ],
    );
  }
}
