import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';


///
/// ----------------------- S T A R T --------------------------
/// ------------ T A S K  T I L E  I N  H O M E-----------------

class HomeTaskTile extends StatelessWidget {
  final String folderName;
  final String taskName;
  final int priority;
  final String deadline;
  // final double cardWidth;
  //final File? deckImage;
  final VoidCallback? onPressed;

  const HomeTaskTile({
    super.key,
    required this.folderName,
    required this.taskName,
    required this.priority,
    required this.deadline,
    required this.onPressed,

    // required this.cardWidth,
    // required this.deckImage,
  });

  Color getColor(int priority){
    Color color = DeckColors.white;
    if(priority == 0) { color = DeckColors.deckRed;}
    else if(priority == 1) { color = DeckColors.deckYellow;}
    else if(priority == 3) { color = DeckColors.deckBlue;}
    else{color = DeckColors.white;}
    return color;
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: DeckColors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            //            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 20,
                height: 80,
                decoration: BoxDecoration(
                    color: getColor(priority),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(15)
                    )
                )
              ),
              const SizedBox(width: 10),
              Expanded(
                  child:Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns text to the left
                      children: [
                        AutoSizeText(
                          taskName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'fraiche',
                            fontSize: 20,
                            color: DeckColors.primaryColor,
                          ),
                        ),
                        AutoSizeText(
                          deadline,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Nunito-SemiBold',
                            fontSize: 14,
                            color: DeckColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              Padding(padding: const EdgeInsets.all(10),
                child: Container(
                    width:50,
                  padding:EdgeInsets.symmetric(horizontal: 10),
                  decoration:BoxDecoration(
                    color: DeckColors.deepGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AutoSizeText(
                    folderName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Nunito-SemiBold',
                      fontSize: 10,
                      color: DeckColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// ------------ T A S K  T I L E  I N  H O M E-----------------