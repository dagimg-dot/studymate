import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:studymate/constants/api_const.dart';
import 'package:studymate/models/models_model.dart';
import 'package:studymate/providers/chat_model.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse["error"]["message"]}");
        throw HttpException(jsonResponse['error']['message']);
      }
      // print("jsonresponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      log("model here");
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log(message);
      log(modelId);
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "model": modelId,
          // "prompt": message,
          // "max_tokens": 100,
          "messages": [
            {
              "role": "user",
              "content": message,
            }
          ],
          // "temperature": 0.7
        }),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse["error"]["message"]}");
        log("message here");
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["message"]["content"]}");
        chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                  msg: jsonResponse["choices"][0]["message"]["content"],
                  chatIndex: 1,
                ));
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
