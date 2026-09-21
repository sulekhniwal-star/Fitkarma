import 'package:supabase_flutter/supabase_flutter.dart';

/// Normalized domain representation of an authenticated FitKarma user.
class FitKarmaUser {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final bool isEmailVerified;
  final String? provider;
  final DateTime? createdAt;

  const FitKarmaUser({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.isEmailVerified = false,
    this.provider,
    this.createdAt,
  });

  factory FitKarmaUser.fromSupabase(User user) {
    final meta = user.userMetadata ?? {};
    final String? fullName = meta['full_name'] as String? ?? meta['name'] as String?;
    final String? avatarUrl = meta['avatar_url'] as String? ?? meta['picture'] as String?;
    final String? provider = user.appMetadata['provider'] as String?;

    return FitKarmaUser(
      id: user.id,
      email: user.email ?? '',
      fullName: fullName,
      avatarUrl: avatarUrl,
      isEmailVerified: user.emailConfirmedAt != null,
      provider: provider,
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }
}
