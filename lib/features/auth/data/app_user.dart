import '../../../core/api/json.dart';

class ScanQuota {
  const ScanQuota({required this.limit, required this.used, required this.remaining, this.resetsAt});

  final int limit;
  final int used;
  final int remaining;
  final DateTime? resetsAt;

  factory ScanQuota.fromJson(Json j) =>
      ScanQuota(limit: j.integer('limit'), used: j.integer('used'), remaining: j.integer('remaining'), resetsAt: j.date('resets_at'));
}

class AppUser {
  const AppUser({
    required this.id,
    required this.handle,
    required this.displayName,
    required this.email,
    required this.emailVerified,
    required this.country,
    required this.locale,
    required this.plan,
    required this.betaAiConsent,
    this.homeRegion,
    this.avatarUrl,
    this.scanQuota,
  });

  final String id;
  final String handle;
  final String displayName;
  final String email;
  final bool emailVerified;
  final String country;
  final String? homeRegion;
  final String locale;
  final String plan;
  final bool betaAiConsent;
  final String? avatarUrl;
  final ScanQuota? scanQuota;

  factory AppUser.fromJson(Json j) => AppUser(
    id: j.str('id'),
    handle: j.str('handle'),
    displayName: j.str('display_name'),
    email: j.str('email'),
    emailVerified: j.boolean('email_verified'),
    country: j.str('country', 'MY'),
    homeRegion: j.strOrNull('home_region'),
    locale: j.str('locale', 'en'),
    plan: j.str('plan', 'free'),
    betaAiConsent: j.boolean('beta_ai_consent'),
    avatarUrl: j.obj('avatar')?.strOrNull('url'),
    scanQuota: j.obj('scan_quota') == null ? null : ScanQuota.fromJson(j.obj('scan_quota')!),
  );
}
