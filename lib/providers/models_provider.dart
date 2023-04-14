import 'package:flutter/widgets.dart';
import 'package:studymate/models/models_model.dart';
import 'package:studymate/services/api_service.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "gpt-3.5-turbo"; 
  
  String get getCurrentModel => currentModel;

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList => modelsList;

  Future<List<ModelsModel>> getAllModels() async { 
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}