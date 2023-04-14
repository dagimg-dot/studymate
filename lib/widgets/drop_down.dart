import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studymate/constants/constants.dart';
import 'package:studymate/models/models_model.dart';
import 'package:studymate/providers/models_provider.dart';
import 'package:studymate/services/api_service.dart';
import 'package:studymate/widgets/text_widget.dart';

class ModelDropDownWidget extends StatefulWidget {
  const ModelDropDownWidget({super.key});

  @override
  State<ModelDropDownWidget> createState() => ModelDropDownStateWidget();
}

class ModelDropDownStateWidget extends State<ModelDropDownWidget> {
  String ?currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen:false);
    currentModel = modelsProvider.getCurrentModel;
    return FutureBuilder<List<ModelsModel>>(
        future: modelsProvider.getAllModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(label: snapshot.error.toString()),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                child: DropdownButton(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: List<DropdownMenuItem<String>>.generate(
                      snapshot.data!.length,
                      (index) => DropdownMenuItem(
                        value: snapshot.data![index].id,
                        child: TextWidget(
                          label: snapshot.data![index].id,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    value: currentModel,
                    onChanged: ((value) {
                      setState(() {
                        currentModel = value.toString();
                      });
                      modelsProvider.setCurrentModel(value.toString(),);
                    })),
              );
        });
  }
}

/*
DropdownButton(
        dropdownColor: scaffoldBackgroundColor,
        iconEnabledColor: Colors.white,
        items: getModelItems,
        value: currentModels, 
        onChanged: ((value) {
          setState(() {
            currentModels = value.toString();
          });
        }))
 */
