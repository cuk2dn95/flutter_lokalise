import 'package:flutter_lokalise/src/client/downloader.dart';
import 'package:flutter_lokalise/src/client/lokalise_client.dart';

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


  Future<String,


  Future<String> _fetchBundleUrl({
    required String apiToken,
    required String projectId,
    required Iterable<String> includeTags,
  }) async {
    final response = await LokaliseClient(
      apiToken: apiToken,
      baseUrl: baseUrl,
    ).download(
      projectId: projectId,
      includeTags: includeTags,
    );
    return response.typedBody.bundleUrl;
  }
}
