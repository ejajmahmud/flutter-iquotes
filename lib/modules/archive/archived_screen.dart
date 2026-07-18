import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      AppCubit.get(context).loadUserQuotes();
    });
      // BlocConsumer<AppCubit, AppStates>(
    AppCubit cubit = AppCubit.get(context);

 return Scaffold(
            appBar: AppBar(
              elevation: 2,
              title: Row(
                children: [
                  Text(
                    'i',
                    style: TextStyle(
                      color: Colors.cyan[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  Text(
                    'Archive',
                    style:
                    cubit.isDark
                        ? TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        : TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  // Icon(Icons.archive, color: Colors.cyan, size:20.0),
                ],
              ),
            ),
            body: BlocConsumer<AppCubit,AppStates>(
                listener: (context, state) {
                  if (kDebugMode) {
                    print('Hello consumer in Archived:$state !!!!!------');
                  }
                },
                builder: (BuildContext context, AppStates state) {
                  var archived = cubit.archivedUserQuotes;
                  if (state is AppGetDatabaseLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (archived.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.archive_outlined, size: 80, color: Colors.grey),
                          Text(
                            'No Archive yet!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
              return Center(
                child: ListView.separated(
                  itemBuilder:
                      (context, index) =>
                          buildQuoteItem(archived[index], context,QuoteScreenContext.archived),
                  separatorBuilder: (context, index) => SizedBox(height: 5.0),
                  itemCount: archived.length,
                ),
              );}
            )
          );
        }
  }
