// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailsPhotos _$DetailsPhotosFromJson(Map<String, dynamic> json) =>
    DetailsPhotos(
      backdrops: (json['backdrops'] as List<dynamic>)
          .map((e) => Backdrops.fromJson(e as Map<String, dynamic>))
          .toList(),
      logos: (json['logos'] as List<dynamic>)
          .map((e) => Logos.fromJson(e as Map<String, dynamic>))
          .toList(),
      posters: (json['posters'] as List<dynamic>)
          .map((e) => Posters.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailsPhotosToJson(DetailsPhotos instance) =>
    <String, dynamic>{
      'backdrops': instance.backdrops.map((e) => e.toJson()).toList(),
      'logos': instance.logos.map((e) => e.toJson()).toList(),
      'posters': instance.posters.map((e) => e.toJson()).toList(),
    };

Backdrops _$BackdropsFromJson(Map<String, dynamic> json) => Backdrops(
  height: (json['height'] as num).toInt(),
  filePath: json['file_path'] as String,
  width: (json['width'] as num).toInt(),
  aspectRatio: (json['aspect_ratio'] as num).toDouble(),
  iso: json['iso_639_1'] as String?,
  voteAverage: (json['vote_average'] as num).toDouble(),
  voteCount: (json['vote_count'] as num).toInt(),
);

Map<String, dynamic> _$BackdropsToJson(Backdrops instance) => <String, dynamic>{
  'aspect_ratio': instance.aspectRatio,
  'height': instance.height,
  'iso_639_1': instance.iso,
  'file_path': instance.filePath,
  'vote_average': instance.voteAverage,
  'vote_count': instance.voteCount,
  'width': instance.width,
};

Logos _$LogosFromJson(Map<String, dynamic> json) => Logos(
  height: (json['height'] as num).toInt(),
  filePath: json['file_path'] as String,
  width: (json['width'] as num).toInt(),
  aspectRatio: (json['aspect_ratio'] as num).toDouble(),
  iso: json['iso_639_1'] as String?,
  voteAverage: (json['vote_average'] as num).toDouble(),
  voteCount: (json['vote_count'] as num).toInt(),
);

Map<String, dynamic> _$LogosToJson(Logos instance) => <String, dynamic>{
  'aspect_ratio': instance.aspectRatio,
  'height': instance.height,
  'iso_639_1': instance.iso,
  'file_path': instance.filePath,
  'vote_average': instance.voteAverage,
  'vote_count': instance.voteCount,
  'width': instance.width,
};

Posters _$PostersFromJson(Map<String, dynamic> json) => Posters(
  height: (json['height'] as num).toInt(),
  filePath: json['file_path'] as String,
  width: (json['width'] as num).toInt(),
  aspectRatio: (json['aspect_ratio'] as num).toDouble(),
  iso: json['iso_639_1'] as String?,
  voteAverage: (json['vote_average'] as num).toDouble(),
  voteCount: (json['vote_count'] as num).toInt(),
);

Map<String, dynamic> _$PostersToJson(Posters instance) => <String, dynamic>{
  'aspect_ratio': instance.aspectRatio,
  'height': instance.height,
  'iso_639_1': instance.iso,
  'file_path': instance.filePath,
  'vote_average': instance.voteAverage,
  'vote_count': instance.voteCount,
  'width': instance.width,
};
