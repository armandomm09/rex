import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/generals/app_button.dart';
import 'package:chat_app/components/forms/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  void register(BuildContext context) async {
    final auth = AuthService();
    
    if(passwordController.text == confirmPasswordController.text){
      try {
        await auth.signUpWithEmailAndPassword(emailController.text, passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Passwords don't match"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 300,
                width: 300,
                child: Center()
                /*ModelViewer(
                  autoRotate: true,
                  rotationPerSecond: "20deg",
                          backgroundColor: Colors.transparent,
                          src: "assets/images/stl/5887_3D.gltf"
                          ),*/
              ),
              const SizedBox(
                height: 30,
              ),
          
          
              Text(
                "Welcome back, we've been missing you",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
          
          
              const SizedBox(
                height: 25,
              ),
          
          
              AppTextField(
                hintText: "Email",
                controller: emailController,
                focusNode: _emailFocus,
                onSubmitted: (_) {
                  register(context);
                },
              ),
          
          
              const SizedBox(
                height: 10,
              ),
          
          
              AppTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
                focusNode: _passwordFocus,
                onSubmitted: (_) {
                  register(context);
                },
              ),
          
          
              const SizedBox(
                height: 10,
              ),
          
              AppTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                onSubmitted: (_) {
                  register(context);
                },
              ),
          
          
              const SizedBox(
                height: 30,
              ),
              AppButton(
                text: "Register",
                onTap: () => register(context),
              ),
          
          
              const SizedBox(
                height: 25,
              ),
          
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      "Login now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
          
          
            ],
          ),
        ),
      ),
    );
  }
}
