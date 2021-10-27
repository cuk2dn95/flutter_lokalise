import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaml/yaml.dart';

part 'lokalise_config.freezed.dart';

@freezed
class LokaliseConfig with _$LokaliseConfig {
  const factory LokaliseConfig(
      {String? projectId,
      String? apiToken,
      Iterable<String>? includeTags,
      Iterable<String>? filterData,
      String? keyFile,
      String? output,
      String? branch}) = _LokaliseConfig;

  factory LokaliseConfig.fromPubspecYamlString(String yamlString) {
    final yaml = loadYamlNode(yamlString);
    final flutterLokalise = yaml.getOrNull<YamlMap>("flutter_lokalise");
    return LokaliseConfig(
      projectId: flutterLokalise?.getAsStringOrNull("project_id"),
      apiToken: flutterLokalise?.getAsStringOrNull("api_token"),
      filterData: flutterLokalise
          ?.getOrNull<YamlList>("filter_data")
          ?.cast()
          .map((it) => it.toString()),
      keyFile: flutterLokalise?.getAsStringOrNull("key_file"),
      includeTags: flutterLokalise
          ?.getOrNull<YamlList>("include_tags")
          ?.cast()
          .map((it) => it.toString()),
      branch: flutterLokalise?.getAsStringOrNull("branch"),
      output: flutterLokalise?.getAsStringOrNull("output"),
    );
  }
}

extension _YamlNodeExtension on YamlNode {
  T? getOrNull<T>(String key) {
    final node = _getNode(key);
    return node is T ? node : null;
  }

  String? getAsStringOrNull(String key) => _getNode(key)?.toString();

  Object? _getNode(String key) {
    if (this is! YamlMap) return null;
    return (this as YamlMap)[key];
  }
}
