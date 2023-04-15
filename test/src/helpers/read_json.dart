import 'dart:io';

String readJson(String name) {
  return File("test/src/helpers/data_dummy/$name").readAsStringSync();
}
