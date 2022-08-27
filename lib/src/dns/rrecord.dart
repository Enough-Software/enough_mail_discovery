// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

part 'rrecord.g.dart';

@JsonSerializable(includeIfNull: false)
class RRecord {
  const RRecord({
    required this.name,
    required this.rType,
    required this.ttl,
    required this.data,
  });
  factory RRecord.fromJson(Map<String, dynamic> json) =>
      _$RRecordFromJson(json);

  /// The name of the record
  final String name;

  /// The type of the record
  @JsonKey(name: 'type')
  final int rType;

  /// The time to live of the record
  @JsonKey(name: 'TTL')
  final int ttl;

  /// The data of the record
  final String data;

  /*
   * RRecord object to json
   */
  Map<String, dynamic> toJson() => _$RRecordToJson(this);
}
