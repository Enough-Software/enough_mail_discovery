// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable(includeIfNull: false)
class Question {
  const Question({required this.name, required this.type});

  /*
   * Json to Question object
   */
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  final String name;

  final int type;

  /*
   * Question object to json
   */
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
