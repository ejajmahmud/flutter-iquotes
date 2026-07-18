import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qute_app/models/quote_model.dart';
import 'package:qute_app/shared/cubit/cubit.dart';
import 'package:qute_app/shared/cubit/states.dart';
import '../../shared/components/components.dart';

// import 'package:sqflite/sqflite.dart';

class RegisterWithCubitScreen extends StatefulWidget {
  // IF THAT DOSE NOT WORK I WILL REPUT IT AS BEFORE AS STATELESSWIDGET

  const RegisterWithCubitScreen({super.key});

  @override
  State<RegisterWithCubitScreen> createState() =>
      _RegisterWithCubitScreenState();
}

class _RegisterWithCubitScreenState extends State<RegisterWithCubitScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
  );

  // void dispose(){
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 30.0),
                      defaultFormField(
                        type: TextInputType.text,
                        controller: cubit.nameController,
                        text: 'Name',
                        validate: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Name must not be empty !';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      defaultFormField(
                        controller: cubit.passController,
                        text: 'Password',
                        type: TextInputType.visiblePassword,
                        suffix:
                            cubit.isPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                        isPassword: cubit.isPassword,
                        suffixPressed: () {
                          cubit.passwordVisibility();
                        },
                        prefix: Icons.lock,
                        validate: (value) {
                          if (value.isEmpty || value == null) {
                            return 'Password must not be empty';
                          } else if (!passwordRegex.hasMatch(value)) {
                            return 'Password must be at least 8+ chars,letters & digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30.0),

                      defaultButton(
                        function: () async {
                          if (kDebugMode) {
                            print('====================OnButton Pressed');
                          }
                          if (_formKey.currentState?.validate() ?? false) {
                            String currentUsername = cubit.nameController.text;
                            bool usernameExists = await cubit.userNameExist(
                              currentUsername,
                            );
                            if (usernameExists) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'UserName"$currentUsername" is already taken. Please choose another',
                                    ),
                                    // backgroundColor: Colors.purpleAccent[100],
                                  ),
                                );
                              }
                              return;
                            }
                            try {
                              // --- Hashing Steps ---
                              final String hashedPassword = BCrypt.hashpw(
                                cubit.passController.text,
                                BCrypt.gensalt(),
                              );
                              UserModel newUser = UserModel(
                                userName: currentUsername,
                                hashPassword: hashedPassword,
                              );
                              Map<String, dynamic> userMap = newUser.toMap();
                              int? resultId = await cubit.insertUsers(
                                'users',
                                userMap,
                              );
                              if (resultId != 0 && resultId != -1) {
                                if (kDebugMode) {
                                  print(
                                    'User inserted successfully with ID:$resultId',
                                  );
                                }
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Registration successful !',
                                      ),
                                    ),
                                  );
                                  // Navigator.pushReplacementNamed(context, '/homelayout');
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/homelayout',
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              } else {
                                if (kDebugMode) {
                                  print('Failed to insert user !');
                                }
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        usernameExists
                                            ? 'Username "$currentUsername" is already taken.'
                                            : 'Registration failed. Please try again ',
                                      ),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                print('Error inserting user :$e');
                              }
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'An error occurred during registration.',
                                    ),
                                  ),
                                );
                              }
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please correct the error in the form.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        text: 'Register',
                      ),
                      txtButton(
                        txt: 'You already have an account,',
                        txtBtn: 'Sign In',
                        onPressed: () {
                          cubit.nameController.clear();
                          cubit.passController.clear();
                          Navigator.pushNamed(context, '/signIn');
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
