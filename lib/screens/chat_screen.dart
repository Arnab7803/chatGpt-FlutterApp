import 'package:chatgptai/constants/constant.dart';
import 'package:chatgptai/providers/chat_provider.dart';
import 'package:chatgptai/providers/model_provider.dart';
import 'package:chatgptai/services/asset_manager.dart';
import 'package:chatgptai/widgets/chat_widget.dart';
import 'package:chatgptai/widgets/text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({Key? key}) : super(key: key);

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> with TickerProviderStateMixin {
  bool isTyping = false;

  late TextEditingController textEditingController;

  late FocusNode focusNode;

  late ScrollController _listscrollController;

  @override
  void initState() {
    super.initState();
    _listscrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    _listscrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelProvider>(context);
    final chatsProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        scrolledUnderElevation: 5,
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          'ChatGPT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 20,
            width: 20,
            child: Image.network(AssetsManager.logoImage),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _listscrollController,
                itemCount: chatsProvider.chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                      msg: chatsProvider.chatList[index].msg,
                      chatIndex: chatsProvider.chatList[index].chatIndex);
                },
              ),
            ),
            if (isTyping) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitThreeBounce(
                      color: Colors.deepPurpleAccent,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 15),
            Material(
              elevation: 4,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          if (isTyping) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: TextWidget(
                                label: "Please wait for previous response.",
                              ),
                              backgroundColor: Colors.amberAccent,
                            ));
                            return;
                          }
                          if (textEditingController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: TextWidget(
                                label: "Please type a message!",
                              ),
                              backgroundColor: Colors.amberAccent,
                            ));
                            return;
                          }
                          try {
                            String msg = textEditingController.text;
                            setState(() {
                              isTyping = true;
                              chatsProvider.addUserMsg(msg: msg);
                              textEditingController.clear();
                              focusNode.unfocus();
                            });
                            await chatsProvider.getAllMsg(
                                msg: msg,
                                modelId: modelsProvider.getCurrentModel);
                            setState(() {});
                            if (kDebugMode) {
                              print("request Has been sent");
                            }
                          } catch (error) {
                            if (kDebugMode) {
                              print("error $error");
                            }
                          } finally {
                            setState(() {
                              listEndScroll();
                              isTyping = false;
                            });
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          focusColor: Colors.lightBlueAccent,
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (isTyping) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: TextWidget(
                              label: "Please wait for previous response.",
                            ),
                            backgroundColor: Colors.amberAccent,
                          ));
                          return;
                        }
                        if (textEditingController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: TextWidget(
                              label: "Please type a message!",
                            ),
                            backgroundColor: Colors.amberAccent,
                          ));
                          return;
                        }
                        try {
                          String msg = textEditingController.text;
                          setState(() {
                            isTyping = true;
                            chatsProvider.addUserMsg(msg: msg);
                            textEditingController.clear();
                            focusNode.unfocus();
                          });
                          await chatsProvider.getAllMsg(
                              msg: msg,
                              modelId: modelsProvider.getCurrentModel);
                          setState(() {});
                          if (kDebugMode) {
                            print("request Has been sent");
                          }
                        } catch (error) {
                          if (kDebugMode) {
                            print("error $error");
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: TextWidget(
                              label: error.toString(),
                            ),
                            backgroundColor: Colors.red.shade500,
                          ));
                        } finally {
                          setState(() {
                            listEndScroll();
                            isTyping = false;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.send_outlined,
                        color: cardColor, // Change the send icon color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void listEndScroll() {
    _listscrollController.animateTo(
        _listscrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut);
  }
}
