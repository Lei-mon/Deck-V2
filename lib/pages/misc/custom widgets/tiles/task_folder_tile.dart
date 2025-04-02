import 'package:deck/pages/misc/deck_icons.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/svg.dart';
import '../../colors.dart';
import '../menus/pop_up_menu.dart';
import '../progressbar/progress_bar.dart';

class TaskFolderTile extends StatelessWidget{
  final String? folderName;
  final int? taskDone;
  final int? taskTotal;
  final int? folderBackground;
  final VoidCallback? onPressed;

  TaskFolderTile({
    super.key,
    required this.folderName,
    required this.folderBackground,
    required this.taskDone,
    required this.taskTotal,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (taskTotal != 0) ? (taskDone ?? 0) / taskTotal! : 0.0;
    String? backgroundImage;
    switch(folderBackground){
      case 1:
        backgroundImage = 'assets/images/Deck-Background4.svg';
        break;
      case 2:
        backgroundImage = 'assets/images/Deck-Background5.svg';
        break;
      case 3:
        backgroundImage = 'assets/images/Deck-Background6.svg';
        break;
      default:
        backgroundImage = null;
    }
    return Stack(
      children: [
        Material(
          borderRadius: BorderRadius.circular(15.0),
          color: DeckColors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () {
              if (onPressed != null) {
                onPressed!();
              }
            },
            child: Stack(
                children: [
                  if (backgroundImage != null) Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: SvgPicture.asset(
                          backgroundImage,
                          fit: BoxFit.cover,
                        ),
                      )
                    ),
                  Container(
                    width: 200,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: DeckColors.primaryColor, width: 3),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                            '$folderName',
                            maxLines:2,
                            minFontSize:10,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              height:1,
                              fontFamily: 'Fraiche',
                              fontSize: 30,
                              color: DeckColors.primaryColor,
                            )
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: AutoSizeText(
                              '$taskDone/$taskTotal',
                              maxLines:1,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              minFontSize:10,
                              style: const TextStyle(
                                fontFamily: 'Fraiche',
                                fontSize: 20,
                                color: DeckColors.primaryColor,
                              )
                          ),
                        ),
                        ProgressBar(
                          progress: progress,
                          progressColor: DeckColors.primaryColor,
                          height: 15.0,
                        ),
                      ],
                    ),

                  ),
                ]
            )


          ),
        ),
        Positioned(
          right: 0,
          top: 5,
          child: PopupMenu(
            items: ["Edit Folder Info", "Delete"],
            icons: [DeckIcons.pencil, DeckIcons.trash_bin],
            onItemSelected: (index) {
              if (index == 0) {
                print("Edit Folder Info Selected");
              } else if (index == 1) {
                print("Delete Selected");
              }
            },
            offset: -100,
          ),

        )
      ],
    );
  }
}
