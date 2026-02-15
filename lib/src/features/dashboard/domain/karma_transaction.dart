import 'package:freezed_annotation/freezed_annotation.dart';

part 'karma_transaction.freezed.dart';
part 'karma_transaction.g.dart';

@freezed
abstract class KarmaTransaction with _$KarmaTransaction {
  const factory KarmaTransaction({
    required String id,
    required String user,
    required double amount,
    required String actionType,
    required String description,
    required DateTime date,
  }) = _KarmaTransaction;

  factory KarmaTransaction.fromJson(Map<String, dynamic> json) =>
      _$KarmaTransactionFromJson(json);
}
