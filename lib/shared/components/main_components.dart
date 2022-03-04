import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

Widget myTextField({
  required String labelText,
  required String validateTitle,
  required IconData prefix,
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  bool showPass = false,
  Function? changeVisibility,
}) {
  return TextFormField(
    decoration: InputDecoration(
      label: Text(labelText),
      prefixIcon: Icon(prefix),
      border: const OutlineInputBorder(),
      suffixIcon: isPassword
          ? IconButton(
              onPressed: () {
                changeVisibility!();
              },
              icon: showPass
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
            )
          : null,
    ),
    controller: controller,
    keyboardType: type,
    validator: (value) {
      if (value!.isEmpty) {
        return validateTitle + ' must not be empty!';
      }
      return null;
    },
    obscureText: showPass,
  );
}

Widget myButtons({
  required String label,
  required Function onPressed,
  Color buttonColor = Colors.blue,
}) {
  return Container(
    height: 45,
    width: double.infinity,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(
        color: buttonColor, borderRadius: BorderRadius.circular(8)),
    child: MaterialButton(
      onPressed: () {
        onPressed();
      },
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Widget progressIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

PreferredSizeWidget myAppBar({
  required String title,
  required BuildContext context,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(title),
    titleSpacing: 10,
    actions: actions,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(IconBroken.Arrow___Left_2),
    ),
  );
}
