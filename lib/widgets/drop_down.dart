import 'package:chatgptai/constants/constant.dart';
import 'package:chatgptai/providers/model_provider.dart';
import 'package:chatgptai/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models_model.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelProvider>(context, listen: false);
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
              ? SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                      dropdownColor: scaffoldBackgroundcolor,
                      iconEnabledColor: Colors.white,
                      iconDisabledColor: Colors.blueGrey,
                      items: List<DropdownMenuItem<String>>.generate(
                          snapshot.data!.length,
                          (index) => DropdownMenuItem(
                              value: snapshot.data![index].id,
                              child: TextWidget(
                                label: snapshot.data![index].id,
                                fontSize: 15,
                              ))),
                      value: currentModel,
                      onChanged: (value) {
                        setState(() {
                          currentModel = value.toString();
                        });
                        modelsProvider.setCurrentModel(value.toString());
                      }),
                );
        });
  }
}
