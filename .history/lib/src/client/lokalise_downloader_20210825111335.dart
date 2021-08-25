class LokaliseDownloader {
  LokaliseDownloader({
    required this.apiToken,
    required this.includeTags,
    required this.projectId,
  });
  String apiToken;
  String projectId;
  Iterable<String> includeTags;
}
