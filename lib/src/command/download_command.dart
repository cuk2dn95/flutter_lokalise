import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:args/args.dart';
import 'package:flutter_lokalise/src/client/downloader.dart';
import 'package:flutter_lokalise/src/client/lokalise_client.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

import 'arg_results_extension.dart';
import 'flutter_lokalise_command.dart';

class DownloadCommand extends FlutterLokaliseCommand<Null> {
  final Logger _logger = Logger.root;
  final Downloader _downloader;
  final String? _baseUrl;

  @override
  String get description => "Downloads translation files from Lokalise.";

  @override
  String get name => "download";

  DownloadCommand({
    Downloader? downloader,
    String? baseUrl,
  })  : _downloader = downloader ?? Downloader(),
        _baseUrl = baseUrl {
    _DownloadArgResults.addOptions(argParser);
  }

  @override
  FutureOr<Null> run() async {
    final config = commandRunner.lokaliseConfig;
    final flutterLokaliseArgResults = commandRunner.flutterLokaliseArgResults;
    final downloadArgResults = _DownloadArgResults.fromArgResults(
      argResults!,
      fallbackOutput: config.output,
      fallbackIncludeTags: config.includeTags,
    );

    final bundleUrl = await _fetchBundleUrl(
      apiToken: flutterLokaliseArgResults!.apiToken!,
      projectId: flutterLokaliseArgResults.projectId!,
      includeTags: downloadArgResults.includeTags!,
    );

    final bundleData = await _downloader.download(bundleUrl);
    final archive = ZipDecoder().decodeBytes(bundleData);
    _convertArchiveToJsonFiles(archive, downloadArgResults.output!);
  }

  Future<String> _fetchBundleUrl({
    required String apiToken,
    required String projectId,
    required Iterable<String> includeTags,
  }) async {
    final response = await LokaliseClient(
      apiToken: apiToken,
      baseUrl: _baseUrl,
    ).download(
      projectId: projectId,
      includeTags: includeTags,
    );
    _logger.fine(response.typedBody);
    return response.typedBody.bundleUrl;
  }

  void _convertArchiveToJsonFiles(Archive archive, String output) {
    archive
        .where((it) => it.isFile && path.extension(it.name) == ".json")
        .forEach((it) {
      final data = it.content as List<int>;
      final jsonString = Utf8Decoder().convert(data);
      final locale = path.basenameWithoutExtension(it.name);
   
      File("$output/$locale.json")
        ..createSync(recursive: true)
        ..writeAsStringSync(
            _unescape(jsonString));
    });
  }

  String _unescape(String input) {
    return input.replaceAll(r'\\n', r'\n');
  }
}

class _DownloadArgResults {
  final String? output;
  final Iterable<String>? includeTags;

  _DownloadArgResults.fromArgResults(
    ArgResults results, {
    String? fallbackOutput,
    Iterable<String>? fallbackIncludeTags,
  })  : output = results.get("output", orElse: fallbackOutput),
        includeTags = results.get("include-tags", orElse: fallbackIncludeTags);

  static void addOptions(ArgParser argParser) {
    argParser.addOption(
      "output",
      abbr: "o",
      help: "destination for ARB files",
      defaultsTo: "lib/l10n",
    );
    argParser.addMultiOption(
      "include-tags",
      abbr: "t",
      help: "tags to filter the keys by",
    );
  }
}
