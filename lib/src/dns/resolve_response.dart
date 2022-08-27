// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

import 'question.dart';
import 'rrecord.dart';

part 'resolve_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ResolveResponse {
  const ResolveResponse({
    this.status,
    this.tc,
    this.rd,
    this.ra,
    this.ad,
    this.cd,
    this.question,
    this.answer,
    this.comment,
  });

  /// Create [ResolveResponse] from [json]
  factory ResolveResponse.fromJson(Map<String, dynamic> json) =>
      _$ResolveResponseFromJson(json);

  @JsonKey(name: 'Status')
  final int? status;
  @JsonKey(name: 'TC')
  final bool? tc;
  @JsonKey(name: 'RD')
  final bool? rd;
  @JsonKey(name: 'RA')
  final bool? ra;
  @JsonKey(name: 'AD')
  final bool? ad;
  @JsonKey(name: 'CD')
  final bool? cd;
  @JsonKey(name: 'Question')
  final List<Question>? question;
  @JsonKey(name: 'Answer')
  final List<RRecord>? answer;
  @JsonKey(name: 'Comment')
  final String? comment;

  /*
   * ResolveResponse object to json
   */
  Map<String, dynamic> toJson() => _$ResolveResponseToJson(this);
}
