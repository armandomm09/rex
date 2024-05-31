import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/generals/app_button.dart';
import 'package:chat_app/components/forms/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmail(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 300,
                width: 300,
                child:  Center()
                // ModelViewer(
                //   autoRotate: true,
                //   rotationPerSecond: "20deg",
                //           backgroundColor: Colors.transparent,
                //           src: "assets/images/stl/5887_3D.gltf"
                //           ),
              ),
              //Image.asset("assets/images/5887_trans.png", height: MediaQuery.of(context).size.height * 0.4,),
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
                  login(context);
                },
              ),
              const SizedBox(
                height: 25,
              ),
              AppTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
                focusNode: _passwordFocus,
                onSubmitted: (_) {
                  login(context);
                },
              ),
              const SizedBox(
                height: 25,
              ),
              AppButton(
                text: "Login",
                onTap: () => login(context),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member? "),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      "Register now",
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
