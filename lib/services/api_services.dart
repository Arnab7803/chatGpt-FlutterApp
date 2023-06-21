import 'dart:convert';
import 'dart:io';
import 'package:chatgptai/constants/api_consts.dart';
import 'package:chatgptai/models/chat_model.dart';
import 'package:chatgptai/models/models_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/models"),
          headers: {'Authorization': 'Bearer $API_KEY'});

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }

      List modelList = [];
      for (var i in jsonResponse["data"]) {
        modelList.add(i);
        if (kDebugMode) {
          print(i["id"]);
        }
      }

      return ModelsModel.modelsFromSnapshot(modelList);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMsg(
      {required String msg, required String modelId}) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/chat/completions"),
          headers: {
            "Authorization": 'Bearer $API_KEY',
            "Content-Type": 'application/json',
          },
          body: jsonEncode({
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": msg,
              }
            ],
            "temperature": 0.7
          }));

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse["error"] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }
      List<ChatModel> chatList = [];

      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                msg: jsonResponse["choices"][index]["message"]["content"],
                chatIndex: 1));
      }
      return chatList;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }
}
