import 'package:flutter/material.dart';
import 'package:ctrl/screens/new_action.dart';

class AddTile extends StatelessWidget {
  const AddTile({super.key, required this.onAddAction});

  final void Function() onAddAction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => NewAction(onAddAction: onAddAction),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const SizedBox(
        height: 150,
        width: 150,
        child: Center(
          child: Icon(
            size: 40,
            Icons.add,
          ),
        ),
      ),
    );
  }
}
