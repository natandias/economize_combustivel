import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isConfirmPasswordVisible = false;
  bool isPasswordVisible = false;
  bool isCreateAccount = false;
  bool isPasswordError = false;
  bool isConfirmPasswordError = false;
  bool isEmailError = false;
  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  void clearText() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() => isConfirmPasswordVisible = false);
    setState(() => isPasswordVisible = false);
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _form,
        child: Center(
          child: ListView(
            children: [
              isCreateAccount
                  ? const SizedBox(height: 0)
                  : const SizedBox(height: 28),
              SizedBox(
                height: isEmailError ? 70 : 50,
                child: SizedBox(
                  child: buildEmail(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: isPasswordError ? 70 : 50,
                child: SizedBox(
                  child: buildPassword(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: isCreateAccount ? 70 : 0,
                child: SizedBox(
                  child: isCreateAccount
                      ? buildPasswordConfirmation()
                      : (const SizedBox(height: 0)),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.deepOrange,
                ),
                child:
                    isCreateAccount ? Text('Criar conta') : Text('Fazer login'),
                onPressed: () {
                  _form.currentState!.validate();
                  print('Email: ${emailController.text}');
                  print('Password: ${passwordController.text}');
                },
              ),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                    child: isCreateAccount
                        ? const Text('Já possui uma conta?')
                        : const Text('Criar uma conta'),
                    onTap: () => {
                          setState(() => isCreateAccount = !isCreateAccount),
                          clearText(),
                        }),
              ]),
            ],
          ),
        ),
      );

  Widget buildEmail() => SizedBox(
        height: 50,
        child: TextFormField(
          controller: emailController,
          validator: (value) {
            setState(() => isEmailError = false);
            if (value!.isEmpty) {
              setState(() => isEmailError = true);
              return 'Campo obrigatório';
            }
          },
          decoration: InputDecoration(
            hintText: 'name@example.com',
            labelText: 'Email',
            labelStyle: const TextStyle(color: Colors.white),
            contentPadding:
                const EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
            prefixIcon: const Icon(Ionicons.mail_outline, size: 20),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
      );

  Widget buildPassword() => SizedBox(
        height: 50,
        child: TextFormField(
          controller: passwordController,
          validator: (value) {
            setState(() => isPasswordError = false);
            if (value!.isEmpty) {
              setState(() => isPasswordError = true);
              return 'Campo obrigatório';
            }
          },
          decoration: InputDecoration(
            hintText: '********',
            labelText: 'Senha',
            labelStyle: const TextStyle(color: Colors.white),
            contentPadding:
                const EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
            prefixIcon: const Icon(Ionicons.lock_closed_outline, size: 20),
            suffixIcon: IconButton(
              icon: isPasswordVisible
                  ? const Icon(
                      Ionicons.eye_off_outline,
                      size: 20,
                    )
                  : const Icon(
                      Ionicons.eye_outline,
                      size: 20,
                    ),
              onPressed: () =>
                  setState(() => isPasswordVisible = !isPasswordVisible),
            ),
          ),
          obscureText: !isPasswordVisible,
          textInputAction: TextInputAction.done,
        ),
      );

  Widget buildPasswordConfirmation() => SizedBox(
        height: 50,
        child: TextFormField(
          controller: confirmPasswordController,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Campo obrigatório';
            }
            if (val != passwordController.text) {
              return 'Senhas não conferem';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: '********',
            labelText: 'Confirmar senha',
            labelStyle: const TextStyle(color: Colors.white),
            contentPadding:
                const EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
            prefixIcon: const Icon(Ionicons.lock_closed_outline, size: 20),
            suffixIcon: IconButton(
              icon: isConfirmPasswordVisible
                  ? const Icon(Ionicons.eye_off_outline, size: 20)
                  : const Icon(Ionicons.eye_outline, size: 20),
              onPressed: () => setState(
                  () => isConfirmPasswordVisible = !isConfirmPasswordVisible),
            ),
          ),
          obscureText: !isConfirmPasswordVisible,
          textInputAction: TextInputAction.done,
        ),
      );
}
