import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../misc/colors.dart';
import '../misc/deck_icons.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image(
                      image: AssetImage('assets/images/Deck-Header.png'),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(DeckIcons.back_arrow,
                            color: DeckColors.primaryColor,
                            size: 24),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
                 const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Agreement",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Fraiche',
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: DeckColors.primaryColor,
                          )
                      ),
                      Text("Privacy Policy",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            height: 0.9,
                            fontFamily: 'Fraiche',
                            fontSize: 56,
                            color: DeckColors.primaryColor,
                          )
                      ),
                      SizedBox(height: 20,),
                      Text('At Deck, we are committed to protecting your privacy. This '
                          'Privacy Policy describes how your personal information is collected, '
                          'used, and shared when you use the Deck application (the "App").',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Nunito-Regular',
                          fontSize: 16,
                          color: DeckColors.primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Nunito-Regular',
                            fontSize: 16,
                            color: DeckColors.primaryColor,
                          ),
                          children: [
                            //TODO:update the information fot privacy policy
                            //information We Collect section
                            TextSpan(
                              text: '1. Information We Collect\n\n',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'a. Information You Provide: ',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'When you register an account with Deck, we collect certain personal '
                                  'information such as your name, email address, and password.\n\n',
                            ),
                            TextSpan(
                              text: 'b. Usage Information: ',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'We collect information about your interactions with the App, '
                                  'including your study habits, flashcard usage, and preferences.\n\n',
                            ),
                            TextSpan(
                              text: 'c. Device Information: ',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'We collect information about the device you use to access the App, '
                                  'including the hardware model, operating system version, and unique '
                                  'device identifiers.\n\n\n',
                            ),

                            //How We Use Your Information seciton
                            TextSpan(
                              text: '2. How We Use Your Information\n\n',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'We use the information we collect to provide and improve the App, '
                                  'personalize your experience, communicate with you, and protect the '
                                  'security of the App.\n\n\n',
                            ),

                            //Sharing Your Information section
                            TextSpan(
                              text: '3. Sharing Your Information\n\n',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'We may share your personal information with third-party service '
                                  'providers who assist us in providing the App, such as hosting providers '
                                  'and analytics services. We may also share your information in response '
                                  'to legal requests or to protect our rights or the rights of others.\n\n\n',
                            ),

                            // Data Retention section
                            TextSpan(
                              text: '4. Data Retention\n\n',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'We will retain your personal information for as long as necessary to '
                                  'fulfill the purposes outlined in this Privacy Policy unless a longer '
                                  'retention period is required or permitted by law.\n\n\n',
                            ),

                            //Security section
                            TextSpan(
                              text: '5. Security\n\n',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'We take reasonable measures to protect the security of your '
                                  'personal information and to prevent unauthorized access, disclosure, '
                                  'alteration, or destruction.\n\n\n',
                            ),

                            //Children's Privacy section
                            TextSpan(
                              text: '6. Children\'s Privacy\n\n',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'Deck is not directed to children under the age of 13, and we do '
                                  'not knowingly collect personal information from children under the '
                                  'age of 13. If we become aware that we have collected personal '
                                  'information from a child under the age of 13, we will take steps '
                                  'to delete such information.\n\n\n',
                            ),

                            //Changes to Privacy Policy section
                            TextSpan(
                              text: '7. Changes to Privacy Policy\n\n',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'We reserve the right to modify this Privacy Policy at a'
                                  'ny time. If we make material changes to this Privacy Policy, we '
                                  'will notify you by email or by posting a notice in the App prior '
                                  'to the changes taking effect.\n\n\n',
                            ),
                            TextSpan(
                              text: '8. Contact Us\n\n',
                              style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                            ),
                            TextSpan(
                              text: 'If you have any questions or concerns about this Privacy '
                                  'Policy, please contact us at \'deckoctopus@gmail.com\'.\n\n',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10),
                      Text("By using the Deck App, you consent to the "
                          "collection and use of your personal information as described in this Privacy Policy. "
                          "Thank you for using Deck!",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: 'Nunito-Regular',
                            fontSize: 16,
                            color: DeckColors.primaryColor,
                          )
                      ),
                      SizedBox(height: 40),

                    ],
                  ),
                ),
                Image(
                  image: const AssetImage('assets/images/Deck-Bottom-Image3.png'),
                  width: MediaQuery.of(context).size.width,
                  height:80,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          )
      ),
    );
  }
}