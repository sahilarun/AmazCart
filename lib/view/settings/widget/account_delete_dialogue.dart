import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountDeleteDialogue extends StatelessWidget {
  final Function() onYesTap;

  const AccountDeleteDialogue({
    required this.onYesTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CupertinoAlertDialog(
      title: const Text('Confirmation'),
      content: Text('Are you sure want to delete account?'),
      actions: [
        TextButton(
            onPressed: ()=> Get.back(),
            child: Text('CANCEL')
        ),
        TextButton(
            onPressed: onYesTap,
            child: Text('DELETE')
        ),
      ],
    );
  }
}


