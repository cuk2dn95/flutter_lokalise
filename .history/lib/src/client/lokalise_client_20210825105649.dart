import 'dart:convert';
import 'dart:io';

import 'package:flutter_lokalise/src/client/files_download_request_body.dart';
import 'package:http/http.dart';

import 'files_download_response_body.dart';
import 'lokalise_response.dart';

class LokaliseClient {
  static const _xApiTokenHeader = "x-api-token";

  final String _apiToken;
  final Client _client;
  final String _baseUrl;

  LokaliseClient({
    required String apiToken,
    Client? client,
    String? baseUrl,
  })  : _apiToken = apiToken,
        _client = client ?? Client(),
        _baseUrl = baseUrl ?? "https://api.lokalise.com/api2";

  Future<LokaliseResponse<FilesDownloadResponseBody>> download({
    required String projectId,
    String? branch,
    Iterable<String>? includeTags,
  }) async {
    final requestBody = FilesDownloadRequestBody(
      format: "json",
      includeTags: includeTags,
    );
    final response = await _client.post(
        Uri.parse("$_baseUrl/projects/${branch != null ? projectId: : }/files/download"),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          _xApiTokenHeader: _apiToken,
        },
        body: jsonEncode(requestBody.toJson()));
    return LokaliseResponse.from(
        response, (json) => FilesDownloadResponseBody.fromJson(json));
  }
}
