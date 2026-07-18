import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qute_app/models/quote_model.dart';
import 'package:qute_app/shared/cubit/cubit.dart';

// Widget DefaultButton({
//   double width = double.infinity,
//   Color background = Colors.cyan,
//   required String title,
//   required VoidCallback onPressed,
//   double elevate = 5.0,
// }) => Container(
//   width: width,
//   padding: EdgeInsets.all(10.0),
//   child: MaterialButton(
//     hoverColor: Colors.grey,
//     onPressed: () {
//       onPressed;
//     },
//
//     // color: Colors.blue,
//     child: Text(title, style: TextStyle(color: Colors.white, fontSize: 15.0)),
//   ),
// );

Widget defaultButton({
  double width = double.infinity,
  // Color background = Colors.cyan[700],
  bool isUppercase = true,
  required VoidCallback function,
  required String text,
}) => Padding(
  padding: const EdgeInsets.all(10.0),
  child: Container(
    padding: EdgeInsets.only(top: 3, left: 3),
    width: width,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.black),
        left: BorderSide(color: Colors.black),
        right: BorderSide(color: Colors.black),
        top: BorderSide(color: Colors.black),
      ),
      borderRadius: BorderRadius.circular(50.0),
    ),

    child: MaterialButton(
      color: Colors.cyan[700],
      minWidth: double.infinity,
      height: 55.0,
      elevation: 0.0,
      onPressed: function,
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Text(
        isUppercase ? text.toUpperCase() : text,
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
);

Widget defaultFormField({
  TextEditingController? controller,
  required TextInputType type,
  required String? text,
  TextStyle? textStyle,
  ValueChanged? onSubmite,
  ValueChanged? onChange,
  FormFieldValidator? validate,
  IconData? prefix,
  IconData? suffix,
  bool isPassword = false,
  VoidCallback? suffixPressed,
}) => Padding(
  padding: const EdgeInsets.all(10.0),
  child: TextFormField(
    controller: controller,
    obscureText: isPassword,
    keyboardType: type,
    onFieldSubmitted: onSubmite,
    onChanged: onChange,
    validator: validate,
    decoration: InputDecoration(
      labelText: text,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      suffixIcon:
          suffix != null
              ? IconButton(icon: Icon(suffix), onPressed: suffixPressed)
              : null,
      prefixIcon: Icon(prefix),
    ),
  ),
);

Widget txtButton({
  required String txt,
  required String txtBtn,
  required VoidCallback onPressed,
  FontWeight fontWeight = FontWeight.bold,
}) => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(txt, style: TextStyle(fontWeight: FontWeight.bold)),
    TextButton(
      onPressed: onPressed,
      child: Text(txtBtn, style: TextStyle(fontWeight: fontWeight)),
    ),
  ],
);

