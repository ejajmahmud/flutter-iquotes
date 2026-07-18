class UserModel {
  final int? userId;
  final String? userName;
  final String hashPassword;

  UserModel({this.userId, required this.userName, required this.hashPassword});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'password_hash': hashPassword,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] as int?,
      userName: map['user_name'] as String,
      hashPassword: map['password_hash'] as String,
    );
  }
}

class UserQuoteModel {
  final int? quoteId;
  final int userId; // Foreign key to User
  final String quoteText;
  final String? author;
  final bool isFavorite;
  final bool isArchived;

  UserQuoteModel({
    this.quoteId,
    required this.userId,
    required this.quoteText,
    required this.author,
    this.isFavorite = false,
    this.isArchived = false,
  });

  UserQuoteModel copyWith({
    int? quoteId,
    int? userId,
    String? quoteText,
    String? author,
    bool? isFavorite,
    bool? isArchived,
  }) {
    return UserQuoteModel(
      quoteId: quoteId ?? this.quoteId,
      userId: userId ?? this.userId,
      quoteText: quoteText ?? this.quoteText,
      author: author ?? this.author,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  factory UserQuoteModel.fromMap(Map<String, dynamic> map) {
    if(map['user_id']==null||map['quote_text']==null){
      throw FormatException("User ID or Quote text cannot be null from database.");
    }
    return UserQuoteModel(
      quoteId: map['quote_id'] as int?,
      userId: map['user_id'] as int,
      quoteText: map['quote_text'] as String,
      author: map['author'] as String?,
      isFavorite: (map['is_favorite'] as int?) == 1,
      isArchived: (map['is_archived'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quote_id': quoteId,
      'user_id': userId,
      'quote_text': quoteText,
      'author': author,
      'is_favorite': isFavorite ? 1 : 0,
      'is_archived': isArchived ? 1 : 0,
    };
  }
}
