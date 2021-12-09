import 'package:economize_combustivel/clients/user.dart';
import 'package:economize_combustivel/cubit/auth_cubit.dart';
import 'package:economize_combustivel/cubit/bottom_nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool done = false;

  final userClient = UserClient();

  bool isConfirmPasswordVisible = false;
  bool isPasswordVisible = false;
  bool isCreateAccount = false;
  bool isNameError = false;
  bool isPasswordError = false;
  bool isConfirmPasswordError = false;
  bool isEmailError = false;
  String submitError = "";

  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  void clearText() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() => isConfirmPasswordVisible = false);
    setState(() => isPasswordVisible = false);
  }

  void createAccount() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      userClient.createUser(userCredential.user!.uid, nameController.text);

      setState(() {
        submitError = "";
        done = true;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        setState(() {
          submitError = "Senha fraca";
        });
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        setState(() {
          submitError = "E-mail já cadastrado";
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        submitError = "Erro de rede!";
      });
    }
  }

  void login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      setState(() {
        submitError = "";
        done = true;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        setState(() {
          submitError = "Usuário não encontrado";
        });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        setState(() {
          submitError = "Senha incorreta";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (done) {
      BlocProvider.of<BottomNavCubit>(context).updateIndex(0);
    }
    if (BlocProvider.of<AuthCubit>(context).state.isLogged == true) {
      return const Center(
          child: Text(
        "Você já está logado!",
        style: TextStyle(fontSize: 20),
      ));
    }
    return Form(
      key: _form,
      child: Center(
        child: ListView(
          children: [
            isCreateAccount
                ? const SizedBox(height: 0)
                : const SizedBox(height: 28),
            SizedBox(
              height: isCreateAccount ? 50 : 0,
              child: SizedBox(
                child: isCreateAccount ? buildName() : const SizedBox.shrink(),
              ),
            ),
            SizedBox(height: isCreateAccount ? 10 : 0),
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
                textStyle: const TextStyle(
                  fontSize: 18,
                ),
              ),
              child:
                  isCreateAccount ? Text('Criar conta') : Text('Fazer login'),
              onPressed: () {
                _form.currentState!.validate();
                isCreateAccount ? createAccount() : login();
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
            submitError.isNotEmpty
                ? Text(
                    submitError,
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget buildName() => SizedBox(
        height: 50,
        child: TextFormField(
          controller: nameController,
          validator: (value) {
            setState(() => isNameError = false);
            if (value!.isEmpty) {
              setState(() => isNameError = true);
              return 'Campo obrigatório';
            }
          },
          decoration: InputDecoration(
            labelText: 'Nome',
            labelStyle: const TextStyle(color: Colors.white),
            contentPadding:
                const EdgeInsets.only(left: 0, right: 0, bottom: 15, top: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
            prefixIcon: const Icon(Ionicons.person, size: 20),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
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
