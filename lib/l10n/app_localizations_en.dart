// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FishDex';

  @override
  String get navDex => 'FishDex';

  @override
  String get navScan => 'Scan';

  @override
  String get navJournal => 'Journal';

  @override
  String get navCatalogue => 'Catalogue';

  @override
  String get navProfile => 'Profile';

  @override
  String get loginTitle => 'Welcome back, angler';

  @override
  String get loginSubtitle => 'Catch it. Scan it. Collect it.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get noAccount => 'New to FishDex?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get or => 'or';

  @override
  String get registerTitle => 'Start your FishDex';

  @override
  String get displayName => 'Display name';

  @override
  String get handle => 'Username';

  @override
  String get handleHelp => 'Letters, numbers and _ only. Others will see this.';

  @override
  String get passwordHelp => 'At least 8 characters.';

  @override
  String get resetSent => 'If an account exists for that email, a reset link is on its way.';

  @override
  String get required => 'Required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordTooShort => 'At least 8 characters';

  @override
  String get invalidHandle => '3–30 letters, numbers or _';

  @override
  String get searchHint => 'Search toman, haruan, Channa…';

  @override
  String get filterAll => 'All';

  @override
  String get freshwater => 'Freshwater';

  @override
  String get brackish => 'Brackish';

  @override
  String get marine => 'Marine';

  @override
  String get native => 'Native';

  @override
  String get endemic => 'Endemic';

  @override
  String get introduced => 'Introduced';

  @override
  String get invasive => 'Invasive';

  @override
  String get uncertain => 'Uncertain';

  @override
  String get noSpeciesFound => 'No fish match that search.';

  @override
  String get loadError => 'Couldn\'t load. Check your connection.';

  @override
  String get retry => 'Retry';

  @override
  String get stateUnseen => 'Not yet found';

  @override
  String get stateSeen => 'Seen';

  @override
  String get stateCollected => 'Collected';

  @override
  String get identification => 'How to identify';

  @override
  String get habitat => 'Habitat';

  @override
  String get distribution => 'Where it\'s found';

  @override
  String get origin => 'Origin';

  @override
  String get conservation => 'Conservation status';

  @override
  String get conservationNone => 'No assessment recorded yet.';

  @override
  String get lookalikes => 'Often confused with';

  @override
  String get alsoKnownAs => 'Also known as';

  @override
  String get family => 'Family';

  @override
  String get maxLength => 'Max length';

  @override
  String get protectedSpecies => 'Protected species';

  @override
  String get rarityNote => 'Rarity shows how hard a fish is to find — not how endangered it is.';

  @override
  String get allStates => 'Recorded across Malaysia';

  @override
  String get consentTitle => 'Before your first scan';

  @override
  String get consentBody =>
      'FishDex is in closed beta. Fish photos you scan are sent to Google\'s Gemini AI on its free tier, where Google may use them to improve its products and people may review them.';

  @override
  String get consentPoint1 => 'Photograph the fish — avoid faces, car plates and documents.';

  @override
  String get consentPoint2 => 'We never send your name, email or exact location to the AI.';

  @override
  String get consentPoint3 => 'You can delete your account and photos at any time.';

  @override
  String get consentAccept => 'I understand — enable scanning';

  @override
  String get consentLater => 'Not now';

  @override
  String get comingSoon => 'Coming in the next beta build';

  @override
  String get scanIntro => 'Point your camera at a fish to identify it and add it to your FishDex.';

  @override
  String get enableScanning => 'Enable AI scanning';

  @override
  String get scanningEnabled => 'AI scanning is enabled';

  @override
  String get language => 'Language';

  @override
  String get scansToday => 'Scans today';

  @override
  String scansLeft(int remaining, int limit) {
    return '$remaining of $limit left';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountBody =>
      'Your account, photos and collection will be permanently deleted after 30 days. Signing in again before then cancels the deletion.';

  @override
  String get deleteAccountConfirm => 'Delete my account';

  @override
  String get cancel => 'Cancel';

  @override
  String get betaBadge => 'Closed beta';
}
