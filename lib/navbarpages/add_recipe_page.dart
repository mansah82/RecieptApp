import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/navbarpages/my_recipe_page.dart';
import 'package:recipe_app/utils.dart';
import 'package:uuid/uuid.dart';

class AddRecipePage extends StatefulWidget {
  AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final ScrollController scrollIngredientsController = ScrollController();
  final ScrollController scrollLabelsController = ScrollController();
  final nameController = TextEditingController();

  final descriptionController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    scrollIngredientsController.dispose();
    scrollLabelsController.dispose();
  }

  File? image;

  UploadTask? uploadTask;

  String? imagePath;

  bool imageUploaded = false;

  bool imageSelected = false;

  late var urlDownload;

  Future<String> uploadFile() async {
    var uid = Uuid();

    final path =
        'userstorage/${FirebaseAuth.instance.currentUser!.email}/files/${uid.v1()}';
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

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      imageUploaded = true;
      setState(() {
        this.image = imageTemporary;
        imageSelected = true;
        uploadFile();
      });
    } on PlatformException catch (e) {
      print('failed to pick image $e');
    }
  }

  Future createRecipe() async {
    try {
      var uuid = const Uuid();
      print('$uuid string uuid');
      var uid = FirebaseAuth.instance.currentUser!.uid;
      final docUser =
          FirebaseFirestore.instance.collection('recipes').doc(uuid.v1());

      final recipe = Recipe(
        id: uuid.v1(),
        image: urlDownload,
        createdBy: uid,
        name: nameController.text,
        description: descriptionController.text,
        ingredients: data,
        labels: labelData,

        //tar bort extra listan
      );

      final json = recipe.toMap();
      await docUser.set(json);
    } catch (e) {
      showSnackBar2(context: context, content: e.toString());
    }
  }

  List<DynamicWidget> listDynamic = [];
  List<DynamicLabelWidget> listLabelDynamic = [];
  List<String> data = [];
  List<String> labelData = [];

  Icon floatingIcon = const Icon(Icons.add);

  addDynamic() {
    if (data.isNotEmpty) {
      floatingIcon = const Icon(Icons.add);

      data = [];
      listDynamic = [];
    }
    setState(() {});
    if (listDynamic.length >= 5) {
      return;
    }
    listDynamic.add(DynamicWidget());
  }

  addLabelDynamic() {
    if (data.isNotEmpty) {
      floatingIcon = const Icon(Icons.add);

      data = [];
      listDynamic = [];
    }
    setState(() {});
    if (listLabelDynamic.length >= 5) {
      return;
    }
    listLabelDynamic.add(DynamicLabelWidget());
  }

  submitData() {
    data = [];
    for (var widget in listDynamic) {
      data.add(widget.controller.text);
    }
    labelData = [];
    for (var widget in listLabelDynamic) {
      labelData.add(widget.controllerLabel.text);
    }
    print(labelData);
    print(data);
    createRecipe();
    setState(() {});
    Navigator.of(context).pop(
      MaterialPageRoute(
        builder: (context) => MyRecipe(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollLabelsController
          .jumpTo(scrollLabelsController.position.maxScrollExtent);
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollIngredientsController
          .jumpTo(scrollIngredientsController.position.maxScrollExtent);
    });
    Widget dynamicLabelTextField = Flexible(
      flex: 2,
      child: ListView.builder(
        controller: scrollLabelsController,
        itemCount: listLabelDynamic.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) => listLabelDynamic[index],
      ),
    );

    Widget submitButton = const ElevatedButton(
      onPressed: null,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Submit Data'),
      ),
    );

    Widget dynamicTextField = Flexible(
      flex: 2,
      child: ListView.builder(
        controller: scrollIngredientsController,
        itemCount: listDynamic.length,
        // scrollDirection: Axis.vertical,
        itemBuilder: (_, index) => listDynamic[index],
      ),
    );

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
      body: Center(
        child: Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 260,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    alignment: Alignment.topRight,
                    width: 150.0,
                    height: 150.0,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          //=> wight strok
                          radius: 75,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: image != null
                                ? FileImage(File(image!.path))
                                : const NetworkImage(
                                        'https://uxwing.com/wp-content/themes/uxwing/download/food-and-drinks/meal-food-icon.png')
                                    as ImageProvider,
                            // NetworkImage(
                            //   '${firebaseUser["addressImage"]}'),
                          ),
                        ),
                        CircleAvatar(
                          //=> Profile Pic
                          radius: 18,
                          backgroundColor: Color.fromARGB(196, 255, 253, 253),
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
                                        fontSize: 14.0,
                                        color: Color.fromARGB(255, 10, 2, 2),
                                      ),
                                    ),
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 1,
                                  child: Center(
                                    child: Text(
                                      "Camera",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color.fromARGB(255, 62, 61, 61),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              initialValue: 0,
                              onSelected: (value) {
                                print("clik shod");
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
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
              Expanded(
                  child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "ingridents",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        dynamicTextField,
                      ],
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      children: <Widget>[
                        const Text("labels",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        dynamicLabelTextField,
                      ],
                    ),
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLength: 600,

                  controller: descriptionController,
                  textInputAction: TextInputAction.next,
                  //initialValue: firebaseUser["biography"],
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    suffixIconConstraints:
                        BoxConstraints(minHeight: 45, minWidth: 45),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                child: Column(
                  children: [
                    Container(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              child: ElevatedButton(
                                  onPressed: addDynamic,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 245, 196, 206)),
                                  child: const Text(
                                    'Add ingrident',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 239, 61, 100),
                                    ),
                                  )),
                            )),
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                                child: Container(
                              child: ElevatedButton(
                                  onPressed: submitData,
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 239, 61, 100),
                                    ),
                                  )),
                            )),
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: addLabelDynamic,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 245, 196, 206)),
                                    child: const Text(
                                      'Add Label',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 239, 61, 100),
                                      ),
                                    ))),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DynamicWidget extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  FocusNode focusNode = FocusNode();

  String hintText = 'Enter ingredient';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(45, 5, 20, 5),
      child: TextFormField(
        cursorColor: Color.fromARGB(255, 239, 61, 100),
        style: const TextStyle(
          color: Color.fromARGB(255, 239, 61, 100),
        ),
        controller: controller,
        decoration: const InputDecoration(
            //hintText: hintText,
            labelText: 'ingredient',
            labelStyle: TextStyle(color: Color.fromARGB(255, 239, 61, 100)),
            fillColor: Colors.white),
      ),
    );
  }
}

class DynamicLabelWidget extends StatelessWidget {
  TextEditingController controllerLabel = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(45, 5, 20, 5),
      child: TextFormField(
        cursorColor: Color.fromARGB(255, 239, 61, 100),
        style: const TextStyle(
          color: Color.fromARGB(255, 239, 61, 100),
        ),
        controller: controllerLabel,
        decoration: const InputDecoration(
            labelText: 'label',
            labelStyle: TextStyle(color: Color.fromARGB(255, 239, 61, 100)),
            fillColor: Colors.white),
      ),
    );
  }
}
