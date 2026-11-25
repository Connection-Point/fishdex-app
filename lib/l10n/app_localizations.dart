import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ms')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FishDex'**
  String get appTitle;

  /// No description provided for @navDex.
  ///
  /// In en, this message translates to:
  /// **'FishDex'**
  String get navDex;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get navJournal;

  /// No description provided for @navCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Catalogue'**
  String get navCatalogue;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, angler'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Catch it. Scan it. Collect it.'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'New to FishDex?'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Start your FishDex'**
  String get registerTitle;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @handle.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get handle;

  /// No description provided for @handleHelp.
  ///
  /// In en, this message translates to:
  /// **'Letters, numbers and _ only. Others will see this.'**
  String get handleHelp;

  /// No description provided for @passwordHelp.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters.'**
  String get passwordHelp;

  /// No description provided for @resetSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for that email, a reset link is on its way.'**
  String get resetSent;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @invalidHandle.
  ///
  /// In en, this message translates to:
  /// **'3–30 letters, numbers or _'**
  String get invalidHandle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search toman, haruan, Channa…'**
  String get searchHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @freshwater.
  ///
  /// In en, this message translates to:
  /// **'Freshwater'**
  String get freshwater;

  /// No description provided for @brackish.
  ///
  /// In en, this message translates to:
  /// **'Brackish'**
  String get brackish;

  /// No description provided for @marine.
  ///
  /// In en, this message translates to:
  /// **'Marine'**
  String get marine;

  /// No description provided for @native.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get native;

  /// No description provided for @endemic.
  ///
  /// In en, this message translates to:
  /// **'Endemic'**
  String get endemic;

  /// No description provided for @introduced.
  ///
  /// In en, this message translates to:
  /// **'Introduced'**
  String get introduced;

  /// No description provided for @invasive.
  ///
  /// In en, this message translates to:
  /// **'Invasive'**
  String get invasive;

  /// No description provided for @uncertain.
  ///
  /// In en, this message translates to:
  /// **'Uncertain'**
  String get uncertain;

  /// No description provided for @noSpeciesFound.
  ///
  /// In en, this message translates to:
  /// **'No fish match that search.'**
  String get noSpeciesFound;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load. Check your connection.'**
  String get loadError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @stateUnseen.
  ///
  /// In en, this message translates to:
  /// **'Not yet found'**
  String get stateUnseen;

  /// No description provided for @stateSeen.
  ///
  /// In en, this message translates to:
  /// **'Seen'**
  String get stateSeen;

  /// No description provided for @stateCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get stateCollected;

  /// No description provided for @identification.
  ///
  /// In en, this message translates to:
  /// **'How to identify'**
  String get identification;

  /// No description provided for @habitat.
  ///
  /// In en, this message translates to:
  /// **'Habitat'**
  String get habitat;

  /// No description provided for @distribution.
  ///
  /// In en, this message translates to:
  /// **'Where it\'s found'**
  String get distribution;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @conservation.
  ///
  /// In en, this message translates to:
  /// **'Conservation status'**
  String get conservation;

  /// No description provided for @conservationNone.
  ///
  /// In en, this message translates to:
  /// **'No assessment recorded yet.'**
  String get conservationNone;

  /// No description provided for @lookalikes.
  ///
  /// In en, this message translates to:
  /// **'Often confused with'**
  String get lookalikes;

  /// No description provided for @alsoKnownAs.
  ///
  /// In en, this message translates to:
  /// **'Also known as'**
  String get alsoKnownAs;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @maxLength.
  ///
  /// In en, this message translates to:
  /// **'Max length'**
  String get maxLength;

  /// No description provided for @protectedSpecies.
  ///
  /// In en, this message translates to:
  /// **'Protected species'**
  String get protectedSpecies;

  /// No description provided for @rarityNote.
  ///
  /// In en, this message translates to:
  /// **'Rarity shows how hard a fish is to find — not how endangered it is.'**
  String get rarityNote;

  /// No description provided for @allStates.
  ///
  /// In en, this message translates to:
  /// **'Recorded across Malaysia'**
  String get allStates;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'Before your first scan'**
  String get consentTitle;

  /// No description provided for @consentBody.
  ///
  /// In en, this message translates to:
  /// **'FishDex is in closed beta. Fish photos you scan are sent to Google\'s Gemini AI on its free tier, where Google may use them to improve its products and people may review them.'**
  String get consentBody;

  /// No description provided for @consentPoint1.
  ///
  /// In en, this message translates to:
  /// **'Photograph the fish — avoid faces, car plates and documents.'**
  String get consentPoint1;

  /// No description provided for @consentPoint2.
  ///
  /// In en, this message translates to:
  /// **'We never send your name, email or exact location to the AI.'**
  String get consentPoint2;

  /// No description provided for @consentPoint3.
  ///
  /// In en, this message translates to:
  /// **'You can delete your account and photos at any time.'**
  String get consentPoint3;

  /// No description provided for @consentAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand — enable scanning'**
  String get consentAccept;

  /// No description provided for @consentLater.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get consentLater;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming in the next beta build'**
  String get comingSoon;

  /// No description provided for @scanIntro.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at a fish to identify it and add it to your FishDex.'**
  String get scanIntro;

  /// No description provided for @enableScanning.
  ///
  /// In en, this message translates to:
  /// **'Enable AI scanning'**
  String get enableScanning;

  /// No description provided for @scanningEnabled.
  ///
  /// In en, this message translates to:
  /// **'AI scanning is enabled'**
  String get scanningEnabled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @scansToday.
  ///
  /// In en, this message translates to:
  /// **'Scans today'**
  String get scansToday;

  /// No description provided for @scansLeft.
  ///
  /// In en, this message translates to:
  /// **'{remaining} of {limit} left'**
  String scansLeft(int remaining, int limit);

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Your account, photos and collection will be permanently deleted after 30 days. Signing in again before then cancels the deletion.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccountConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @betaBadge.
  ///
  /// In en, this message translates to:
  /// **'Closed beta'**
  String get betaBadge;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ms':
      return AppLocalizationsMs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
