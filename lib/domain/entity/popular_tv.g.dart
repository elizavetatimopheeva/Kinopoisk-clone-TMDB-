// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_tv.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularTVResponse _$PopularTVResponseFromJson(Map<String, dynamic> json) =>
    PopularTVResponse(
      page: (json['page'] as num).toInt(),
      tv: (json['results'] as List<dynamic>)
          .map((e) => TV.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$PopularTVResponseToJson(PopularTVResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.tv.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
