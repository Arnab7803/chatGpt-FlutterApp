import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgptai/constants/constant.dart';
import 'package:chatgptai/services/asset_manager.dart';
import 'package:chatgptai/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String? msg;
  final int? chatIndex;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  bool liked = false;

  bool unliked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color:
              widget.chatIndex! % 2 == 0 ? scaffoldBackgroundcolor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.chatIndex == 0
                        ? AssetsManager.userImage
                        : AssetsManager.botImage,
                    height: 30,
                    width: 30,
                  ),
                  Expanded(
                      child: widget.chatIndex == 0
                          ? TextWidget(
                              label: widget.msg ?? widget.msg.toString(),
                              color: Colors.white70,
                            )
                          : DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                              child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  repeatForever: false,
                                  displayFullTextOnTap: true,
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TyperAnimatedText(widget.msg!.trim())
                                  ]),
                            )),
                  widget.chatIndex == 0
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  liked = !liked;
                                  unliked = false;
                                });
                              },
                              child: liked
                                  ? Icon(
                                      Icons.thumb_up_alt_rounded,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  : Icon(
                                      Icons.thumb_up_alt_outlined,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  unliked = !unliked;
                                  liked = false;
                                });
                              },
                              child: unliked
                                  ? Icon(
                                      Icons.thumb_down_alt_rounded,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  : Icon(
                                      Icons.thumb_down_alt_outlined,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                            ),
                          ],
                        ),
                ],
              ),
            ]),
          ),
        )
      ],
    );
  }
}
