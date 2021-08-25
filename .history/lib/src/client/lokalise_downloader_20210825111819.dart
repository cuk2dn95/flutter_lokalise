import 'package:flutter_lokalise/src/client/lokalise_client.dart';

class LokaliseDownloader {
  LokaliseDownloader(
      {required this.apiToken,
      required this.includeTags,
      required this.projectId,
      this.branch});
  String apiToken;
  String projectId;
  Iterable<String> includeTags;
  String? branch;
  String? b



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
}
