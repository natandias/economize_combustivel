import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TextFieldGeneral extends StatefulWidget {
  @override
  _TextFieldGeneralState createState() => _TextFieldGeneralState();
}

class _TextFieldGeneralState extends State<TextFieldGeneral> {
  final emailController = TextEditingController();
  String password = '';
  bool isPasswordVisible = false;
  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Center(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            buildEmail(),
            const SizedBox(height: 10),
            buildPassword(),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text('Confirmar'),
              onPressed: () {
                print('Email: ${emailController.text}');
                print('Password: $password');
              },
            ),
          ],
        ),
      );

  Widget buildEmail() => TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'name@example.com',
          labelText: 'Email',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Ionicons.mail_outline),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
      );
  Widget buildPassword() => TextField(
        onChanged: (value) => setState(() => this.password = value),
        onSubmitted: (value) => setState(() => this.password = value),
        decoration: InputDecoration(
          hintText: '********',
          labelText: 'Senha',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Ionicons.lock_closed_outline),
          suffixIcon: IconButton(
            icon: isPasswordVisible
                ? Icon(Ionicons.eye_off_outline)
                : Icon(Ionicons.eye_outline),
            onPressed: () =>
                setState(() => isPasswordVisible = !isPasswordVisible),
          ),
        ),
        obscureText: !isPasswordVisible,
        textInputAction: TextInputAction.done,
      );
}
