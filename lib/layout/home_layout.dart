import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qute_app/modules/favorites/favorites_screen.dart';
import 'package:qute_app/quotes_sqflite.dart';
import 'package:qute_app/shared/components/components.dart';
import '../modules/quotes/quotes_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  QuotesDb quotesDb = QuotesDb();
  int currentIndex = 0;
  List<Widget> screens = [QuotesScreen(), FavoritesScreen()];
  List<Widget> titles = [
    Row(
      children: [
        Text(
          'i',
          style: TextStyle(
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        Text(
          'Quotes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.format_quote, color: Colors.cyan, size: 29.0),
      ],
    ),
    Row(
      children: [
        Text(
          'i',
          style: TextStyle(
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        Text(
          'Favorites',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.favorite_outline_sharp, color: Colors.cyan, size: 22.0),
      ],
    ),
  ];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon=Icons.edit;
  TextEditingController quoteController=TextEditingController();
  TextEditingController authorController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: titles[currentIndex],
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isBottomSheetShown) {
            if(formKey.currentState!.validate()){

              // UserQuoteModel quotes = UserQuoteModel(
              //   userId: ,
              //   quoteText: quoteController.text,
              //   author: authorController.text,
              // );
              // Map<String,dynamic> quoteMap=quotes.toMap();
              // int resultId=await quotesDb.insertModelDataQuotes('user_quotes', quoteMap);
              // if(resultId>0){
              //   if(kDebugMode){
              //     print('Quote inserted successfully with Id :$resultId');
              //   }
              // }
              Navigator.pop(context);
              isBottomSheetShown = false;
              setState(() {
                fabIcon=Icons.edit;

              });
            }
          } else {
            scaffoldKey.currentState?.showBottomSheet(
              (context) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultFormField(
                        controller: quoteController,
                          type: TextInputType.text,
                          text: 'Quote',
                        validate: (value){
                            if(value.isEmpty){
                              return 'Quote must not be empty';
                            }
                            return null;
                        },
                        prefix: Icons.format_quote,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        type: TextInputType.text,
                        text: 'Author',
                        validate: (value){
                          if(value.isEmpty){
                            return 'Author must not be empty';
                          }

                          return null;
                        }

                      ),
                    ],
                  ),
                ),
              ),
            );
            isBottomSheetShown = true;
            setState(() {
              fabIcon=Icons.add;
            });

          }

          // if(kDebugMode){
          //   print('Attempting to fetch users .....');
          //   try{
          //     List<Map<String,dynamic>> users=await quotesDb.getAllRows('users');
          //     if(users.isEmpty){
          //       print('No users found in the database');
          //     }else{
          //       print('The users are:');
          //       for(var userMap in users){
          //         print('Username:${userMap['user_name']},Password:${userMap['password_hash']}');
          //       }
          //     }
          //   }catch(e){
          //     print('Error fetching users :$e');
          //   }
          // }

          if (kDebugMode) {
            print('Attempting to fetch Quotes .....');
            try {
              List<Map<String, dynamic>> quote = await quotesDb.getAllRows(
                'user_quotes',
              );
              if (quote.isEmpty) {
                print('No quote found in the database');
              } else {
                print('The quote are:');
                for (var quoteMap in quote) {
                  print(
                    'quote:${quoteMap['quote_text']},author:${quoteMap['author']}',
                  );
                }
              }
            } catch (e) {
              print('Error fetching quotes :$e');
            }
          }
        },
        shape: StadiumBorder(),
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 20.0,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.format_quote),
            icon: Icon(Icons.format_quote_outlined),
            label: 'Quotes',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline),
            label: 'Favorites',
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
