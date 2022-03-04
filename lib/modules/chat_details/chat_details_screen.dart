import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../../models/user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel userModel;

  ChatDetailsScreen({Key? key, required this.userModel}) : super(key: key);

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(
          receiverId: userModel.uId!,
        );

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage:
                          NetworkImage('${userModel.profileImage}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('${userModel.name}')
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    BuildCondition(
                      condition: SocialCubit.get(context).messages.isNotEmpty,
                      builder: (context) => Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).messages[index];
                            if (userModel.uId ==
                                SocialCubit.get(context)
                                    .messages[index]
                                    .receiverId) {
                              return _buildSenderChatItem(message);
                            } else {
                              return _buildReceiverChatItem(message);
                            }
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                          itemCount: SocialCubit.get(context).messages.length,
                        ),
                      ),
                      fallback: (context) => Expanded(
                        child: Center(
                            child: Text(
                          'No messages!',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey.shade600,
                          ),
                        )),
                      ),
                    ),
                    _buildBottomRow(context),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReceiverChatItem(MessageModel message) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(8),
            topEnd: Radius.circular(8),
            topStart: Radius.circular(8),
          ),
        ),
        child: Text(
          '${message.text}',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSenderChatItem(MessageModel message) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.2),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(8),
            topEnd: Radius.circular(8),
            topStart: Radius.circular(8),
          ),
        ),
        child: Text(
          '${message.text}',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  _buildBottomRow(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'write your message...',
                border: InputBorder.none,
              ),
              controller: messageController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          IconButton(
            onPressed: () {
              print('Hi');
              SocialCubit.get(context).sendMessage(
                receiverId: userModel.uId!,
                dateTime: DateTime.now().toString(),
                text: messageController.text,
              );
              // clear input field after sending message
              messageController.clear();
            },
            icon: Icon(
              IconBroken.Send,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
