import 'package:flutter_hive_example/models/notes_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>("notes");
}