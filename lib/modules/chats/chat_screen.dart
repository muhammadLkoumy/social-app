import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/navigators.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: BuildCondition(
            condition: SocialCubit.get(context).users.isNotEmpty,
            builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => _buildChatItem(SocialCubit.get(context).users[index], context),
              separatorBuilder: (context, index) => _buildDivider(),
              itemCount: SocialCubit.get(context).users.length,
            ),
            fallback: (context) => Center(child: Text('No users yet!')),
          ),
        );
      },
    );
  }

  _buildChatItem(UserModel user, context) {
    return InkWell(
      onTap: () {
        MyNavigators.navigateTo(context, ChatDetailsScreen(userModel: user,));
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${user.profileImage}'),
                radius: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            '${user.name}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: Divider(
        height: 16,
        thickness: 1,
        color: Colors.grey.shade300,
      ),
    );
  }
}
