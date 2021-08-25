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

  //DOwnload map of locale and content file
  Future<Map<String, String>> download() async {
    final bundleUrl = await _fetchBundleUrl(
        apiToken: apiToken,
        projectId: projectId,
        includeTags: includeTags,
        branch: branch);
    final bundleData = await downloader.download(bundleUrl);
    final archive = ZipDecoder().decodeBytes(bundleData);
    return extractToFiles(archive);
  }

  Future<Map<String, String>> extractToFiles(Archive archive) {
    Map<String, String> files = new Map<String, String>();
     archive
        .where((it) => it.isFile && path.extension(it.name) == ".json")
        .forEach((it) {
      final data = it.content as List<int>;
      final jsonString = Utf8Decoder().convert(data);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final locale = path.basenameWithoutExtension(it.name);
      final arbMap = converter.toArb(
        json: json,
        locale: locale,
      );
      File("$output/intl_$locale.arb")
        ..createSync(recursive: true)
        ..writeAsStringSync(
            _unescape(JsonEncoder.withIndent("  ").convert(arbMap)));
    });
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
