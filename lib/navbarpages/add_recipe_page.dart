import 'dart:io';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/navbarpages/my_recipe_page.dart';

class AddRecipePage extends StatefulWidget {
  AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final nameController = TextEditingController();
  final ingredientsController = TextEditingController();
  var birthDate = DateTime.now();

  bool isDateSelected = true;

  File? image;

  UploadTask? uploadTask;

  String? imagePath;

  bool imageUploaded = false;

  bool imageSelected = false;

  late var urlDownload;
/*
  Future<String> uploadFile() async {
    final path =
        'userstorage/${FirebaseAuth.instance.currentUser!.email}/files/userImage';
    if (image != null) {
      final file = File(image!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() {});
      urlDownload = await snapshot.ref.getDownloadURL();

      print('download link: $urlDownload');
      return urlDownload;
    } else {
      return urlDownload;
    }
  }
   */

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      imageUploaded = true;
      setState(() {
        this.image = imageTemporary;
        imageSelected = true;
        //uploadFile();
      });
    } on PlatformException catch (e) {
      print('failed to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0x00000000),
        elevation: 0,
        actionsIconTheme: const IconThemeData(
            color: Color.fromARGB(255, 60, 69, 80), size: 22),
        actions: [
          //=> Back
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 9),
            ),
            onTap: () {
              Navigator.of(context).pop(
                MaterialPageRoute(
                  builder: (context) => AddRecipePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromARGB(255, 239, 61, 100),
                Color.fromARGB(255, 239, 93, 103),
                Color.fromARGB(255, 239, 127, 107),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.topRight,
                    width: 150.0,
                    height: 150.0,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          //=> wight strok
                          radius: 75,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: image != null
                                ? FileImage(File(image!.path))
                                : NetworkImage(
                                        'https://en.wikipedia.org/wiki/Food#/media/File:Good_Food_Display_-_NCI_Visuals_Online.jpg')
                                    as ImageProvider,
                            // NetworkImage(
                            //   '${firebaseUser["addressImage"]}'),
                          ),
                        ),
                        CircleAvatar(
                          //=> Profile Pic
                          radius: 18,
                          backgroundColor: Color.fromARGB(178, 175, 173, 173),
                          child: GestureDetector(
                            child: PopupMenuButton<int>(
                              elevation: 2,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 1,
                                  child: Center(
                                    child: Text(
                                      "Gallery",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color.fromARGB(255, 10, 2, 2),
                                      ),
                                    ),
                                  ),
                                ),
                                const PopupMenuDivider(),
                                const PopupMenuItem(
                                  value: 1,
                                  child: Center(
                                    child: Text(
                                      "Camera",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color.fromARGB(255, 62, 61, 61),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              initialValue: 0,
                              onSelected: (value) {
                                switch (value) {
                                  case 1:
                                    {
                                      pickImage(ImageSource.gallery);
                                      break;
                                    }
                                  case 2:
                                    {
                                      pickImage(ImageSource.camera);
                                      break;
                                    }
                                }
                              },
                              offset: const Offset(0, -90),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Color.fromARGB(255, 239, 61, 100),
                              ),
                            ),
                            //const ImageIcon(AssetImage('assets/icons/edit_icon.png'),color: Colors.white, ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    //initialValue: globals.name,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      suffixIconConstraints:
                          BoxConstraints(minHeight: 45, minWidth: 45),
                    ),
                  ),
                ),
                //=> Last Name Fild
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    minLines: 1,
                    maxLength: 200,
                    maxLines: 5,
                    controller: ingredientsController,
                    textInputAction: TextInputAction.next,
                    //initialValue: firebaseUser["biography"],
                    decoration: const InputDecoration(
                      labelText: 'Ingredients',
                      suffixIconConstraints:
                          BoxConstraints(minHeight: 45, minWidth: 45),
                    ),
                  ),
                ),
              ],
            )),
          )),
    );
  }
}
