// ignore_for_file: unused_import, use_key_in_widget_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace, avoid_print
import 'package:frontend/widgets/checkbox_group.dart';
import 'package:frontend/widgets/predicted_imgs.dart';
import 'package:frontend/utils/api.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:frontend/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle, AssetBundle;

void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? image;
  List<String>? itemPaths;
  late String selectedCategory;

  void updateSelectedCategory(String newCategory) {
    selectedCategory = newCategory;
  }

  final ImagePicker picker = ImagePicker();

  Future<String> _saveImage() async {
    if (image == null) {
      return "";
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    final now = DateTime.now();
    final fileName = 'image_${now.microsecondsSinceEpoch}.jpg';
    final filePath = '$path/$fileName';

    await image!.saveTo(filePath);
    print("oksee" + filePath);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Image saved to $filePath')));
    return filePath;
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    final bytes = await img?.readAsBytes();

    // print(bytes?.length);
    // predictImage(bytes, selectedCategory);
    // await img?.saveTo(save_path);
    // final directory = await getApplicationDocumentsDirectory();
    // final path = directory.path;
    // copy the file to a new path
    // await img?.saveTo('lib/assets/image1.png');
    // print(path);

    setState(() {
      image = img;
    });

    return img;
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Choose a clothing media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothing Recommendation'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  myAlert();
                },
                child: Text('Upload Photo'),
              ),
              SizedBox(
                height: 10,
              ),
              //if image not null show the image
              //if image null show text
              image != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              //to show image, you type like this.
                              File(image!.path),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                            ),
                          ),
                        ),
                        RadioboxGroup(
                          updateCategory: updateSelectedCategory,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // String path = await _saveImage();
                            final bytes = await image?.readAsBytes();
                            predictImage(bytes, selectedCategory).then((items) {
                              setState(() {
                                itemPaths = items;
                                print(items);
                              });
                            });
                          },
                          child: Text(
                            "Predict Photo",
                          ),
                        )
                      ],
                    )
                  : Text(
                      "No Image",
                      style: TextStyle(fontSize: 20),
                    ),

              itemPaths != null
                  ? Column(
                      children: [
                        Text(
                          "Your recommendations are",
                          textAlign: TextAlign.center,
                        ),
                        ImageGrid(
                          images: itemPaths ?? [],
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
