import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../app_utils/z_get_utils.dart';
import 'z_image_compress.dart';

typedef Null ValueChangeCallback(File value);
typedef Null ValueChangeCallbackDeleteImg(bool value);

class ZSelectSingleImage extends StatefulWidget {
  final ValueChangeCallback onImageChange;
  final ValueChangeCallbackDeleteImg onDeleteImage;
  final File imageFile;
  final String imageUrl;
  final bool isEnabled;
  final double height;
  final double width;
  final EdgeInsets margin;
  final bool isDisabled;

  ZSelectSingleImage({
    Key key,
    this.onImageChange,
    this.onDeleteImage,
    this.imageFile,
    this.imageUrl = '',
    this.isEnabled = true,
    this.height = 270,
    this.width,
    this.margin,
    this.isDisabled = false,
  }) : super(key: key);

  _ZSelectSingleImageState createState() => _ZSelectSingleImageState();
}

class _ZSelectSingleImageState extends State<ZSelectSingleImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showGetDialog,
      child: Container(
        margin: widget.margin ?? EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: ClipRRect(borderRadius: BorderRadius.circular(5), child: buildImageDisplay()),
      ),
    );
  }

  Widget buildImageDisplay() {
    if (widget.imageFile != null)
      return Image(
        image: FileImage(widget.imageFile),
        width: double.infinity,
        height: widget.height,
        fit: BoxFit.cover,
      );

    if (widget.imageUrl != '')
      return Container(
        width: widget.width,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: widget.imageUrl,
          height: widget.height,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Container(
              alignment: Alignment.center,
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
            ),
          ),
          errorWidget: (context, url, error) => Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
                child: Text('No Image \nSelected', textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      );

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(AntDesign.camera),
          SizedBox(height: 5),
          Text('Selected Image', textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Future getImage(bool isCamera) async {
    Navigator.pop(context);
    Get.bottomSheet(Container());

    final ImagePicker _picker = ImagePicker();
    PickedFile _pickedFile;

    if (isCamera) {
      _pickedFile = await _picker.getImage(source: ImageSource.camera);
    } else {
      _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    }

    if (_pickedFile != null) {
      File file = await ZImageCompress.getCompressImageFile(File(_pickedFile.path));

      File cropped = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
        ],
        androidUiSettings: AndroidUiSettings(
          statusBarColor: Colors.black,
          toolbarColor: Colors.black,
          toolbarTitle: "Crop Image",
          toolbarWidgetColor: Colors.white,
        ),
        aspectRatio: CropAspectRatio(ratioX: 1200, ratioY: 1200),
        maxWidth: 1200,
      );

      widget.onImageChange(cropped);
    } else {
      widget.onImageChange(widget.imageFile);
    }

    Navigator.pop(context);

    setState(() {});
  }

  void _showGetDialog() {
    if (widget.isDisabled) {
      ZGetUtils.showSnackbarError(message: 'This field is disabled');
      return;
    }
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              getImage(true);
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(children: [
                Icon(AntDesign.camera, color: Colors.black),
                SizedBox(width: 10),
                Text('Camera', style: TextStyle(color: Colors.black)),
              ]),
            ),
          ),
          Divider(height: 0),
          GestureDetector(
            onTap: () {
              getImage(false);
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(children: [
                Icon(AntDesign.picture, color: Colors.black),
                SizedBox(width: 10),
                Text('Galery', style: TextStyle(color: Colors.black)),
              ]),
            ),
          ),
          // if (widget.imageUrl != '' || widget.imageFile != null)
          //   Column(
          //     children: [
          //       Divider(height: 0),
          //       GestureDetector(
          //         onTap: () {
          //           widget.onDeleteImage(true);
          //           widget.onImageChange(null);
          //           Navigator.pop(context);
          //         },
          //         child: Container(
          //           color: Colors.white,
          //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          //           child: Row(children: [Icon(AntDesign.delete, color: Colors.red), SizedBox(width: 10), Text('Delete', style: TextStyle(color: Colors.red))]),
          //         ),
          //       ),
          //     ],
          //   ),
          if (Platform.isIOS) SizedBox(height: 10)
        ],
      ),
    ));
  }
}
