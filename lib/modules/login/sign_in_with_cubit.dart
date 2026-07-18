import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qute_app/models/quote_model.dart';
import 'package:qute_app/modules/register/register_with_cubit.dart';
import 'package:qute_app/shared/components/components.dart';
import 'package:qute_app/shared/cubit/states.dart';

import '../../shared/cubit/cubit.dart';

class SignInWithCubitScreen extends StatefulWidget {

  const SignInWithCubitScreen({super.key});

  @override
  State<SignInWithCubitScreen> createState() => _SignInWithCubitScreenState();
}

class _SignInWithCubitScreenState extends State<SignInWithCubitScreen> {
  final GlobalKey<FormState> _formState = GlobalKey();

  // void initState() {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: ( context,  state) {},
        builder: ( context,  state) {
          AppCubit cubit=AppCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LogIn ',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 30.0),
                        defaultFormField(
                          type: TextInputType.text,
                          controller: cubit.nameController,
                          text: 'Name',
                          validate: (value) {
                            if (value.isEmpty) {
                              return "Name must not be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        defaultFormField(
                          type: TextInputType.visiblePassword,
                          controller: cubit.passController,
                          text: 'Password',
                          prefix: Icons.lock,
                          isPassword: cubit.isPassword,
                          suffix:
                              cubit.isPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                          suffixPressed: () {
                             cubit.passwordVisibility();
                          },
                          validate: (value) {
                            if (value.isEmpty && value == null) {
                              return 'Password must not be empty ';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30.0),
                        defaultButton(
                          function: () async {
                            if (_formState.currentState?.validate() ?? false) {
                              String enteredName = cubit.nameController.text;
                              String enteredPassword = cubit.passController.text;

                              try {
                                //1. Fetch user by userName
                                final UserModel? storedUser =await cubit.getUserName(enteredName);
                                if (storedUser == null) {
                                  //User not found
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Invalid username or password',
                                        ),
                                      ),
                                    );
                                  }
                                  return;
                                }
                                //2. User found ,now verify the password
                                // final UserModel user=storedUser!;
                                bool passwordMatches = BCrypt.checkpw(
                                  enteredPassword,
                                  storedUser.hashPassword,
                                ); // No '?' needed, directly access
                                if (passwordMatches) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Login successful!'),
                                      ),
                                    );
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/homelayout',
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Invalid username or password.',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (kDebugMode) {
                                  print('Error during login :$e');
                                }
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'An error occurred.Please try again.',
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          text: 'Login',
                        ),
                        txtButton(
                          txt: 'You do not have an account,',
                          txtBtn: 'Register',
                          onPressed: () {
                            cubit.nameController.clear();
                            cubit.passController.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterWithCubitScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
    );
  }
}