Widget buildQuoteItems(UserQuoteModel quoteModel, context) {
  // var scaffoldKey = GlobalKey<ScaffoldState>();
  // var formKey = GlobalKey<FormState>();

  AppCubit cubit = AppCubit.get(context);
  return Dismissible(
    key: Key(quoteModel.quoteId.toString()),
    background: Container(
      color: Colors.black87,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(Icons.unarchive, color: Colors.white60),
    ),
    secondaryBackground: Container(
      color: Colors.cyan[700],
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(Icons.archive, color: Colors.white60),
    ),

    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        // elevation: 0.0,
        // margin: EdgeInsets.all(2.0),
        // surfaceTintColor: Colors.white60,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12.0),
        // ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular((12.0))),
              child: Image.asset(
                'images/card_design.png',
                width: double.infinity,
                height: null,
                // fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    quoteModel.quoteText,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  dense: true,
                  subtitle: Text(
                    quoteModel.author ?? 'UnKnown author',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  isThreeLine: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Favorites Icon ---------
                    IconButton(
                      onPressed: () {
                        cubit.toggleFavoriteStatus(quoteModel);
                      },
                      icon:
                          quoteModel.isFavorite
                              ? Icon(Icons.favorite, color: Colors.cyan[700])
                              : Icon(Icons.favorite_border),
                    ),
                    // For Edit
                    IconButton(
                      onPressed: () async {
                        cubit.startEditingQuote(quoteModel);
                        // final GlobalKey<FormState> bottomSheetFormKey=GlobalKey<FormState>();
                        cubit.scaffoldKey.currentState?.showBottomSheet(
                          (context) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Form(
                              key: cubit.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: cubit.quoteController,
                                    type: TextInputType.text,
                                    text: 'Quote',
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Quote must not be empty';
                                      }
                                      return null;
                                    },
                                    prefix: Icons.format_quote,
                                  ),
                                  const SizedBox(height: 15.0),
                                  defaultFormField(
                                    type: TextInputType.text,
                                    controller: cubit.authorController,
                                    text: 'Author',
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Author must not be empty';
                                      }
                                      return null;
                                    },
                                    prefix: Icons.person,
                                  ),
                                  // const SizedBox(
                                  //   height: 20.0,
                                  // ),
                                  // ElevatedButton(
                                  //   onPressed: (){
                                  //     if(cubit.formKey.currentState?.validate()??false){
                                  //       cubit.startEditingQuote(quoteModel);
                                  //       Navigator.pop(context);
                                  //     }
                                  //   }, child: const Text('Save Changes'),
                                  // ),
                                  // const SizedBox(
                                  //   height: 10.0,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                        if (cubit.isBottomSheetShown) {
                          if (cubit.formKey.currentState!.validate()) {
                            if (kDebugMode) {
                              print(
                                'Update Icon onPressed =============-----------==. ',
                              );
                            }
                            cubit.changeBottomSheetState(
                              isShow: false,
                              icon: Icons.edit,
                            );

                            cubit.quoteController.clear();
                            cubit.authorController.clear();
                            if (!cubit.isBottomSheetShown) {}
                          }
                        }
                      },
                      icon: Icon(Icons.edit),
                    ),
                    // Delete Icon
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, quoteModel);
                      },
                      icon: Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    confirmDismiss: (direction) async {
      if (quoteModel.isFavorite != true) {
        if (direction == DismissDirection.endToStart) {
          return true;
        } else if (direction == DismissDirection.startToEnd) {
          return false;
        }
        return false;
      }
      return null;
    },
    onDismissed: (direction) {
      cubit.toggleArchiveStatus(quoteModel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            quoteModel.isArchived
                ? "'${quoteModel.quoteText}'unarchived"
                : "'${quoteModel.quoteText}'archived",
          ),
        ),
      );
    },
  );
}

Widget buildArchivedItems(UserQuoteModel quoteModel, context) {
  AppCubit cubit = AppCubit.get(context);
  return Dismissible(
    key: Key(quoteModel.quoteId.toString()),
    background: Container(
      color: Colors.black87,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(Icons.unarchive, color: Colors.white60),
    ),
    secondaryBackground: Container(
      color: Colors.cyan[700],
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(Icons.archive, color: Colors.white60),
    ),

    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        surfaceTintColor: Colors.white60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular((12.0))),
              child: Image.asset(
                'images/card_design.png',
                width: double.infinity,
                height: null,
                // fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    quoteModel.quoteText,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  dense: true,
                  subtitle: Text(
                    quoteModel.author ?? 'UnKnown author',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  isThreeLine: true,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Delete
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, quoteModel);
                  },
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    confirmDismiss: (direction) async {
      if (direction == DismissDirection.startToEnd) {
        return true;
      }
      return false;
    },
    onDismissed: (direction) {
      cubit.toggleArchiveStatus(quoteModel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            quoteModel.isArchived
                ? "'${quoteModel.quoteText}'unarchived"
                : "'${quoteModel.quoteText}'archived",
          ),
        ),
      );
    },
  );
}

