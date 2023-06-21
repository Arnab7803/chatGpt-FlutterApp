import 'package:chatgptai/models/models_model.dart';
import 'package:chatgptai/services/api_services.dart';
import 'package:flutter/material.dart';

class ModelProvider with ChangeNotifier {
  List<ModelsModel> modelsList = [];
  String currentModel = "gpt-3.5-turbo-0301";

  List<ModelsModel> get getModelList {
    return modelsList;
  }

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
