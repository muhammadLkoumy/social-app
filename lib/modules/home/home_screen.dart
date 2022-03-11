import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/comment/comments_screen.dart';
import 'package:social_app/shared/components/navigators.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // final dateTime = DateTime.now().subtract(Duration(milliseconds: int.parse(SocialCubit.get(context).postModel!.dateTime!)));
        // final timeAgo = timeago.format(dateTime);

        return BuildCondition(
          condition: SocialCubit.get(context).posts.isNotEmpty &&
              SocialCubit.get(context).userModel != null,
          builder: (context) => Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHomeCover(),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => _buildPostItem(
                        context,
                        SocialCubit.get(context).posts[index],
                        SocialCubit.get(context).userModel!,
                        index),
                    itemCount: SocialCubit.get(context).posts.length,
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(
            child: Text('No posts!', style: TextStyle(fontSize: 18)),
          ),
        );
      },
    );
  }

  Widget _buildHomeCover() {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 5.0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image(
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
            image: NetworkImage(
                'https://img.freepik.com/free-vector/group-therapy-concept-people-meeting-talking-discussing-problems-giving-getting-support-vector-illustration-counselling-addiction-psychologist-job-support-session-concept_74855-10076.jpg?w=826'),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     child: Text(
          //       'Communicate with friends',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPostItem(context, PostModel post, UserModel user, index) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context, post),
            _buildDivider(),
            if (post.text != '') _buildTextPost(post),
            // _buildHashTags(),
            if (post.image != '') _buildPostImage(post),
            _buildShowLikesAndCommentsRow(context, index),
            _buildDivider(),
            _buildMakeCommentAndLikeRow(user, context, index),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(context, PostModel post) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            '${post.profileImage}',
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
                      '${post.name}',
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
              Text(
                '${post.dateTime}',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        InkWell(
            splashColor: Colors.white.withOpacity(1),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Icon(Icons.more_horiz_outlined),
            )),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Divider(
        height: 16,
        thickness: 1,
        color: Colors.grey.shade300,
      ),
    );
  }

  Widget _buildTextPost(PostModel post) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        '${post.text}',
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  // Widget _buildHashTags() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8, bottom: 8),
  //     child: Wrap(
  //       spacing: 8,
  //       children: [
  //         InkWell(
  //           onTap: () {},
  //           child: Text(
  //             '#flutter',
  //             style: TextStyle(color: Colors.blue),
  //           ),
  //         ),
  //         InkWell(
  //           onTap: () {},
  //           child: Text(
  //             '#developer',
  //             style: TextStyle(color: Colors.blue),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPostImage(PostModel post) {
    return Container(
      width: double.infinity,
      height: 150,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(
          '${post.image}',
        ),
      ),
    );
  }

  Widget _buildShowLikesAndCommentsRow(context, index) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              splashColor: Colors.white.withOpacity(0),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        IconBroken.Heart,
                        size: 22,
                      ),
                    ),
                    Text('${SocialCubit.get(context).likesNumber[SocialCubit.get(context).postsId[index]]}'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              splashColor: Colors.white.withOpacity(0),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        IconBroken.Chat,
                        size: 22,
                      ),
                    ),
                    Text('${SocialCubit.get(context).commentsNumber[SocialCubit.get(context).postsId[index]]} Comments'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMakeCommentAndLikeRow(UserModel user, context, index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            splashColor: Colors.white.withOpacity(0),
            onTap: () {
              MyNavigators.navigateTo(context, CommentsScreen(postId: SocialCubit.get(context).postsId[index],));
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    '${user.profileImage}',
                  ),
                  radius: 18,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Write a comment...',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          flex: 3,
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            splashColor: Colors.white.withOpacity(0),
            onTap: () {
              SocialCubit.get(context)
                  .likePost(SocialCubit.get(context).postsId[index]);
              // if (SocialCubit.get(context).isLiked[SocialCubit.get(context).postsId[index]]!){
              //   SocialCubit.get(context)
              //       .unlikePost(SocialCubit.get(context).postsId[index]);
              // }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.favorite,
                      color:  Colors.grey,
                      size: 22,
                    ),
                  ),
                  Text('Like'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