Widget buildFavoritesItems(UserQuoteModel quoteModel, context) {
  // var scaffoldKey = GlobalKey<ScaffoldState>();
  // var formKey = GlobalKey<FormState>();

  AppCubit cubit = AppCubit.get(context);
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Card(
      surfaceTintColor: Colors.white60,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12.0),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular((12.0))),
            child:
                cubit.isDark
                    ? Image.asset(
                      'images/cover_design.png',
                      width: double.infinity,
                      height: null,
                      // fit: BoxFit.cover,
                    )
                    : Image.asset(
                      'images/card_design.png',
                      width: double.infinity,
                      height: null,
                      // fit: BoxFit.cover,
                    ),
          ),
          Column(
            children: [
              ListTile(
                title: Text(
                  quoteModel.quoteText,
                  // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                dense: true,
                subtitle: Text(
                  quoteModel.author ?? 'UnKnown author',
                  // style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                isThreeLine: true,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  cubit.toggleFavoriteStatus(quoteModel);
                },
                icon:
                    quoteModel.isFavorite
                        ? Icon(Icons.favorite, color: Colors.cyan[700])
                        : Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () async {
                  cubit.startEditingQuote(quoteModel);
                  cubit.scaffoldKey.currentState?.showBottomSheet(
                    (context) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              controller: cubit.quoteController,
                              type: TextInputType.text,
                              text: 'Quote',
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'Quote must not be empty';
                                }
                                return null;
                              },
                              prefix: Icons.format_quote,
                            ),
                            SizedBox(height: 15.0),
                            defaultFormField(
                              type: TextInputType.text,
                              controller: cubit.authorController,
                              text: 'Author',
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'Author must not be empty';
                                }
                                return null;
                              },
                              prefix: Icons.person,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  if (cubit.isBottomSheetShown) {
                    if (cubit.formKey.currentState!.validate()) {
                      if (kDebugMode) {
                        print(
                          'Update Icon onPressed =============-----------==. ',
                        );
                      }
                      cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                      );

                      cubit.quoteController.clear();
                      cubit.authorController.clear();
                      if (!cubit.isBottomSheetShown) {}
                    }
                  }
                },
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context, quoteModel);
                },
                icon: Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<void> _showDeleteConfirmationDialog(
  BuildContext context,
  UserQuoteModel quoteModel,
) async {
  AppCubit cubit = AppCubit.get(context);

  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          'Confirm Delete',
          style:
              cubit.isDark
                  ? TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
                  : TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Are you sure you want to delete?!'),
              Text('This action cannot to undone.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cubit.removeQuote(quoteModel);
              Navigator.of(dialogContext).pop();
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}

enum QuoteScreenContext { quotes, favorites, archived }

class QuoteListItem extends StatefulWidget {
  final UserQuoteModel quoteModel;
  final BuildContext parentContext;
  final QuoteScreenContext screenContext;

  const QuoteListItem({
    Key? key,
    required this.quoteModel,
    required this.parentContext,
    required this.screenContext,
}):super(key: key);
  @override
  _QuoteListItemState createState()=>_QuoteListItemState();
}
class _QuoteListItemState extends State<QuoteListItem>{
  bool _isLocallyDismissed=false;

  @override
  Widget build(BuildContext context){
    if(_isLocallyDismissed){
      return SizedBox.shrink();
    }
    AppCubit cubit =AppCubit.get(widget.parentContext);
    bool allowArchiveSwipe =
        widget.screenContext == QuoteScreenContext.quotes && !widget.quoteModel.isFavorite;
    bool allowUnarchiveSwipe =
        widget.screenContext == QuoteScreenContext.archived && widget.quoteModel.isArchived;
    bool showFavoriteAndEditeIcons = widget.screenContext != QuoteScreenContext.archived;

    return Dismissible(
      key: ValueKey<String>(widget.quoteModel.quoteId.toString()),
      background:
      (allowUnarchiveSwipe)
          ? Container(
        color: Colors.black87,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.unarchive, color: Colors.white60),
      )
          : (allowArchiveSwipe)
          ? Container(color: Colors.transparent)
          : null,

      secondaryBackground:
      (allowArchiveSwipe)
          ? Container(
        color: Colors.cyan[700],
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.archive, color: Colors.white60),
      )
          : null,

      // confirmDismiss: (direction) async {
      //   // if (quoteModel.isFavorite != true) {
      //   //   if (!enableSwiping&&quoteModel.isFavorite!=true) return false;
      //   if (direction == DismissDirection.endToStart && allowArchiveSwipe) {
      //     return true;
      //   } else if (direction == DismissDirection.startToEnd &&
      //       allowUnarchiveSwipe) {
      //     return true;
      //     // if(screenContext==QuoteScreenContext.archived&&quoteModel.isArchived){
      //     //   return true;
      //     // }
      //   }
      //   return false;
      // },
      // onDismissed: (direction) {
      //   // if(!enableSwiping)return;
      //   // if(screenContext==QuoteScreenContext.quotes)
      //   if (direction == DismissDirection.endToStart && allowArchiveSwipe) {
      //     cubit.toggleArchiveStatus(quoteModel);
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(
      //           quoteModel.isArchived
      //               ? "'${quoteModel.quoteText}'unarchived"
      //               : "'${quoteModel.quoteText}'archived",
      //         ),
      //       ),
      //     );
      //   } else if (direction == DismissDirection.startToEnd &&
      //       allowUnarchiveSwipe) {
      //     //Fix it ----------------------------------
      //     //----------- -------- --------
      //     cubit.toggleArchiveStatus(quoteModel);
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(
      //           quoteModel.isArchived
      //               ? "'${quoteModel.quoteText}'unarchived"
      //               : "'${quoteModel.quoteText}'archived",
      //         ),
      //       ),
      //     );
      //   }
      // },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
          // elevation: 0.0,
          // margin: EdgeInsets.all(2.0),
          // surfaceTintColor: Colors.white60,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(12.0),
          // ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular((12.0))),
                child:
                cubit.isDark
                    ? Image.asset(
                  'images/cover_design.png',
                  width: double.infinity,
                  // height: null,
                  // fit: BoxFit.cover,
                )
                    : Image.asset(
                  'images/card_design.png',
                  width: double.infinity,
                  // height: null,
                  // fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      widget.quoteModel.quoteText,
                      // style: Theme.of(context).textTheme.bodyLarge,
                      style:
                      cubit.isDark
                          ? TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )
                          : TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    dense: true,
                    subtitle: Text(
                     widget. quoteModel.author ?? 'UnKnown author',
                      style:
                      cubit.isDark
                          ? TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      )
                          : TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      // style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    isThreeLine: true,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Favorites Icon ---------
                      if (showFavoriteAndEditeIcons)
                        IconButton(
                          onPressed: () {
                            cubit.toggleFavoriteStatus(widget.quoteModel);
                          },
                          icon:
                          widget.quoteModel.isFavorite
                              ? Icon(Icons.favorite, color: Colors.cyan[700])
                              : Icon(Icons.favorite_border),
                        ),
                      // For Edit
                      if (showFavoriteAndEditeIcons)
                        IconButton(
                          onPressed: () async {
                            cubit.startEditingQuote(widget.quoteModel);
                            // final GlobalKey<FormState> bottomSheetFormKey=GlobalKey<FormState>();
                            cubit.scaffoldKey.currentState?.showBottomSheet(
                                  (context) => Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Form(
                                  key: cubit.formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                        controller: cubit.quoteController,
                                        type: TextInputType.text,
                                        text: 'Quote',
                                        textStyle:
                                        cubit.isDark
                                            ? TextStyle(color: Colors.white)
                                            : TextStyle(color: Colors.black),
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'Quote must not be empty';
                                          }
                                          return null;
                                        },
                                        prefix: Icons.format_quote,
                                      ),
                                      const SizedBox(height: 15.0),
                                      defaultFormField(
                                        type: TextInputType.text,
                                        controller: cubit.authorController,
                                        text: 'Author',
                                        textStyle:
                                        cubit.isDark
                                            ? TextStyle(
                                          // fontSize: 20.0,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )
                                            : TextStyle(
                                          // fontSize: 20.0,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'Author must not be empty';
                                          }
                                          return null;
                                        },
                                        prefix: Icons.person,
                                      ),
                                      // const SizedBox(
                                      //   height: 20.0,
                                      // ),
                                      // ElevatedButton(
                                      //   onPressed: (){
                                      //     if(cubit.formKey.currentState?.validate()??false){
                                      //       cubit.startEditingQuote(quoteModel);
                                      //       Navigator.pop(context);
                                      //     }
                                      //   }, child: const Text('Save Changes'),
                                      // ),
                                      // const SizedBox(
                                      //   height: 10.0,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            if (cubit.isBottomSheetShown) {
                              if (cubit.formKey.currentState!.validate()) {
                                if (kDebugMode) {
                                  print(
                                    'Update Icon onPressed =============-----------==. ',
                                  );
                                }
                                cubit.changeBottomSheetState(
                                  isShow: false,
                                  icon: Icons.edit,
                                );

                                cubit.quoteController.clear();
                                cubit.authorController.clear();
                                if (!cubit.isBottomSheetShown) {}
                              }
                            }
                          },
                          icon: Icon(Icons.edit),
                        ),

                      // Delete Icon
                      IconButton(
                        onPressed: () {
                          _showDeleteConfirmationDialog(context,widget.quoteModel);
                        },
                        icon: Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart && allowArchiveSwipe) {
          return true;
        } else if (direction == DismissDirection.startToEnd &&
            allowUnarchiveSwipe) {
          return true;
        }
        return false;
      },
      onDismissed: (direction)  {
        setState(() {
          _isLocallyDismissed=true;
        });
        // UserQuoteModel currentQuoteState=quoteModel;
        if (direction == DismissDirection.endToStart && allowArchiveSwipe) {
          print('Dismissible : Archiving quote ID ${widget.quoteModel.quoteId}');
           cubit.toggleArchivedStatus(widget.quoteModel);
          print(
            'Dismissible: toggleArchiveStatus completed for ${widget.quoteModel.quoteId}',
          );
          Future.microtask(() {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.quoteModel.isArchived
                        ? "'${widget.quoteModel.quoteText}'unarchived"
                        : "'${widget.quoteModel.quoteText}'archived",
                  ),
                ),
              );
            }
          });
        } else if (direction == DismissDirection.startToEnd &&
            allowUnarchiveSwipe) {
          print('Dismissible : Archiving quote ID ${widget.quoteModel.quoteId}');
           cubit.toggleArchivedStatus(widget.quoteModel);
          print(
            'Dismissible: toggleArchiveStatus completed for ${widget.quoteModel.quoteId}',
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.quoteModel.isArchived
                      ? "'${widget.quoteModel.quoteText}'unarchived"
                      : "'${widget.quoteModel.quoteText}'archived",
                ),
              ),
            );
          }
        }
      },
    );
  }
}

