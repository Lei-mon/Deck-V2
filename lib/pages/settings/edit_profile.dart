import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/auth/auth_utils.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../backend/profile/profile_provider.dart';
import '../../backend/profile/profile_utils.dart';
import '../auth/signup.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/icon_button.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/images/profile_image.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';
import '../misc/custom widgets/tiles/bottom_sheet.dart';
import '../misc/custom widgets/tiles/settings_container.dart';
import 'change_password.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  bool _isLoading = false;
  final TextEditingController firstNameController =
      TextEditingController(text: AuthUtils().getFirstName());
  final TextEditingController lastNameController =
      TextEditingController(text: AuthUtils().getLastName());
  final TextEditingController emailController =
      TextEditingController(text: AuthUtils().getEmail());

  XFile? pfpFile;
  late Image? photoUrl;

  @override
  void initState() {
    super.initState();
    getUrls();
  }

  void getUrls() async {
    photoUrl = null;
    setState(() {
      photoUrl = AuthUtils().getPhoto();
    });
  }

  Future<void> updateAccountInformation(BuildContext context) async {
    User? user = AuthService().getCurrentUser();
    List<String>? userName = user?.displayName?.split(' ');
    String? lastName = userName?.removeLast();
    String newName = getNewName();
    String uniqueFileName =
        '${AuthService().getCurrentUser()?.uid}-${DateTime.now().millisecondsSinceEpoch}';

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty) {
      ///display error
      showAlertDialog(
        context,
        "assets/images/Deck_Dialogue1.png",
        "Uh oh. Something went wrong.",
        "Error changing information! Please fill out all of the input fields and try again.",
      );
      return;
    }
    if (newName != '$userName $lastName')
      await _updateDisplayName(user, newName);
    if (user?.email != emailController.text) {
      bool isEmailValid = await _updateEmail(user);
      if (!isEmailValid) {
        return;
      }
    }
    print('pfpFile: $pfpFile');
    print('photoUrl: $photoUrl');
    await _updateProfilePhoto(user, uniqueFileName);

    String message = 'Updated user information!';
    if (user?.email != emailController.text) {
      message =
          "Updated user information! Please check your new email in order to change.";
    }

    if (user?.email != emailController.text) {
      AuthService().signOut();
      Navigator.of(context).pushAndRemoveUntil(
          RouteGenerator.createRoute(const SignUpPage()),
          (Route<dynamic> route) => false);
      return;
    }
    setState(() => _isLoading = false);
    Navigator.pop(context, {'updated': true});
    showAlertDialog(
      context,
      "assets/images/Deck_Dialogue2.png",
      "Successfully updated information",
      message,
    );
  }

  String getNewName() {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    return "$firstName $lastName";
  }

  Future<void> _updateDisplayName(User? user, String newName) async {
    if (user?.displayName != newName) {
      await user?.updateDisplayName(newName);
    }
  }

  Future<bool> _updateEmail(User? user) async {
    try {
      await user?.verifyBeforeUpdateEmail(emailController.text);
      final db = FirebaseFirestore.instance;
      var querySnapshot = await db
          .collection('users')
          .where('email', isEqualTo: AuthUtils().getEmail())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        String docId = doc.id;

        await db
            .collection('users')
            .doc(docId)
            .update({'email': emailController.text, 'user_id': user?.uid});
      }
      return true;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Invalid email format! Please try again.';
      } else {
        message = e.toString();
      }
      print(e);

      showAlertDialog(context, "assets/images/Deck_Dialogue1.png","Uh oh. Something went wrong","Error changing information. $message ");
      return false;
    } catch (e) {
      print(e);
      showAlertDialog(context, "assets/images/Deck_Dialogue1.png","Uh oh. Something went wrong","Error changing information. " + e.toString());
      return false;
    }
  }

  Future<void> _updateProfilePhoto(User? user, String uniqueFileName) async {
    if (photoUrl != null) {
      Reference refRoot = FirebaseStorage.instance.ref();
      Reference refDirPfpImg = refRoot.child('userProfiles/${user?.uid}');
      Reference refPfpUpload = refDirPfpImg.child(uniqueFileName);

      bool pfpExists = await ProfileUtils().doesFileExist(refPfpUpload);
      if (!pfpExists && pfpFile != null) {
        await refPfpUpload.putFile(File(pfpFile!.path));
        String newPhotoUrl = await refPfpUpload.getDownloadURL();
        await user?.updatePhotoURL(newPhotoUrl);
      }
    } else if (photoUrl == null) {
      await user!.updatePhotoURL(null);
    }
    await user?.reload();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ///For dialog box to appear when user clicks the back button at the app bar or the device itself
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didpop) async {
        if (didpop) {
          return;
        }
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return
              CustomConfirmDialog(
                imagePath:"assets/images/Deck_Dialogue1.png", //image of deck
                title: "Are you sure you want to go back?", // title of alert
                message: "If you go back now, all unsaved progress will be lost.", //subtitle or detailed message
                button1: "Go Back",//text of button
                onConfirm:(){ Navigator.of(context).pop(); },//when button is pressed perform action
                button2: "Cancel", //text of button, default is Cancel
                onCancel:  () {}, //when button is pressed perform action
              );
      },
    );
        //Check the result of the dialog and decide whether to pop or not
        if (shouldPop != null && shouldPop) {
          Navigator.of(context).pop();
        }
      },
      ///----- E N D -----
      child: Scaffold(
        backgroundColor: DeckColors.backgroundColor,
        appBar: const AuthBar(
          automaticallyImplyLeading: true,
          title: 'Manage Account',
          color: DeckColors.primaryColor,
          fontSize: 24,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // BuildCoverImage(borderRadiusContainer: 0, borderRadiusImage: 0, coverPhotoFile: coverUrl,),
                        // Positioned(
                        //   top: 150,
                        //   left: 10,
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
                            child: BuildProfileImage(photoUrl, height: 200,),
                          ),
                        ),
                        // ),
                        /* Positioned(
                    top: 140,
                    right: 10,
                    child: BuildIconButton(
                      containerWidth: 40,
                      containerHeight: 40,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              child: Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                color: DeckColors.gray,
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: BuildContentOfBottomSheet(
                                      bottomSheetButtonText: 'Upload Cover Photo',
                                      bottomSheetButtonIcon: Icons.image,
                                      onPressed: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                                        if(file == null) return;
                                        setState(() {
                                          coverUrl = Image.file(File(file!.path));
                                          coverFile = file;
                                          print(coverUrl);
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: BuildContentOfBottomSheet(
                                      bottomSheetButtonText: 'Remove Cover Photo',
                                      bottomSheetButtonIcon: Icons.remove_circle,
                                      onPressed: () {
                                        setState(() {
                                          coverUrl = Image.asset('assets/images/Deck-Logo.png');
                                          coverFile = null;
                                          print(coverUrl);
                                        });
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                        );
                      },
                      icon: DeckIcons.pencil,
                      iconColor: DeckColors.white,
                      backgroundColor: DeckColors.accentColor,
                    ),
                  ),*/
                        Positioned(
                          top: 190,
                          right: 25,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: BuildIconButton(
                                containerWidth: 40,
                                containerHeight: 40,
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                        ),
                                        child: Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: DeckColors.white,
                                          child: Column(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 10),
                                              child: BuildContentOfBottomSheet(
                                                bottomSheetButtonText:
                                                    'Upload Profile Photo',
                                                bottomSheetButtonIcon:
                                                    Icons.image,
                                                onPressed: () async {
                                                  ImagePicker imagePicker =
                                                      ImagePicker();
                                                  XFile? file =
                                                      await imagePicker.pickImage(
                                                          source: ImageSource
                                                              .gallery);
                                                  if (file == null) return;
                                                  setState(() {
                                                    photoUrl = Image.file(
                                                        File(file!.path));
                                                    pfpFile = file;
                                                  });
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 10),
                                              child: BuildContentOfBottomSheet(
                                                bottomSheetButtonText:
                                                    'Remove Profile Photo',
                                                bottomSheetButtonIcon:
                                                    Icons.remove_circle,
                                                onPressed: () {
                                                  setState(() {
                                                    photoUrl = null;
                                                    pfpFile = null;
                                                    print(photoUrl);
                                                  });
                                                },
                                              ),
                                            ),
                                          ]),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: DeckIcons.pencil,
                                iconColor: DeckColors.primaryColor,
                                backgroundColor: DeckColors.white,
                                borderColor: DeckColors.primaryColor,
                                borderWidth: 3.0,
                              )),
                        ),
                      ],
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.only(top: 40.0, left: 15, right: 15),
                      child: Text(
                        'First Name',
                        style: TextStyle(
                          fontFamily: 'Nunito-ExtraBold',
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: BuildTextBox(
                        showPassword: false,
                        hintText: "First Name",
                        controller: firstNameController,
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 15, right: 15),
                      child: Text(
                        'Last Name',
                        style: TextStyle(
                          fontFamily: 'Nunito-ExtraBold',
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: BuildTextBox(
                        showPassword: false,
                        hintText: "Last Name",
                        controller: lastNameController,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10.0, left: 15, right: 15),
                      child:!AuthService()
                          .getCurrentUser()!
                          .providerData[0]
                          .providerId
                          .contains('google.com')
                          ?  const Text( 'Email', style: TextStyle(
                          fontFamily: 'Nunito-ExtraBold',
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                        )
                      )
                          : const SizedBox()),
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: !AuthService()
                                .getCurrentUser()!
                                .providerData[0]
                                .providerId
                                .contains('google.com')
                            ? BuildTextBox(
                                showPassword: false,
                                hintText: "Email",
                                controller: emailController,
                              )
                            : const SizedBox()),
                    !AuthService()
                        .getCurrentUser()!
                        .providerData[0]
                        .providerId
                        .contains('google.com')
                        ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                          EdgeInsets.only(top: 20.0, left: 15, right: 15),
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              fontFamily: 'Nunito-ExtraBold',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                          child: BuildSettingsContainer(
                            selectedIcon: DeckIcons.lock,
                            nameOfTheContainer: 'Change Password',
                            showArrow: true,
                            showSwitch: false,
                            containerColor: DeckColors.primaryColor, // Container Color
                            selectedColor: DeckColors.primaryColor, // Left Icon Color
                            textColor: Colors.white, // Text Color
                            iconColor: DeckColors.white,
                            iconArrowColor: DeckColors.white,
                            toggledColor: DeckColors
                                .accentColor, // Left Icon Color when Toggled
                            onTap: () {
                              Navigator.of(context).push(
                                RouteGenerator.createRoute(
                                    const ChangePasswordPage()),
                              );
                            },
                          ),
                        ),

                      ],
                    )
                        : const SizedBox(),
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 25.0),
                        child: Divider(
                          thickness: 1,
                          color: DeckColors.primaryColor,
                        ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 15, right: 15),
                      child: BuildButton(
                        onPressed: () {
                          print(
                              "save button clicked"); //line to test if working ung onPressedLogic XD
                          showConfirmDialog(
                            context,
                            "assets/images/Deck_Dialogue1.png",
                            "Save Account Information",
                            "Are you sure you want to change your account information?",
                            "Save Account Information",
                            () async {
                              try {
                                setState(() => _isLoading = true);
                                await updateAccountInformation(context);
                              } catch (e) {
                                print(e);
                                setState(() => _isLoading = false);
                                showAlertDialog(context,
                                    "assets/images/Deck_Dialogue1.png",
                                    "Error changing information", e.toString());
                              }
                            },
                          );
                        },
                        buttonText: 'Save Changes',
                        height: 65.0,
                        width: MediaQuery.of(context).size.width,
                        backgroundColor: DeckColors.primaryColor,
                        textColor: DeckColors.white,
                        radius: 10.0,
                        fontSize: 16,
                        borderWidth: 0,
                        borderColor: Colors.transparent,
                      ),
                    ),
                    /*Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: BuildButton(
                        onPressed: () {
                          print(
                              "cancel button clicked"); //line to test if working ung onPressedLogic XD
                          Navigator.pop(context);
                        },
                        buttonText: 'Cancel',
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        backgroundColor: DeckColors.white,
                        textColor: DeckColors.primaryColor,
                        radius: 10.0,
                        fontSize: 16,
                        borderWidth: 0,
                        borderColor: Colors.transparent,
                      ),
                    ),*/
                  ],
                ),
              ),
      ),
    );
  }
}
