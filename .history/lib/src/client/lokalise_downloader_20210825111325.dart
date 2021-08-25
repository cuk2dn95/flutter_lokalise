class LokaliseDownloader {
  LokaliseDownloader({
    this.apiToken, 
    this.includeTags,
    this.projectId,
  });
  String apiToken;
  String projectId;
  Iterable<String> includeTags;
}
