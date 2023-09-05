import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_snap/pages/add_location/widget/map_view.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_snap/pages/add_photo/bloc/add_photo_bloc.dart';
import 'package:photo_snap/pages/add_photo/bloc/add_photo_event.dart';
import 'package:photo_snap/pages/add_photo/bloc/add_photo_states.dart';
import 'package:photo_snap/pages/home/bloc/home_event.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/arc.dart';
import '../../home/bloc/home_bloc.dart';
import 'addpagebar.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({super.key});

  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  File? image;
  XFile? _compressedFile;
  late String photo;
  final ImagePicker picker = ImagePicker();
  final HomeBloc homeBloc = HomeBloc();
  late String selectedLocation;
  void myAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Please choose media to select'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF434343), // Button background color
                    ),
                  child: const Row(
                    children: [
                      Icon(Icons.image),
                      Text('From Gallery'),
                    ],
                  )
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF434343), // Button background color
                    ),
                  child: const Row(
                    children: [
                      Icon(Icons.camera),
                      Text('From Camera'),
                    ],
                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> compress() async {
    var result = await FlutterImageCompress.compressAndGetFile(
      image!.absolute.path,
      '${image!.path}compressed.jpg',
      quality: 40,
    );
    print('Compressed file size: ${result!.length}');

    setState(() {
      _compressedFile = result;

    });

    // Encode the compressed image as base64
    List<int> compressedImageBytes = await _compressedFile!.readAsBytes();
    String base64CompressedImage = base64Encode(compressedImageBytes);
    photo = base64CompressedImage;

    // Now you can use the base64CompressedImage as needed
  }
  Future<void> getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    if (img != null) {
      // Crop the selected image
      File? croppedImage = await cropImage(img.path);

      if (croppedImage != null) {
        setState(() {
          image = croppedImage;
          compress(); // Call the compress function to compress and encode the image
        });
      }
    }
  }
  Future<File?> cropImage(imagePath) async {
    File? croppedImage;
    final imageCropper = ImageCropper();
    try {
      final croppedFile = await imageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );

      if (croppedFile != null) {
        croppedImage = File(croppedFile.path);
      }
    } catch (e) {
      print("Error cropping image: $e");
    }

    return croppedImage;
  }

  final TextEditingController locationControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPhotoBloc, AddPhotoState>(builder: (context, state) {
      return Scaffold(
        appBar:  const PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: AddAppBar() ,
        ),
        body:Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // If image not null, show the image
                          image != null
                              ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                              ),
                            ),
                          )
                              :SizedBox(
                            width: 300,
                            height: 300,
                            child: image != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(150), // Half of the width/height for a circle
                              child: Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                                width: 300,
                                height: 300,
                              ),
                            )
                                : const Icon(
                              Icons.image_rounded,
                              size: 100,
                              color: Colors.grey, // Placeholder color
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              myAlert(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF434343), // Button background color
                              elevation: 8,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: const Text(
                              'Take Photo',
                              style: TextStyle(color: Colors.white), // Button text color
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: locationControl,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Color(0xFFF65959),
                                size: 28,
                              ),
                              hintText: 'Add your location',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () async {
                              final selectedLocation =
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                    onLocationSelected: (location) {
                                      return location;
                                    },
                                  ),
                                ),
                              );

                              if (selectedLocation != null) {
                                locationControl.text = selectedLocation;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 46),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the contents vertically
                        children: <Widget>[

                          BlocBuilder<AddPhotoBloc,AddPhotoState>(
                            builder: (context, state) {
                              return   ElevatedButton(
                                onPressed: () async {
                                  final location = locationControl.text;

                                  context.read<AddPhotoBloc>().add(AddPhotoEvent(photoData: photo, location: location));

                                  Fluttertoast.showToast(
                                    msg: "Image added!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );

                                  // Dispatch FetchDataEvent directly to update the UI
                                  context.read<HomeBloc>().add( const FetchDataEvent(hasNewPhoto: true, query: ''));
                                  Navigator.pop(context); // Close the current screen
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  elevation: 5,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: const Text('Save'),
                              );
                            },
                          ),
                          const SizedBox(height: 10), // Space between buttons
                          ElevatedButton(
                            onPressed: () {
                              // Handle Cancel button action here
                              Navigator.pop(context); // Close the current screen
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Button background color
                              elevation: 5,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Adjust padding here
                              textStyle: const TextStyle(fontSize: 18), // Text style of the button label
                            ),
                            child: const Text('Cancel'),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: ClipPath(
                        clipper: BottomWaveClipper(),
                        child: Container(
                          height: 110,
                          decoration: const BoxDecoration(
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      );
    });
  }
}
