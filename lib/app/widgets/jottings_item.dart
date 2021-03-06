import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:jottings/app/models/folder.dart';
import 'package:jottings/app/models/item.dart';
import 'package:jottings/app/models/note.dart';
import 'package:jottings/app/models/todo.dart';
import 'package:jottings/app/widgets/item_dialog.dart';

class JottingsItem extends StatelessWidget {
  final Rx<Item> item;

  JottingsItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.19,
      child: GestureDetector(
        onTap: () => this.item.value.controller!.goInto(item.value),
        child: _Item(this.item),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () => ItemDialog.getDialog(
            context,
            item: item.value,
            title: "Edit item",
            onSubmit: (item) => this.item.value.controller!.editItem(item),
          ),
        ),
        IconSlideAction(
          caption: 'Remove',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => item.value.controller!.removeItem(item.value),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.item);

  final Rx<Item> item;

  Icon _getIcon(Item item) {
    switch (item.runtimeType) {
      case Folder:
        return Icon(Icons.folder, color: Colors.orange);
      case TodoList:
        return Icon(Icons.list_alt, color: Colors.green);
      case Note:
        return Icon(Icons.notes_rounded, color: Colors.blue);
    }
    return Icon(Icons.error, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _getIcon(item.value),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Obx(
                    () => Text(
                      item.value.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Handle(
                  delay: const Duration(milliseconds: 100),
                  child: Icon(Icons.drag_indicator),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
