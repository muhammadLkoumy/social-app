import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/modules/post/post_screen.dart';
import 'package:social_app/shared/components/navigators.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is NavigateToPostScreenState) {
          MyNavigators.navigateTo(context, PostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNav(index, context);
            },
            items: cubit.bottomNavItems,
          ),
        );
      },
    );
  }

  // _buildEmailVerification() {
  //   if (!FirebaseAuth.instance.currentUser!.emailVerified)
  //     Container(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 16,
  //       ),
  //       width: double.infinity,
  //       color: Colors.amberAccent,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             children: [
  //               Text(
  //                 "Your mail didn't verified",
  //                 style: TextStyle(color: Colors.black),
  //               ),
  //               const SizedBox(
  //                 width: 10,
  //               ),
  //               Icon(Icons.info_outline),
  //             ],
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               print(FirebaseAuth.instance.currentUser!.emailVerified);
  //               FirebaseAuth.instance.currentUser!
  //                   .sendEmailVerification()
  //                   .then((value) {
  //                 MyToast(
  //                     msg: 'Verification sent',
  //                     state: ToastStates.SUCCESS).showToast();
  //               });
  //             },
  //             child: Text(
  //               "Send",
  //               style: TextStyle(color: Colors.blue),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  // }
}
