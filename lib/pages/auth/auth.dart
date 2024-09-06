import 'package:dundermifflinapp/core/configs/theme/app_colors.dart';
import 'package:dundermifflinapp/pages/home/Home.dart';
import 'package:dundermifflinapp/components/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/helpers/validators.dart';
import '../../api/auth_bloc.dart';
import 'dart:developer';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            log('AuthState: $state');
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (state is AuthFailure) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Dados de Acesso incorretos'),
                    content: const Text(
                      'Os dados de acesso não estão corretos. Caso não esteja conseguindo acessar sua conta, selecione a opção Esqueci minha senha.',
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          emailController.clear();
                          passwordController.clear();

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBase,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Preencher dados novamente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const LoadingScreen();
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0).copyWith(top: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 83.46,
                          child: Image.asset('assets/splash.png'),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 282.94,
                          height: 230.08,
                          child: Image.asset('assets/splash2.png'),
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryBase),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryBase),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                emailController.clear();
                              },
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            return ValidatorsAuth.validateEmail(value);
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              emailController.text = value.toLowerCase();
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryBase),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryBase),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      passwordController.clear();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            return ValidatorsAuth.validatePassword(value);
                          },
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              BlocProvider.of<AuthBloc>(context).add(
                                AuthRequested(
                                  emailController.text,
                                  passwordController.text,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBase,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Acessar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
