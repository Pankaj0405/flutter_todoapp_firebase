import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todoapp_firebase/controllers/auth_controller.dart';
import 'package:flutter_todoapp_firebase/screens/login_screen.dart';
import 'package:flutter_todoapp_firebase/widgets/text_input_field.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends GetWidget<AuthController> {
  var authController = AuthController.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();
  SignupScreen({
    Key? key,
  }) : super(key: key);

  // @override
  // State<SignupScreen> createState() => _SignupScreenState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Todo App',
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  'Register',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 25,
                ),
                Stack(
                  children: [
                    Obx(() => authController.image.value != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                MemoryImage(authController.image.value!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://t4.ftcdn.net/jpg/00/84/67/19/360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg'),
                            backgroundColor: Colors.black,
                          )),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () async {
                            authController.pickImage();
                            // setState(()  {
                            //   _image=_im;
                            // });
                          },
                          icon: Icon(Icons.add_a_photo),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextInputField(
                    controller: _usernameController,
                    labelText: 'Username',
                    icon: Icons.person,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextInputField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextInputField(
                    controller: _passwordController,
                    labelText: 'Password',
                    isObscure: true,
                    icon: Icons.lock,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: InkWell(
                    onTap: () => authController.registerUser(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                      authController.profilePhoto,
                    ),
                    child: const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 20),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        "Login",
                        style:
                            TextStyle(fontSize: 20, color: Colors.blueAccent),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
//
// class _SignupScreenState extends State<SignupScreen> {
//   var authController= AuthController.instance;
//
//   final TextEditingController _emailController= TextEditingController();
//
//   final TextEditingController _passwordController= TextEditingController();
//
//   final TextEditingController _usernameController= TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//         body: Container(
//           alignment: Alignment.center,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Tiktok Clone',
//                   style: TextStyle(
//                       fontSize: 35, color: Colors.blueAccent, fontWeight: FontWeight.w900),
//                 ),
//                 Text(
//                   'Register',
//                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 Stack(
//                   children: [
//                     _image!=null?CircleAvatar(
//                       radius: 64,
//                       backgroundImage: MemoryImage(_image!),
//                     ):
//                     CircleAvatar(
//                       radius: 64,
//                       backgroundImage: NetworkImage(
//                         'https://t4.ftcdn.net/jpg/00/84/67/19/360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg'
//                       ),
//                       backgroundColor: Colors.black,
//                     ),
//                     Positioned(
//                         bottom: -10,
//                         left: 80,
//                         child: IconButton(
//                           onPressed:()async{
//                             authController.pickImage();
//                             Uint8List? _im=await authController.file?.readAsBytes();
//                             setState(()  {
//                               _image=_im;
//                             });
//                           },
//                           icon: Icon(Icons.add_a_photo),
//                         ))
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.only(left: 20,right: 20),
//                   child: TextInputField(
//                     controller: _usernameController,
//                     labelText: 'Username',
//                     icon: Icons.person,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.only(left: 20,right: 20),
//                   child: TextInputField(
//                     controller: _emailController,
//                     labelText: 'Email',
//
//                     icon: Icons.email,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.only(left: 20,right: 20),
//                   child: TextInputField(
//                     controller: _passwordController,
//                     labelText: 'Password',
//                     isObscure: true,
//                     icon: Icons.lock,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 35,
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: 20,right: 20),
//                   width: MediaQuery.of(context).size.width,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       color: Colors.blueAccent,
//                       borderRadius: BorderRadius.all(Radius.circular(5))
//                   ),
//                   child: InkWell(
//                     onTap: ()=>
//                       authController.registerUser(_usernameController.text,
//                           _emailController.text, _passwordController.text,
//                           authController.profilePhoto,),
//
//                     child: const Center(
//                       child: Text('Register',
//                         style: TextStyle(
//                             fontSize:20,
//                             fontWeight: FontWeight.w700
//                         ),),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Already have an account?",
//                       style: TextStyle(
//                           fontSize: 20
//                       ),
//                     ),
//                     InkWell(
//                       onTap: (){
//                         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
//                       },
//                       child: Text("Login",style:
//                       TextStyle(
//                           fontSize: 20,
//                           color: Colors.blueAccent
//                       ),),
//                     )
//                   ],
//
//                 )
//               ],
//
//             ),
//           ),
//         ));
//   }
// }
