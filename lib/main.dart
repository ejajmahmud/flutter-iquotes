import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qute_app/layout/home_layout_with_cubit.dart';
import 'package:qute_app/modules/archive/archived_screen.dart';
import 'package:qute_app/modules/init/welcome_screen.dart';
import 'package:qute_app/modules/login/sign_in_with_cubit.dart';
import 'package:qute_app/modules/register/register_with_cubit.dart';
import 'package:qute_app/modules/splash_screen/splash_screen.dart';
import 'package:qute_app/shared/cubit/cubit.dart';
import 'package:qute_app/shared/cubit/states.dart';
import 'package:qute_app/shared/network/local/cache_helper.dart';
import 'package:qute_app/shared/styles/bloc_observer.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer=MyBlocObserver();
 await CacheHelper.init();
bool? isDark=CacheHelper.getBoolean(key:'isDark');
 runApp( MyApp(isDark!));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  const MyApp( this.isDark, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (BuildContext providerContext)=>AppCubit()..loadUserQuotes()..changeAppMode(
        fromShared: isDark,
      ),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                  appBarTheme:AppBarTheme(
                    titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:22,
                    ),
                  ) ,
                  textTheme: TextTheme(
                    bodyLarge:TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                    bodyMedium: TextStyle(fontSize: 14,fontWeight:FontWeight.w400,color: Colors.black ),
                  ),
                  cardTheme: CardThemeData(
                    // color: Color.fromARGB(255, 232, 246, 246),
                      color: Color.fromARGB(255, 240, 246, 246),
                      // shadowColor: Colors.cyan[700],
                      surfaceTintColor: Colors.grey
                  ),
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
                  splashFactory: InkSplash.splashFactory,
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    // selectedI,temColor: Colors.cyan[700],
                    selectedItemColor: Colors.cyan[700],
                    // unselectedItemColor: Colors.grey,
                  ),


              ),
              darkTheme: ThemeData(
                // scaffoldBackgroundColor: Colors.grey[900],
                scaffoldBackgroundColor: HexColor('#0e1621'),
                // scaffoldBackgroundColor: HexColor('#244045'),
                //   scaffoldBackgroundColor: HexColor('#1a2f33'),
                appBarTheme:AppBarTheme(
                  backgroundColor: HexColor('#212728'),

                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                ) ,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                textTheme: TextTheme(
                  bodyLarge:TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                  bodyMedium: TextStyle(fontSize: 14,fontWeight:FontWeight.w400,color: Colors.white ),
                ),
                colorScheme: ColorScheme.fromSeed(seedColor: HexColor('#212728')),
                // colorScheme: ColorScheme.fromSeed(seedColor: HexColor('#0e1621')),
                splashFactory: InkSplash.splashFactory,
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  // selectedItemColor: Colors.cyan[700],
                  selectedItemColor: HexColor('#0097b2'),
                  backgroundColor:HexColor('#212728'),
                  unselectedItemColor: Colors.white,
                ),
                cardTheme: CardThemeData(
                  color: HexColor('#212728'),
                ),
                popupMenuTheme: PopupMenuThemeData(
                  color:  HexColor('#212728'),
                  textStyle: TextStyle(color: Colors.white),

                ),
                dialogTheme: DialogThemeData(
                  backgroundColor: HexColor('#212728'),
                ),
                bottomSheetTheme: BottomSheetThemeData(
                  backgroundColor: HexColor('#212728'),
                ),

              ),
              themeMode:AppCubit.get(context).isDark?ThemeMode.dark: ThemeMode.light,
              routes: {
                '/welcome':(context)=>WelcomeScreen(),
                '/register':(context)=>RegisterWithCubitScreen(),
                '/signIn':(context)=>SignInWithCubitScreen(),
                '/homelayout':(context)=>HomeLayoutWithCubit(),
                '/archived':(context)=>ArchivedScreen(),
              },
              home:BlocConsumer<AppCubit,AppStates>(
                listener: (BuildContext listenerContext,AppStates state) {
                  if (kDebugMode) {
                    print('Main BlocConsumer listener reacting to state: $state');
                  }
                },
                builder: (BuildContext cubitContext,AppStates state) {
                  if (kDebugMode) {
                    final userName=AppCubit.get(cubitContext).currentUser?.userName;
                    print('Main BlocBuilder reacting to state :$state,Current User:$userName');
                  }
                  if(state is AuthenticatedState){
                    return HomeLayoutWithCubit();
                  }
                  else if(state is AppInitialState ||
                      ( state is UserLoadingState && AppCubit.get(cubitContext).currentUser==null)){
                    return SplashScreen();
                  }
                  else if(state is UnauthenticatedState||state is AuthErrorState){
                    return WelcomeScreen();
                  }
                  if (kDebugMode) {
                    print('Main BlocConsumer fallback, current state: $state');
                  }
                  return HomeLayoutWithCubit();
                },)
          );
        },

      ),
    );
  }
  
}