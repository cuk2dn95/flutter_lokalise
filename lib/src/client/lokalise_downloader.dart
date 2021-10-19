import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:flutter_lokalise/src/client/downloader.dart';
import 'package:flutter_lokalise/src/client/lokalise_client.dart';
import 'package:path/path.dart' as path;

class LokaliseDownloader {
  LokaliseDownloader(
      {required this.apiToken,
      required this.includeTags,
      required this.projectId,
      this.baseUrl,
      this.branch});
  String apiToken;
  String projectId;
  Iterable<String> includeTags;
  String? branch;
  String? baseUrl;
  Downloader downloader = Downloader();

  //Download map of locale and content file
  Future<Map<String, dynamic>> download() async {
    final bundleUrl = await _fetchBundleUrl(
        apiToken: apiToken,
        projectId: projectId,
        includeTags: includeTags,
        branch: branch);
    final bundleData = await downloader.download(bundleUrl);
    final archive = ZipDecoder().decodeBytes(bundleData);
    return _extractToFiles(archive);
  }

  Map<String, dynamic> _extractToFiles(Archive archive) {
    Map<String, dynamic> files = new Map<String, dynamic>();
    archive
        .where((it) => it.isFile && path.extension(it.name) == ".json")
        .forEach((it) {
      final data = it.content as List<int>;
      final jsonString = Utf8Decoder().convert(data);
      final locale = path.basename(it.name);
      files.putIfAbsent(locale, () => jsonString);
    });
    return files;
  }

  Future<String> _fetchBundleUrl({
    required String apiToken,
    required String projectId,
    required Iterable<String> includeTags,
    String? branch,
  }) async {
    final response = await LokaliseClient(
      apiToken: apiToken,
      baseUrl: baseUrl,
    ).download(
      projectId: projectId,
      branch: branch,
      includeTags: includeTags,
    );
    return response.typedBody.bundleUrl;
  }
}
