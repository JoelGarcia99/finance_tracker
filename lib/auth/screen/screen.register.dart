import 'package:finance_tracker/auth/api/api.auth.dart';
import 'package:finance_tracker/router/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class RegisterScreen extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final List<String> userPassword = ['test@test.com', '12345678']; // 0: user  1: password
  RegisterScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _getInputField(
                      placeholder: "Email",
                      keyboard: TextInputType.emailAddress,
                      leadingIcon: Icons.email_outlined,
                      name: "Email",
                      onSave: (text) => userPassword[0] = text ?? ''
                    ),
                    _getInputField(
                      placeholder: "Password",
                      // helperText: "",
                      leadingIcon: Icons.security_outlined,
                      name: "Password",
                      isPassword: true,
                      onSave: (text) => userPassword[1] = text ?? ''
                    ),
                    MaterialButton(
                      onPressed: ()async{
                        formKey.currentState?.save();
                        try {
                          SmartDialog.showLoading();
                          // await AuthAPI().signUp(userPassword[0], userPassword[1]);
                          await AuthAPI().signIn(userPassword[0], userPassword[1]);
                          Navigator.of(context).pushReplacementNamed(RouteNames.home.toString());
                        }on FirebaseAuthException catch (_, e) {
                          SmartDialog.show(
                            widget: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0,),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Text(e.toString())
                            )
                          );
                        }
                        catch(e) {
                          SmartDialog.show(
                            widget: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0,),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Text("Error trying to log in\n${e}")
                            )
                          );
                        }
                        finally {
                          SmartDialog.dismiss();
                        }
                      },
                      child: const Text("Sign up"),
                      color: Theme.of(context).colorScheme.secondary
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getInputField({
    required String placeholder,
    // required String helperText,
    required IconData leadingIcon,
    required String name,
    required void Function(String?) onSave,
    TextInputType keyboard = TextInputType.text,
    bool isPassword = false
  }) {
    return TextFormField(
      enabled: true,
      keyboardType: keyboard,
      decoration: InputDecoration(
        
        hintText: placeholder,
        // helperText: helperText,
        icon: Icon(leadingIcon),
        labelText: name,
      ),
      obscureText: isPassword,
      onSaved: onSave,
    );
  }
}