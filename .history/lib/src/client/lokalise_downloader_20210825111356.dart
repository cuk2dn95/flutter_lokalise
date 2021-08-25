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



  
}
