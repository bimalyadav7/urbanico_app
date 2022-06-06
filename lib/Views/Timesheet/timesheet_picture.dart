import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Exceptions/TimesheetValidationException.dart';
import 'package:urbanico_app/model/pictureModal.dart';
import 'package:urbanico_app/Providers/TimesheetValidationProvider.dart';
import 'package:urbanico_app/Repository/DailyReportRepository.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class TimesheetPicture extends StatelessWidget {
  final TabController tabController;
  final int tabIndex;

  const TimesheetPicture({required this.tabController, this.tabIndex = -1});

  @override
  Widget build(BuildContext context) {
    if (tabController.index == tabIndex) {
      var pictureData = Provider.of<TimeSheet>(context);
      return Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                ((pictureData.pictures.isNotEmpty)
                    ? Container(
                        child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 14, childAspectRatio: 2),
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
                              Row(
                                children: <Widget>[
                                  Flexible(
                                      flex: 1,
                                      child: TextButton(
                                          onPressed: () {
                                            pictureData.removePictures(pictureData.pictures[i]);
                                          },
                                          child: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                            size: 28,
                                          ))),
                                  Flexible(
                                    flex: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      child: TextFormField(
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
                              )
                            ],
                          );
                        },
                      ))
                    : Container(child: const Center(child: Text("No Pictures Yet")))),
                Positioned(
                    right: 32,
                    bottom: 32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Text(
                              "Upload Picture",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            FloatingActionButton(
                              mini: false,
                              backgroundColor: Colors.black,
                              foregroundColor: AppConfig().primaryColor,
                              onPressed: () async {
                                try {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  PickedFile? pickedFile = await ImagePicker()
                                      .getImage(source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear, imageQuality: 35);
                                  Picture pic = Picture();
                                  pic.setPicture = File(pickedFile!.path);
                                  pictureData.setPictures = pic;
                                } catch (err) {}
                              },
                              child: const Icon(Icons.file_upload),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate("takepicture"),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            FloatingActionButton(
                              mini: false,
                              backgroundColor: Colors.black,
                              foregroundColor: AppConfig().primaryColor,
                              onPressed: () async {
                                try {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  PickedFile? pickedFile = await ImagePicker().getImage(
                                    preferredCameraDevice: CameraDevice.rear,
                                    source: ImageSource.camera,
                                    imageQuality: 35,
                                  );
                                  Picture pic = Picture();
                                  pic.setPicture = File(pickedFile!.path);
                                  pictureData.setPictures = pic;
                                } catch (err) {}
                              },
                              child: const Icon(Icons.camera_alt),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 54,
            child: Container(
              padding: const EdgeInsets.only(top: 3, right: 24, left: 2),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(child: ReviewButton(tabController)),
                  Flexible(
                      child: MaterialButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: const Text("Submit"),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext newContext) {
                            return AlertDialog(
                              content: Text(AppLocalizations.of(context).translate("revieworsubmit")),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(newContext).pop();
                                      tabController.animateTo(0);
                                    },
                                    child: Text(AppLocalizations.of(context).translate("review"))),
                                MaterialButton(
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    Navigator.of(newContext).pop();

                                    String entrypersonid = Provider.of<UserRepository>(context, listen: false).authUser.userID;
                                    if (entrypersonid.isEmpty) {
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(AppLocalizations.of(context).translate("userdatamismatch")),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text("Close")),
                                              ],
                                            );
                                          });
                                    } else {
                                      Provider.of<TimeSheet>(context, listen: false).setDailyReport =
                                          Provider.of<DailyReportRepo>(context, listen: false).toJson();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Center(
                                                child: SizedBox(
                                              height: 300,
                                              width: 300,
                                              child: Card(
                                                child: Container(
                                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                                    const CircularProgressIndicator(),
                                                    Text(AppLocalizations.of(context).translate("submittingtimesheet"))
                                                  ]),
                                                ),
                                              ),
                                            ));
                                          });
                                      try {
                                        Provider.of<TimeSheet>(context, listen: false).validateEntryPostData(entrypersonid);
                                        var result = await Provider.of<TimeSheet>(context, listen: false).parseEntryPostData(entrypersonid);
                                        var mappedResult = jsonDecode(result);

                                        Navigator.of(context).pop();

                                        if (mappedResult["response"] == "Fail") {
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  elevation: 1.25,
                                                  content: Text("Data Entry Failed. \n${mappedResult['err']}"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text("Close")),
                                                  ],
                                                );
                                              });
                                          tabController.animateTo(mappedResult["controllerIndex"] ?? 0);
                                          Provider.of<TimesheetValidationProvider>(context, listen: false)
                                              .setMessage(mappedResult["err"], mappedResult["controllerIndex"] ?? -1);
                                        } else {
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  elevation: 1.25,
                                                  content: const Text("Data Entry Successful."),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text("Ok")),
                                                  ],
                                                );
                                              });
                                          Provider.of<TimeSheet>(context, listen: false).clearLists();
                                          Provider.of<DailyReportRepo>(context, listen: false).clearDailyReport();
                                          tabController.animateTo(0);
                                        }
                                      } on WorkHourException catch (err) {
                                        Navigator.of(context).pop();
                                        String errorMessage = AppLocalizations.of(context).translate(err.message);
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                elevation: 1.25,
                                                content: Text(errorMessage),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(AppLocalizations.of(context).translate("makecorrections"))),
                                                ],
                                              );
                                            });
                                        Provider.of<TimesheetValidationProvider>(context, listen: false).setMessage(errorMessage, 0);
                                        tabController.animateTo(Provider.of<TimesheetValidationProvider>(context, listen: false).tabIndex);
                                      } on EquipmentReadingException catch (err) {
                                        String errorMessage = AppLocalizations.of(context)
                                            .translate(err.message, args: [err.equipmentname, err.previousReading]);
                                        Navigator.of(context).pop();
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                elevation: 1.25,
                                                content: Text(errorMessage),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(AppLocalizations.of(context).translate("makecorrections"))),
                                                ],
                                              );
                                            });
                                        Provider.of<TimesheetValidationProvider>(context, listen: false).setMessage(errorMessage, 2);
                                        tabController.animateTo(Provider.of<TimesheetValidationProvider>(context, listen: false).tabIndex);
                                      } on EquipmentTotalHourException catch (err) {
                                        String errorMessage = AppLocalizations.of(context).translate("makecorrections");
                                        Navigator.of(context).pop();
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                elevation: 1.25,
                                                content: Text(AppLocalizations.of(context).translate(err.message, args: [
                                                  err.equipmentname,
                                                ])),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(errorMessage)),
                                                ],
                                              );
                                            });
                                        Provider.of<TimesheetValidationProvider>(context, listen: false).setMessage(errorMessage, 2);
                                        tabController.animateTo(Provider.of<TimesheetValidationProvider>(context, listen: false).tabIndex);
                                      }
                                    }
                                  },
                                  child: const Text("Submit"),
                                )
                              ],
                            );
                          });
                    },
                  )),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}

class ReviewButton extends StatelessWidget {
  final TabController tabController;
  const ReviewButton(this.tabController);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.lightGreen,
      textColor: Colors.white,
      onPressed: () {
        tabController.animateTo(0);
      },
      child: const Text("Review"),
    );
  }
}
