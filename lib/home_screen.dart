import 'package:flutter/material.dart';
import 'package:flutter_hive_example/boxes/boxes.dart';
import 'package:flutter_hive_example/models/notes_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Database"),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              NotesModel nm = box.getAt(index)!;
              return ListTile(
                title: Text(nm.title),
                subtitle: Text(nm.description),
                trailing: Wrap(
                  spacing: 20,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _editDialog(nm, nm.title, nm.description);
                        },
                        child: const Icon(Icons.edit)),
                    GestureDetector(
                        onTap: () {
                          delete(nm);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    Icons.newspaper_sharp,
                    color: Colors.grey.shade700,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showDialog();
          // var box = await Hive.openBox("name");
          //
          // box.put("name", "Sujith");
          // box.put("age", 20);
          // box.put("details", {
          //   "name" : "Sujith",
          //   "age" : 20,
          //   "class" : "AIE-A",
          //   "clg" : "Amrita"
          // });
          //
          // // print(box.get("name"));
          // // print(box.get("age"));
          // print(box.get("details")["class"]);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: "Enter Title"),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(hintText: "Enter Description"),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    notesModel.title = titleController.text.toString();
                    notesModel.description =
                        descriptionController.text.toString();
                    await notesModel.save();
                    titleController.clear();
                    descriptionController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pop(context);
                  },
                  child: const Text("Edit")),
            ],
          );
        });
  }

  Future _showDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: "Enter Title"),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(hintText: "Enter Description"),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text,
                        description: descriptionController.text);

                    final box = Boxes.getData();

                    box.add(data);
                    data.save();
                    print(box.values.length);

                    titleController.clear();
                    descriptionController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pop(context);
                  },
                  child: const Text("Add")),
            ],
          );
        });
  }
}
