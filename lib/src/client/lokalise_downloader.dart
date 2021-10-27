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
      this.filterData,
      this.baseUrl,
      this.branch});
  String apiToken;
  String projectId;
  Iterable<String> includeTags;
  Iterable<String>? filterData;
  String? branch;
  String? baseUrl;
  Downloader downloader = Downloader();

  //Download map of locale and content file
  Future<Map<String, String>> download() async {
    final bundleUrl = await _fetchBundleUrl(
        apiToken: apiToken,
        projectId: projectId,
        includeTags: includeTags,
        filterData: filterData,
        branch: branch);
    final bundleData = await downloader.download(bundleUrl);
    final archive = ZipDecoder().decodeBytes(bundleData);
    return _extractToFiles(archive);
  }

  Map<String, String> _extractToFiles(Archive archive) {
    Map<String, String> files = new Map<String, String>();
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
    Iterable<String>? filterData,
    String? branch,
  }) async {
    final response = await LokaliseClient(
      apiToken: apiToken,
      baseUrl: baseUrl,
    ).download(
      projectId: projectId,
      branch: branch,
      includeTags: includeTags,
      filterData: filterData
    );
    return response.typedBody.bundleUrl;
  }
}
