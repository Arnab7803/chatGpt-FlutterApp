import 'package:chatgptai/constants/constant.dart';
import 'package:chatgptai/widgets/drop_down.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModalSheet(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: scaffoldBackgroundcolor,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 200,
                height: 30,
                child: Text(
                  "Choose Model:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Flexible(
                child: DropDownWidget(),
                flex: 3,
              ),
            ],
          ),
        );
      },
    );
  }
}
