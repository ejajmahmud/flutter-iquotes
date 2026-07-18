import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qute_app/shared/components/components.dart';
import 'package:qute_app/shared/cubit/cubit.dart';
import 'package:qute_app/shared/cubit/states.dart';

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context,AppStates state) {
        if (kDebugMode) {
          print('Hello consumer in Quote Screen !!!!!------');
        }
      },
      builder: (BuildContext context,AppStates state) {
        if(kDebugMode){
          print('Builder in Qute Screen ====================. ');
        }
        AppCubit cubit = AppCubit.get(context);
        var quotes = cubit.displayedQuotes;
        if (state is AppGetDatabaseLoadingState ) {
          return Center(child: CircularProgressIndicator());
        }
        if (quotes.isEmpty) {
          return  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child:cubit.isDark?Image.asset(
                      'images/logo_darkmode.png'
                  ):
                  Image.asset(
                    'images/logo_quote.png'
                  ),
                ),
                Text(
                  'No quotes yet!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Center(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final quote=quotes[index];
              return QuoteListItem(
                key: ValueKey<String>(quote.quoteId.toString()),
                quoteModel: quote,
                parentContext: context,
               screenContext:  QuoteScreenContext.quotes
            );
            },
            separatorBuilder: (context, index) => SizedBox(height: 5),
            itemCount: quotes.length,
          ),
        );
      },
    );

  }
}
