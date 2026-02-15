import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocketbase_provider.g.dart';

@riverpod
PocketBase pocketBase(Ref ref) {
  // Replace with your actual PocketBase URL
  return PocketBase('http://127.0.0.1:8090');
}
