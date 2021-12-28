import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
// ignore: unused_import
import 'package:image_cropper/image_cropper.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class ProfileState extends State<Profile> {
  //
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Image Empty !!!';
  String nik;
  final snackbarKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  void _snackbar(String str) {
    if (str.isEmpty) return;
    _scaffoldState.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.red,
      content: new Text(str,
          style: new TextStyle(fontSize: 15.0, color: Colors.white)),
      duration: new Duration(seconds: 5),
    ));
  }

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  // Future<Null> _pickImage() async {
  //   imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   if (imageFile != null) {
  //     setState(() {
  //       state = AppState.picked;
  //     });
  //   }
  // }

  chooseImage1() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    if (file != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    upload(tmpFile);
  }

  Future upload(File imageFile) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    var headers = {
      'Authorization':
          'wTPb3I47TnooWoJijkUw65YIhp72X3YrE5fA+c27mZcJzEka6Uxp2jTV3qMabKESnxpFnARAWFE8NN79qcf3Dw'
    };

    var request = http.MultipartRequest('PUT',
        Uri.parse('https://staging-satrio.kelaspintar.co.id/lpt-api/api/file'));
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var multipartFile = new http.MultipartFile("file", stream, length,
        filename: path.basename(imageFile.path));
    request.files.add(multipartFile);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      _snackbar('Upload berhasil');
    } else {
      print(response.reasonPhrase);
      _snackbar('Upload Failed');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Center(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
              width: 250,
              height: 250,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          );
        }
      },
    );
  }

  AppState state;

  @override
  initState() {
    print(tmpFile);
    state = AppState.free;
    super.initState();
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: tmpFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      tmpFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    tmpFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
          title: new Text(
        'Ganti Foto',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      )),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            (file == null)
                ? Icon(
                    Icons.image_search,
                    size: 250,
                  )
                : showImage(),
            SizedBox(
              height: 10,
            ),
            OutlineButton(
              onPressed: () {
                chooseImage();
              },
              child: Text('Ambil dari camera'),
            ),
            SizedBox(
              height: 10,
            ),
            OutlineButton(
              onPressed: () {
                chooseImage1();
              },
              child: Text('Ambil dari galery'),
            ),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton(
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                    )
                  : Text('Simpan'),
              onPressed: () => startUpload(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (state == AppState.picked)
            _cropImage();
          else if (state == AppState.cropped) _clearImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }
}
