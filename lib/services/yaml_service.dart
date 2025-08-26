import 'dart:io';
import 'package:yaml/yaml.dart';

class YamlService {
  static Map readYamlFile(String path) {
    final file = File(path);
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      return loadYaml(content);
    }
    return {};
  }
}
