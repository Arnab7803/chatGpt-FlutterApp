import 'package:chatgptai/models/chat_model.dart';
import 'package:flutter/foundation.dart';

import '../services/api_services.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getchatList {
    return chatList;
  }

  void addUserMsg({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> getAllMsg({required String msg, required String modelId}) async {
    chatList.addAll(await ApiService.sendMsg(msg: msg, modelId: modelId));
    notifyListeners();
  }
}
