import 'package:flutter/material.dart';
import 'package:flutter_todoapp_firebase/controllers/auth_controller.dart';
import 'package:flutter_todoapp_firebase/screens/signup_screen.dart';
import 'package:flutter_todoapp_firebase/widgets/text_input_field.dart';

class LoginScreen extends StatelessWidget {
  var authController = AuthController.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
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
            'Login',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 25,
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
            height: 25,
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
            height: 25,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: InkWell(
              onTap: () => authController.loginUser(
                  _emailController.text, _passwordController.text),
              child: const Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                "Don\'t have an account?",
                style: TextStyle(fontSize: 20),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
