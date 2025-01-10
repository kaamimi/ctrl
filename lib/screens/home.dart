import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ctrl/widgets/add_tile.dart';
import 'package:ctrl/widgets/action_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> tiles = [];
  Future<void> loadActions() async {
    final Database ctrlDb = await openDatabase(
      "ctrl.db",
      version: 1,
      onCreate: (Database db, int version) async => await db.execute(
        "CREATE TABLE ctrl(color VARCHAR(255), text VARCHAR(255), command BLOB)",
      ),
    );
    try {
      final data = await ctrlDb.query("ctrl");
      final actionTiles = data.map(
        (row) => ActionTile(
          text: row["text"].toString(),
          color: row["color"].toString(),
          cmd: row["command"].toString(),
          onDeleteAction: loadActions,
        ),
      );
      setState(() {
        tiles = [...actionTiles];
        tiles.add(AddTile(onAddAction: loadActions));
      });
    } finally {
      await ctrlDb.close();
    }
  }

  @override
  void initState() {
    super.initState();
    loadActions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ctrl"),
        titleTextStyle: GoogleFonts.jetBrainsMono(fontSize: 32),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          children: tiles,
        ),
      ),
    );
  }
}
