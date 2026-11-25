import '../../../l10n/app_localizations.dart';

/// Client-side checks mirror the API rules so most mistakes are caught before a round trip.
class Validators {
  Validators(this.l);
  final AppLocalizations l;

  String? required(String? v) => (v == null || v.trim().isEmpty) ? l.required : null;

  String? email(String? v) {
    if (v == null || v.trim().isEmpty) return l.required;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()) ? null : l.invalidEmail;
  }

  String? newPassword(String? v) => (v == null || v.length < 8) ? l.passwordTooShort : null;

  String? handle(String? v) => (v == null || !RegExp(r'^[a-zA-Z0-9_]{3,30}$').hasMatch(v.trim())) ? l.invalidHandle : null;
}
