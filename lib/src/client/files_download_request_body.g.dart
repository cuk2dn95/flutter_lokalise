// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_download_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FilesDownloadRequestBody _$_$_FilesDownloadRequestBodyFromJson(
    Map<String, dynamic> json) {
  return _$_FilesDownloadRequestBody(
    format: json['format'] as String,
    originalFilenames: json['original_filenames'] as bool?,
    allPlatforms: json['all_platforms'] as bool?,
    replaceBreaks: json['replace_breaks'] as bool?,
    pluralFormat: json['plural_format'] as String?,
    exportEmptyAs: json['export_empty_as'] as String?,
    placeholderFormat: json['placeholder_format'] as String?,
    includeTags:
        (json['include_tags'] as List<dynamic>?)?.map((e) => e as String),
    filterData:
        (json['filter_data'] as List<dynamic>?)?.map((e) => e as String),
    includeComments: json['include_comments'] as bool?,
    includeDescription: json['include_description'] as bool?,
    jsonUnescapedSlashes: json['json_unescaped_slashes'] as bool?,
  );
}

Map<String, dynamic> _$_$_FilesDownloadRequestBodyToJson(
        _$_FilesDownloadRequestBody instance) =>
    <String, dynamic>{
      'format': instance.format,
      'original_filenames': instance.originalFilenames,
      'all_platforms': instance.allPlatforms,
      'replace_breaks': instance.replaceBreaks,
      'plural_format': instance.pluralFormat,
      'export_empty_as': instance.exportEmptyAs,
      'placeholder_format': instance.placeholderFormat,
      'include_tags': instance.includeTags?.toList(),
      'filter_data': instance.filterData?.toList(),
      'include_comments': instance.includeComments,
      'include_description': instance.includeDescription,
      'json_unescaped_slashes': instance.jsonUnescapedSlashes,
    };
