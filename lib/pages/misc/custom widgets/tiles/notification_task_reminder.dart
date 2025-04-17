import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';

class TaskReminderNotification extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onView;
  final VoidCallback onSnooze;
  final VoidCallback onDelete;

  const TaskReminderNotification({
    Key? key,
    required this.title,
    required this.message,
    required this.onView,
    required this.onSnooze,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 30,right: 30,top: 10),
        decoration: const BoxDecoration(
          color: DeckColors.white,
          border: Border.symmetric(
              horizontal: BorderSide(
                  color: DeckColors.primaryColor,
                  width: 3
              )
          ),
        ),
        child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                  title,
                  maxLines: 1,
                  minFontSize:15,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color:DeckColors.primaryColor,
                    fontFamily: 'Nunito-Bold',
                    fontSize: 20,
                  )
              ),
              const SizedBox(
                height: 5,
              ),
              AutoSizeText(
                  message,
                  maxLines: 1,
                  minFontSize: 12,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color:DeckColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 12,
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onView,
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(DeckColors.softGray),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child:  const AutoSizeText(
                        "View Task",
                        style: TextStyle(
                          color: DeckColors.primaryColor,
                          fontSize: 10,
                        )
                    ),
                  ),
                  TextButton(
                    onPressed: onView,
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(DeckColors.softGray),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child:  const AutoSizeText(
                        "Snooze Reminder",
                        style: TextStyle(
                          color: DeckColors.deckBlue,
                          fontSize: 10,
                        )
                    ),
                  ),
                  TextButton(
                    onPressed: onDelete,
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(DeckColors.softGray),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child:  const AutoSizeText(
                        "Delete",
                        style: TextStyle(
                          color: DeckColors.deckRed,
                          fontSize: 10,
                        )
                    ),
                  ),
                ],
              )
            ]
        )
    );
  }
}