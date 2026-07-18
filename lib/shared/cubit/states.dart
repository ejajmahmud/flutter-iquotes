import 'package:qute_app/models/quote_model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class UserLoadingState extends AppStates {}

class AuthenticatedState extends AppStates {
  AuthenticatedState(user);
}

class AuthErrorState extends AppStates {
  AuthErrorState(String error);
}

class UnauthenticatedState extends AppStates {}

class UserNotFoundState extends AppStates {}

class UserExistState extends AppStates {}

class UserNotExistState extends AppStates {}

class InsertUserState extends AppStates {}

class UserErrorState extends AppStates {
  UserErrorState(error);
}

class PasswordVisibilityState extends AppStates {}

class ChangeBottomNavBarState extends AppStates {}

class ChangeBottomSheetState extends AppStates {}

class InsertQuotesState extends AppStates {}

class AppGetDatabaseLoadingState extends AppStates {}

class AppGetDatabaseState extends AppStates {}

class AppDatabaseErrorState extends AppStates {
  final String error;

  AppDatabaseErrorState(this.error);
}

class FavouriteShownState extends AppStates {}

class ArchiveShownState extends AppStates {}

class QuoteErrorState extends AppStates {
  QuoteErrorState(error);
}

class QuoteEditStartedState extends AppStates{
  UserQuoteModel quote;
  QuoteEditStartedState(this.quote);
}

class QuoteEditCancelledState extends AppStates{}

class QuoteUpdateSuccessfulState extends AppStates{}

class AccountDeletionInProgressState extends AppStates{}

class AccountDeletionFailureState extends AppStates{
  String error;
  AccountDeletionFailureState(this.error);
}

class QuoteAppChangeModeState extends AppStates{}

class QuoteSuccessfulState extends AppStates{}

