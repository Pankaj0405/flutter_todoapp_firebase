import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_todoapp_firebase/screens/home_screen.dart';
import 'package:flutter_todoapp_firebase/screens/login_screen.dart';
import 'package:flutter_todoapp_firebase/screens/signup_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_todoapp_firebase/models/user.dart' as model;
import 'package:image_picker/image_picker.dart';


class AuthController extends GetxController {
  Rx<String?> profilePhotoget = Rx<String?>(null);
  Rx<Uint8List?> image = Rx<Uint8List?>(null);
  XFile? file;
  var firebaseAuth=FirebaseAuth.instance;
  var firebaseStorage=FirebaseStorage.instance;
  var firestore=FirebaseFirestore.instance;

  static AuthController instance=Get.find();
  late Rx<User?> _user;
late  Rx<File?> _pickedImage;

File? get profilePhoto=> _pickedImage.value;
User get user => _user.value!;
@override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user=Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);

  }
// check if user is already exist
  _setInitialScreen(User? user){
  if(user== null){
    Get.offAll(()=>LoginScreen());
  }else{
    Get.offAll(()=> HomeScreen());
  }
  }
// method to pick image
  void pickImage() async {
    final pickedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
    file=pickedImage;
    image.value=await file?.readAsBytes();
    if(pickedImage!=null){
      Get.snackbar("Profile picture", "You have secessfully slected your profile picture");
      update();
    }
    _pickedImage=Rx<File?>(File(pickedImage!.path));


  }


  //upload to storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

UploadTask uploadTask =  ref.putFile(image);
TaskSnapshot snap=await uploadTask;
String downloadUrl= await snap.ref.getDownloadURL();
return downloadUrl;
  }

  //register user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // save a user
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        String downloadUrl= await _uploadToStorage(image);
        model.User user=model.User(name: username,
            profilePhoto: downloadUrl, email: email, uid: cred.user!.uid);
      await firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

      }else{
        Get.snackbar('Error creating Account', "Please enter all the field");
      }
    } catch (e) {
      Get.snackbar('Error creating a account', e.toString());
    }
  }

 //Login user
  void loginUser(String email,String password) async{
try{
if(email.isNotEmpty &&
    password.isNotEmpty){
await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
print('log sucess');
}else{
  Get.snackbar('Error Logging in', "Please enter all the field");
}
}catch(e){
  Get.snackbar('Error logging in', e.toString());
}
  }
// sign out
  signOut()async{
  await firebaseAuth.signOut();
  }

  // get user data
getUserData() async {
  DocumentSnapshot userDoc =
      await firestore.collection('users').doc(firebaseAuth.currentUser!.uid).get();
  final userData = userDoc.data()! as dynamic;

  profilePhotoget.value= userData['profilePhoto'];

}
}