Widget buildQuoteItem(
  UserQuoteModel quoteModel,
  context,
  QuoteScreenContext screenContext,
) {
  // var scaffoldKey = GlobalKey<ScaffoldState>();
  // var formKey = GlobalKey<FormState>();

  AppCubit cubit = AppCubit.get(context);
  bool allowArchiveSwipe =
      screenContext == QuoteScreenContext.quotes && !quoteModel.isFavorite;
  bool allowUnarchiveSwipe =
      screenContext == QuoteScreenContext.archived && quoteModel.isArchived;
  bool showFavoriteAndEditeIcons = screenContext != QuoteScreenContext.archived;

  return Dismissible(
    key: Key(quoteModel.quoteId.toString()),
    background:
        (allowUnarchiveSwipe)
            ? Container(
              color: Colors.black87,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.unarchive, color: Colors.white60),
            )
            : (allowArchiveSwipe)
            ? Container(color: Colors.transparent)
            : null,

    secondaryBackground:
        (allowArchiveSwipe)
            ? Container(
              color: Colors.cyan[700],
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.archive, color: Colors.white60),
            )
            : null,

    // confirmDismiss: (direction) async {
    //   // if (quoteModel.isFavorite != true) {
    //   //   if (!enableSwiping&&quoteModel.isFavorite!=true) return false;
    //   if (direction == DismissDirection.endToStart && allowArchiveSwipe) {
    //     return true;
    //   } else if (direction == DismissDirection.startToEnd &&
    //       allowUnarchiveSwipe) {
    //     return true;
    //     // if(screenContext==QuoteScreenContext.archived&&quoteModel.isArchived){
    //     //   return true;
    //     // }
    //   }
    //   return false;
    // },
    // onDismissed: (direction) {
    //   // if(!enableSwiping)return;
    //   // if(screenContext==QuoteScreenContext.quotes)
    //   if (direction == DismissDirection.endToStart && allowArchiveSwipe) {
    //     cubit.toggleArchiveStatus(quoteModel);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           quoteModel.isArchived
    //               ? "'${quoteModel.quoteText}'unarchived"
    //               : "'${quoteModel.quoteText}'archived",
    //         ),
    //       ),
    //     );
    //   } else if (direction == DismissDirection.startToEnd &&
    //       allowUnarchiveSwipe) {
    //     //Fix it ----------------------------------
    //     //----------- -------- --------
    //     cubit.toggleArchiveStatus(quoteModel);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           quoteModel.isArchived
    //               ? "'${quoteModel.quoteText}'unarchived"
    //               : "'${quoteModel.quoteText}'archived",
    //         ),
    //       ),
    //     );
    //   }
    // },
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        // elevation: 0.0,
        // margin: EdgeInsets.all(2.0),
        // surfaceTintColor: Colors.white60,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12.0),
        // ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular((12.0))),
              child:
                  cubit.isDark
                      ? Image.asset(
                        'images/cover_design.png',
                        width: double.infinity,
                        // height: null,
                        // fit: BoxFit.cover,
                      )
                      : Image.asset(
                        'images/card_design.png',
                        width: double.infinity,
                        // height: null,
                        // fit: BoxFit.cover,
                      ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    quoteModel.quoteText,
                    // style: Theme.of(context).textTheme.bodyLarge,
                    style:
                        cubit.isDark
                            ? TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                            : TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                  ),
                  dense: true,
                  subtitle: Text(
                    quoteModel.author ?? 'UnKnown author',
                    style:
                        cubit.isDark
                            ? TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            )
                            : TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                    // style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  isThreeLine: true,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Favorites Icon ---------
                    if (showFavoriteAndEditeIcons)
                      IconButton(
                        onPressed: () {
                          cubit.toggleFavoriteStatus(quoteModel);
                        },
                        icon:
                            quoteModel.isFavorite
                                ? Icon(Icons.favorite, color: Colors.cyan[700])
                                : Icon(Icons.favorite_border),
                      ),
                    // For Edit
                    if (showFavoriteAndEditeIcons)
                      IconButton(
                        onPressed: () async {
                          cubit.startEditingQuote(quoteModel);
                          // final GlobalKey<FormState> bottomSheetFormKey=GlobalKey<FormState>();
                          cubit.scaffoldKey.currentState?.showBottomSheet(
                            (context) => Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Form(
                                key: cubit.formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultFormField(
                                      controller: cubit.quoteController,
                                      type: TextInputType.text,
                                      text: 'Quote',
                                      textStyle:
                                          cubit.isDark
                                              ? TextStyle(color: Colors.white)
                                              : TextStyle(color: Colors.black),
                                      validate: (value) {
                                        if (value.isEmpty) {
                                          return 'Quote must not be empty';
                                        }
                                        return null;
                                      },
                                      prefix: Icons.format_quote,
                                    ),
                                    const SizedBox(height: 15.0),
                                    defaultFormField(
                                      type: TextInputType.text,
                                      controller: cubit.authorController,
                                      text: 'Author',
                                      textStyle:
                                          cubit.isDark
                                              ? TextStyle(
                                                // fontSize: 20.0,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )
                                              : TextStyle(
                                                // fontSize: 20.0,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                      validate: (value) {
                                        if (value.isEmpty) {
                                          return 'Author must not be empty';
                                        }
                                        return null;
                                      },
                                      prefix: Icons.person,
                                    ),
                                    // const SizedBox(
                                    //   height: 20.0,
                                    // ),
                                    // ElevatedButton(
                                    //   onPressed: (){
                                    //     if(cubit.formKey.currentState?.validate()??false){
                                    //       cubit.startEditingQuote(quoteModel);
                                    //       Navigator.pop(context);
                                    //     }
                                    //   }, child: const Text('Save Changes'),
                                    // ),
                                    // const SizedBox(
                                    //   height: 10.0,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          if (cubit.isBottomSheetShown) {
                            if (cubit.formKey.currentState!.validate()) {
                              if (kDebugMode) {
                                print(
                                  'Update Icon onPressed =============-----------==. ',
                                );
                              }
                              cubit.changeBottomSheetState(
                                isShow: false,
                                icon: Icons.edit,
                              );

                              cubit.quoteController.clear();
                              cubit.authorController.clear();
                              if (!cubit.isBottomSheetShown) {}
                            }
                          }
                        },
                        icon: Icon(Icons.edit),
                      ),

                    // Delete Icon
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, quoteModel);
                      },
                      icon: Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    confirmDismiss: (direction) async {
      if (direction == DismissDirection.endToStart && allowArchiveSwipe) {
        return true;
      } else if (direction == DismissDirection.startToEnd &&
          allowUnarchiveSwipe) {
        return true;
      }
      return false;
    },
    onDismissed: (direction) async {
      // UserQuoteModel currentQuoteState=quoteModel;
      if (direction == DismissDirection.endToStart && allowArchiveSwipe) {
        print('Dismissible : Archiving quote ID ${quoteModel.quoteId}');
        await cubit.toggleArchivedStatus(quoteModel);
        print(
          'Dismissible: toggleArchiveStatus completed for ${quoteModel.quoteId}',
        );
        Future.microtask(() {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  quoteModel.isArchived
                      ? "'${quoteModel.quoteText}'unarchived"
                      : "'${quoteModel.quoteText}'archived",
                ),
              ),
            );
          }
        });
      } else if (direction == DismissDirection.startToEnd &&
          allowUnarchiveSwipe) {
        print('Dismissible : Archiving quote ID ${quoteModel.quoteId}');
        await cubit.toggleArchivedStatus(quoteModel);
        print(
          'Dismissible: toggleArchiveStatus completed for ${quoteModel.quoteId}',
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                quoteModel.isArchived
                    ? "'${quoteModel.quoteText}'unarchived"
                    : "'${quoteModel.quoteText}'archived",
              ),
            ),
          );
        }
      }
    },
  );
}
