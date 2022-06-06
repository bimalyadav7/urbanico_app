import 'package:flutter/material.dart';
import 'package:urbanico_app/Repository/TimesheetViewProvider/TimesheetViewRepository.dart';
import 'package:provider/provider.dart';

class TimesheetPicture extends StatelessWidget {
  final TabController tabController;

  const TimesheetPicture({required this.tabController});

  @override
  Widget build(BuildContext context) {
    var pictureData = Provider.of<TimeSheetViewRepo>(context);
    return ((pictureData.pictures.isNotEmpty)
        ? Container(
            child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 14, childAspectRatio: 2),
            itemCount: pictureData.pictures.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) {
              return Column(
                children: <Widget>[
                  Container(
                    child: Card(
                      color: Colors.black,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(4),
                            child: Image.file(
                              pictureData.pictures[i].picture,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: TextFormField(
                        enabled: false,
                        initialValue: pictureData.pictures[i].description,
                        autofocus: false,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(gapPadding: 2),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Description"),
                        onChanged: (String text) {
                          pictureData.pictures[i].setDescription = text;
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ))
        : Container(child: const Center(child: Text("No Pictures"))));
  }
}
