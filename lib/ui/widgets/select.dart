import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Select extends StatelessWidget {
  final List<String> items;
  final String? selected;
  final void Function(String? text) onChanged;

  const Select(
      {Key? key,
      required this.items,
      this.selected,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Padding(
                padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
            child: DropdownButton<String>(
              value: selected,
              icon: const Icon(Ionicons.arrow_down),
              iconSize: 20,
              elevation: 16,
              isExpanded: true,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.white,
              ),
              selectedItemBuilder: (BuildContext context) {
                if (items.isEmpty) {
                  return [
                    const Padding(
                      padding: EdgeInsets.all(20),
                    )
                  ];
                }

                return items.map((String value) {
                  return Align(
                      alignment: const Alignment(0, 0),
                      child: Text(
                        selected ?? '',
                        style: const TextStyle(color: Colors.white),
                      ));
                }).toList();
              },
              onChanged: (String? newValue) {
                onChanged(newValue);
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )));
  }
}
