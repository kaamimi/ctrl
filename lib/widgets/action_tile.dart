import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ctrl/modules/tile_colors.dart';
import 'package:ctrl/server/ask_server.dart';

void deleteAction(String color, String text, String cmd) async {
  final Database ctrlDb = await openDatabase("ctrl.db");
  await ctrlDb.rawDelete(
    'DELETE FROM ctrl WHERE color = "$color" AND text="$text"',
  );
  await ctrlDb.close();
}

class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.text,
    required this.color,
    required this.cmd,
    required this.onDeleteAction,
  });

  final String text;
  final String color;
  final String cmd;
  final void Function() onDeleteAction;

  @override
  Widget build(BuildContext context) {
    void snack() {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Execution Successful")),
      );
    }

    return ElevatedButton(
      onPressed: () async {
        String result = await sendToServer(cmd: cmd);
        if (result == "0") {
          snack();
        }
      },
      onLongPress: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit", style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(height: 4),
                  TextButton.icon(
                    onPressed: () {
                      deleteAction(color, text, cmd);
                      onDeleteAction();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Deleted Successfully")),
                      );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text("Delete", style: TextStyle(fontSize: 22)),
                  )
                ],
              ),
            ),
          );
        },
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: tileColor[color],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        text,
        overflow: TextOverflow.clip,
        softWrap: true,
        style: GoogleFonts.interTight(
          fontSize: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
