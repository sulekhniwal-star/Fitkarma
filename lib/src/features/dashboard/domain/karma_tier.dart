import 'package:freezed_annotation/freezed_annotation.dart';

part 'karma_tier.freezed.dart';
part 'karma_tier.g.dart';

@freezed
abstract class KarmaTier with _$KarmaTier {
  const factory KarmaTier({
    required String id,
    required String name,
    required int minPoints,
    required List<String> benefits,
    String? badgeIcon,
  }) = _KarmaTier;

  factory KarmaTier.fromJson(Map<String, dynamic> json) =>
      _$KarmaTierFromJson(json);
}
