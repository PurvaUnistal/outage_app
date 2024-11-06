
import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final String title;
  final Widget child;
 /* final List<String> items;
  final List<IconData> iconList;
  final List<Color> colorList;*/
  const MultiSelect({Key? key,
    required this.title,
    required this.child,
    /*required this.items,
    required this.iconList,
    required this.colorList*/
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
     /*   child: ListBody(
          children: widget.items
              .map((item) =>  Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_outlined, ),
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  value: _selectedItems.contains(item),
                  onChanged: (isChecked) => _itemChange(item, isChecked!),
                ),
                Text(item),
              ])
          )
              .toList(),
        ),*/
        child: widget.child,
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}