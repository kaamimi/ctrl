import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:ctrl/modules/tile_colors.dart';

void addAction(String color, String text, String cmd) async {
  final Database ctrlDb = await openDatabase("ctrl.db");

  await ctrlDb.insert(
    "ctrl",
    {
      "color": color,
      "text": text,
      "command": cmd,
    },
    conflictAlgorithm: ConflictAlgorithm.fail,
  );
  await ctrlDb.close();
}

// DropdownMenuEntry
DropdownMenuEntry colorEntry(String color) {
  return DropdownMenuEntry(
    leadingIcon: Icon(
      Icons.circle,
      color: tileColor[color],
    ),
    value: color,
    label: color,
  );
}

class NewAction extends StatefulWidget {
  const NewAction({super.key, required this.onAddAction});

  final void Function() onAddAction;

  @override
  State<NewAction> createState() => _NewActionState();
}

class _NewActionState extends State<NewAction> {
  final _formKey = GlobalKey<FormState>();
  String _label = "";
  String _cmd = "";
  String _color = "Green";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new action"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  maxLength: 25,
                  decoration: const InputDecoration(
                    labelText: "Label",
                    icon: Icon(Icons.new_label_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Invalid Label";
                    }
                    return null;
                  },
                  onSaved: (value) => _label = value!,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Command",
                    icon: Icon(Icons.terminal_outlined),
                  ),
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Invalid Command";
                    }
                    return null;
                  },
                  onSaved: (value) => _cmd = value!,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Icon(Icons.color_lens_outlined),
                    const SizedBox(width: 16),
                    DropdownMenu(
                      initialSelection: "Green",
                      label: const Text("Select Color"),
                      dropdownMenuEntries: [
                        colorEntry("Green"),
                        colorEntry("Blue"),
                        colorEntry("Light Green"),
                        colorEntry("Orange"),
                        colorEntry("Pink"),
                        colorEntry("Purple"),
                      ],
                      onSelected: (value) => _color = value!,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _formKey.currentState!.reset(),
                      style: TextButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                      child: const Text("Clear"),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          addAction(_color, _label, _cmd);
                          widget.onAddAction();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Added successfully"),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Create"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
