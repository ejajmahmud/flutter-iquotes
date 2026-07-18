import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qute_app/shared/components/components.dart';
import 'package:qute_app/shared/cubit/cubit.dart';
import 'package:qute_app/shared/cubit/states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
        if (kDebugMode) {
          print('Hello consumer in Quote Screen !!!!!------');
        }
      },
      builder: (BuildContext context, AppStates state){
        AppCubit cubit = AppCubit.get(context);
        var favorite = cubit.favoriteUserQuotes;
        if (state is AppGetDatabaseLoadingState ) {
          return Center(child: CircularProgressIndicator());
        }
        if (favorite.isEmpty) {
        return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 70, color: Colors.grey),
                Text(
                  'No favorite yet!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );}
          return Center(
            child: ListView.separated(
              itemBuilder:
                  (context, index) => buildQuoteItem(favorite[index] , context,QuoteScreenContext.favorites),
              separatorBuilder: (context, index) => SizedBox(height: 5.0),
              itemCount: favorite.length,
            ),
          );
        }
    );
  }
}
