import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'chat_model.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatList => chatList;

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String choosenModelId}) async {
      log(msg);
    chatList.addAll(await ApiService.sendMessage(
      message: msg,
      modelId: choosenModelId,
    ));
    notifyListeners();
  }
}
