import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qute_app/shared/components/constants.dart';
import 'package:qute_app/shared/cubit/states.dart';
import 'package:qute_app/shared/network/local/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/quote_model.dart';
import '../../modules/favorites/favorites_screen.dart';
import '../../modules/quotes/quotes_screen.dart';
import '../../quotes_sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  UserModel? currentUser;

  UserModel? get currentUsers => currentUser;

  late TextEditingController nameController = TextEditingController();
  late TextEditingController passController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;
  late QuotesDb quotesDb;

  int currentIndex = 0;
  final List<Widget> screens = [QuotesScreen(), FavoritesScreen()];

  List<Widget> get titles => [
    Row(
      children: [
        // Container(
        //   width: 30,
        //   height: 30,
        //   child: Image.asset('images/logo_quote.png'),
        // )
        Text(
          'i',
          style: TextStyle(
            color: Colors.cyan[700],
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        Text(
          'Quotes',
          style:
              isDark
                  ? TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                  : TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.format_quote, color: Colors.cyan[700], size: 29.0),
      ],
    ),
    Row(
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
          'Favorites',
          style:
          isDark
              ? TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              : TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.favorite, color: Colors.cyan[700], size: 22.0),
      ],
    ),
  ];

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  TextEditingController quoteController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  List<UserQuoteModel> allUserQuotes = [];
  List<UserQuoteModel> favoriteUserQuotes = [];
  List<UserQuoteModel> archivedUserQuotes = [];
  List<UserQuoteModel> displayedQuotes = [];
  UserQuoteModel? quoteBeingEdited;

  bool get isEditingQuote => quoteBeingEdited != null;

  AppCubit() : super(AppInitialState()) {
    quotesDb = QuotesDb();
    _tryAutoLogin();
  }

  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }

  void startEditingQuote(UserQuoteModel quoteToEdite) {
    quoteBeingEdited = quoteToEdite;
    quoteController.text = quoteToEdite.quoteText;
    authorController.text = quoteToEdite.author ?? '';

    if (!isBottomSheetShown) {
      changeBottomSheetState(isShow: true, icon: Icons.save);
      emit(QuoteEditStartedState(quoteToEdite));
    } else {
      fabIcon = Icons.save;
      emit(ChangeBottomSheetState());
    }
  }

  Future<void> _tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('current_user_id');
    if (kDebugMode) {
      print('READING User ID from prefs:$userId');
    }

    if (userId != null) {
      emit(UserLoadingState());
      if (kDebugMode) {
        print(
          'Attempting to fetch user with ID: $userId from DB for auto-login',
        );
      }
      UserModel? userFromDb = await quotesDb.getUserById(userId);
      if (kDebugMode) {
        print('User fetched for auto-login: ${userFromDb?.userName}');
      }
      if (userFromDb != null) {
        currentUser = userFromDb;
        await loadUserQuotes();
        emit(AuthenticatedState(currentUser!));
      } else {
        await prefs.remove('current_user_id');
        emit(UnauthenticatedState());
      }
    } else {
      emit(UnauthenticatedState());
    }
  }

  void cancelEditQuote() {
    quoteBeingEdited = null;
    quoteController.clear();
    authorController.clear();
    if (isBottomSheetShown) {
      changeBottomSheetState(isShow: false, icon: Icons.edit);
    }
    emit(QuoteEditCancelledState());
  }

  Future<void> saveUpdatedQuote() async {
    if (quoteBeingEdited == null || quoteBeingEdited!.quoteId == null) {
      emit(QuoteErrorState('No quote selected for update.'));
      return;
    }
    if (currentUser == null || currentUser!.userId == null) {
      emit(QuoteErrorState('User not logged in .Cannot update the quote.'));
      return;
    }

    final String updatedText = quoteController.text;
    final String updatedAuthor = authorController.text;

    UserQuoteModel updatedQuote = quoteBeingEdited!.copyWith(
      quoteText: updatedText,
      author: updatedAuthor,
    );

    try {
      int result = await quotesDb.updateUserQuote(updatedQuote);
      if (result > 0) {
        if (kDebugMode) {
          print('Quote update successfully : ID${updatedQuote.quoteId}');
        }
        await loadUserQuotes();
        quoteBeingEdited = null;
        emit(QuoteUpdateSuccessfulState());
      } else {
        emit(
          QuoteErrorState(
            'Failed to update quote in database. Quote ID${updatedQuote.quoteId}',
          ),
        );
      }
    } catch (e) {
      emit(QuoteErrorState('Error updating quote :${e.toString()}'));
    }
  }

  Future<bool> userNameExist(String userName) async {
    try {
      bool isExist = await quotesDb.doesUserNameExist(userName);
      if (isExist) {
        emit(UserExistState());
      } else {
        emit(UserNotExistState());
      }
      return isExist;
    } catch (e) {
      if (kDebugMode) {
        print('Error in cubit.nameExist :$e');
        emit(UserErrorState(e.toString()));
      }
      return false;
    }
  }

  Future<int?> insertUsers(String table, Map<String, dynamic> data) async {
    try {
      int result = await quotesDb.insertModelData(table, data);
      if (result > 0) {
        UserModel? registeredUser = await quotesDb.getUserById(result);
        if (registeredUser != null && registeredUser.userId != null) {
          currentUser = registeredUser;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('current_user_id', registeredUser.userId!);
          await loadUserQuotes();
          emit(AuthenticatedState(registeredUser));
        } else {
          emit(
            AuthErrorState(
              'Registration Successful but failed to retrieve user details.',
            ),
          );
        }
        emit(InsertUserState());
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error in a cubit insertUsers:$e');
        emit(UserErrorState(e.toString()));
        return 0;
      }
    }
    return null;
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
    currentUser = null;
    allUserQuotes.clear();
    favoriteUserQuotes.clear();
    displayedQuotes.clear();
    archivedUserQuotes.clear();
    emit(UnauthenticatedState());
  }

  Future<UserModel?> getUserName(String enteredName) async {
    try {
      emit(UserLoadingState());
      final UserModel? user = await quotesDb.getUserByUsername(enteredName);
      if (user != null) {
        if (user.userId != null) {
          currentUser = user;
          final prefs = await SharedPreferences.getInstance();
          if (kDebugMode) {
            print('SAVING User ID :${user.userId}');
          }
          await prefs.setInt('current_user_id', user.userId!);

          await loadUserQuotes();
          emit(AuthenticatedState(user));
        }
        emit(UserLoadingState());
      } else {
        emit(UserNotFoundState());
      }
      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Error in cubit's getUserName :$e");
        emit(UserErrorState(e.toString()));
      }
      return null;
    }
  }

  void passwordVisibility() {
    isPassword = !isPassword;
    emit(PasswordVisibilityState());
  }

  Future<void> toggleFavoriteStatus(UserQuoteModel quoteToToggle) async {
    if (currentUser == null || currentUser!.userId == null) {
      emit(
        QuoteErrorState('Cannot toggle favorite: User or Quote ID missing.'),
      );
      return;
    }
    UserQuoteModel updatedQuote = quoteToToggle.copyWith(
      isFavorite: !quoteToToggle.isFavorite,
    );
    try {
      int result = await quotesDb.updateUserQuote(updatedQuote);

      if (result > 0) {
        await loadUserQuotes();
        // emit(QuoteFavoriteToggledState(updatedQuote.quoteId!, updatedQuote.isFavorite));
      } else {
        emit(QuoteErrorState('Failed to update favorite status in DB.'));
      }
    } catch (e) {
      emit(QuoteErrorState('Error toggling favorite:${e.toString()}'));
    }
  }

  Future <void> toggleArchivedStatus(UserQuoteModel quoteToToggle)async{
    if(currentUser==null || currentUser!.userId==null){
      emit(QuoteErrorState('Cannot toggle archive : User or Quote ID missing.'));
      return ;
    }

    final originalIsArchived=quoteToToggle.isArchived;
    final quoteId=quoteToToggle.quoteId;
    if(originalIsArchived){
      archivedUserQuotes.removeWhere((q)=>q.quoteId==quoteId);
    }else{
      quotes.removeWhere((q)=>q.quoteId==quoteId);
    }
    int quoteIndexInAll=allUserQuotes.indexWhere((q)=>q.quoteId==quoteId);
    if(quoteIndexInAll!=-1){
      allUserQuotes[quoteIndexInAll]=allUserQuotes[quoteIndexInAll].copyWith(isArchived: !originalIsArchived);
    }
    emit(QuoteSuccessfulState());
    UserQuoteModel updatedQuote = quoteToToggle.copyWith(
      isArchived: !originalIsArchived,
    );
    try{
      int result=await quotesDb.updateUserQuote(updatedQuote);
      if(result>0){
        await loadUserQuotes();
      }else{
        emit(QuoteErrorState('Failed to update archive status in DB.'));
        await loadUserQuotes();
      }
    }catch (e){
      emit(QuoteErrorState('Error toggling archive : ${e.toString()}'));

      await loadUserQuotes();
    }

  }



  // toggleArchiveStatus ------- //
  Future<void> toggleArchiveStatus(UserQuoteModel quoteToToggle) async {
    if (currentUser == null || currentUser!.userId == null) {
      emit(QuoteErrorState('Cannot toggle archive: User or Quote ID missing.'));
      return;
    }
    UserQuoteModel updatedQuote = quoteToToggle.copyWith(
      isArchived: !quoteToToggle.isArchived,
    );
    try {
      int result = await quotesDb.updateUserQuote(updatedQuote);
      if (result > 0) {
        await loadUserQuotes();
      } else {
        emit(QuoteErrorState('Failed to update archive status in DB.'));
      }
    } catch (e) {
      emit(QuoteErrorState('Error toggling archive :${e.toString()}'));
    }
  }

  Future<void> addQuote(String table, Map<String, dynamic> data) async {
    if (currentUser == null || currentUser!.userId == null) {
      emit(QuoteErrorState('User not logged in . Cannot add quote.'));
      return;
    }
    try {
      int resultId = await quotesDb.insertModelDataQuotes(table, data);
      if (resultId > 0) {
        if (kDebugMode) {
          print('Quote inserted successfully with Id :$resultId');
          await loadUserQuotes();
        }
      } else {
        emit(QuoteErrorState('Failed to insert quote into database.'));
      }
    } catch (e) {
      emit(QuoteErrorState('Error adding quote :${e.toString()}'));
    }
  }

  Future<void> loadUserQuotes() async {
    emit(AppGetDatabaseLoadingState());
    if (currentUser == null || currentUser!.userId == null) {
      allUserQuotes.clear();
      favoriteUserQuotes.clear();
      archivedUserQuotes.clear();
      displayedQuotes.clear();
      emit(AppGetDatabaseState());
      return;
    }
    emit(AppGetDatabaseLoadingState());
    try {
      final List<Map<String, dynamic>> rawQuotes = await quotesDb
          .getQuotesByUserId(currentUser!.userId!);
      allUserQuotes =
          rawQuotes.map((map) => UserQuoteModel.fromMap(map)).toList();
      favoriteUserQuotes =
          allUserQuotes
              .where(
                (quote) => quote.isFavorite == true && quote.isArchived != true,
              )
              .toList();
      archivedUserQuotes =
          allUserQuotes
              .where(
                (quote) => quote.isArchived == true && quote.isFavorite != true,
              )
              .toList();
      displayedQuotes =
          allUserQuotes.where((quote) => quote.isArchived != true).toList();
      emit(QuoteSuccessfulState());
      if (kDebugMode) {
        print(
          'CUBIT loadUserQuotes:All :${allUserQuotes.length},displayed:${displayedQuotes.length},Favorites:${favoriteUserQuotes.length},Archived:${archivedUserQuotes.length}',
        );
      }
      emit(AppGetDatabaseState());
    } catch (e, s) {
      if (kDebugMode) {
        print('Error loading user quotes from DB:$e');
        print('Stacktrace:$s');
      }
      emit(AppDatabaseErrorState(e.toString()));
    }
  }

  Future<void> removeQuote(UserQuoteModel quoteToDelete) async {
    if (currentUser == null || currentUser!.userId == null) {
      emit(QuoteErrorState('Cannot delete quote:User or Quote ID missing.'));
      return;
    }
    if (quoteToDelete.userId != currentUser!.userId) {
      emit(QuoteErrorState('Unauthorized attempt to delete quote.'));
      return;
    }
    try {
      int result = await quotesDb.deleteUserQuote(quoteToDelete);

      if (result > 0) {
        if (kDebugMode) {
          print('Quote deleted successfully:ID${quoteToDelete.quoteId}');
        }
        await loadUserQuotes();
      } else {
        emit(
          QuoteErrorState(
            'Failed to delete quote from database.It might have already been removed',
          ),
        );
      }
    } catch (e) {
      emit(QuoteErrorState('Error deleting quote: ${e.toString()}'));
    }
  }

  Future<void> deleteCurrentUserAccount() async {
    try {
      emit(AccountDeletionInProgressState());
      if (currentUser == null) {
        emit(AccountDeletionFailureState('No authenticated user to delete.'));
        return;
      }
      await quotesDb.deleteUser(currentUser as int);
    } catch (e, s) {
      if (kDebugMode) {
        print('Error deleting user account: $e');
        print(s);
      }
      emit(
        AccountDeletionFailureState(
          'Failed to delete account: ${e.toString()}',
        ),
      );
    }
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if(fromShared!=null) {
      isDark=fromShared;
    } else {
      isDark = !isDark;
    }
    CacheHelper.putBoolean(key: 'isDark',value: isDark).then((value){
      emit(QuoteAppChangeModeState());
    });


  }
}
