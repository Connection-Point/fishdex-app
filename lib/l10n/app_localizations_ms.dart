// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'FishDex';

  @override
  String get navDex => 'FishDex';

  @override
  String get navScan => 'Imbas';

  @override
  String get navJournal => 'Jurnal';

  @override
  String get navCatalogue => 'Katalog';

  @override
  String get navProfile => 'Profil';

  @override
  String get loginTitle => 'Selamat kembali, kaki pancing';

  @override
  String get loginSubtitle => 'Tangkap. Imbas. Kumpul.';

  @override
  String get email => 'E-mel';

  @override
  String get password => 'Kata laluan';

  @override
  String get signIn => 'Log masuk';

  @override
  String get createAccount => 'Daftar akaun';

  @override
  String get noAccount => 'Baru di FishDex?';

  @override
  String get haveAccount => 'Sudah ada akaun?';

  @override
  String get forgotPassword => 'Lupa kata laluan?';

  @override
  String get continueWithGoogle => 'Teruskan dengan Google';

  @override
  String get or => 'atau';

  @override
  String get registerTitle => 'Mulakan FishDex anda';

  @override
  String get displayName => 'Nama paparan';

  @override
  String get handle => 'Nama pengguna';

  @override
  String get handleHelp => 'Huruf, nombor dan _ sahaja. Akan dilihat oleh orang lain.';

  @override
  String get passwordHelp => 'Sekurang-kurangnya 8 aksara.';

  @override
  String get resetSent => 'Jika akaun wujud untuk e-mel itu, pautan tetapan semula sedang dihantar.';

  @override
  String get required => 'Wajib diisi';

  @override
  String get invalidEmail => 'Masukkan e-mel yang sah';

  @override
  String get passwordTooShort => 'Sekurang-kurangnya 8 aksara';

  @override
  String get invalidHandle => '3–30 huruf, nombor atau _';

  @override
  String get searchHint => 'Cari toman, haruan, Channa…';

  @override
  String get filterAll => 'Semua';

  @override
  String get freshwater => 'Air tawar';

  @override
  String get brackish => 'Air payau';

  @override
  String get marine => 'Laut';

  @override
  String get native => 'Asli';

  @override
  String get endemic => 'Endemik';

  @override
  String get introduced => 'Diperkenalkan';

  @override
  String get invasive => 'Invasif';

  @override
  String get uncertain => 'Tidak pasti';

  @override
  String get noSpeciesFound => 'Tiada ikan sepadan dengan carian itu.';

  @override
  String get loadError => 'Gagal dimuatkan. Semak sambungan anda.';

  @override
  String get retry => 'Cuba lagi';

  @override
  String get stateUnseen => 'Belum dijumpai';

  @override
  String get stateSeen => 'Pernah dilihat';

  @override
  String get stateCollected => 'Dikumpul';

  @override
  String get identification => 'Cara mengenal pasti';

  @override
  String get habitat => 'Habitat';

  @override
  String get distribution => 'Taburan';

  @override
  String get origin => 'Asal usul';

  @override
  String get conservation => 'Status pemuliharaan';

  @override
  String get conservationNone => 'Belum ada penilaian direkodkan.';

  @override
  String get lookalikes => 'Sering disalah anggap sebagai';

  @override
  String get alsoKnownAs => 'Juga dikenali sebagai';

  @override
  String get family => 'Famili';

  @override
  String get maxLength => 'Panjang maksimum';

  @override
  String get protectedSpecies => 'Spesies dilindungi';

  @override
  String get rarityNote => 'Kejarangan menunjukkan betapa sukar ikan ini dijumpai — bukan tahap keterancamannya.';

  @override
  String get allStates => 'Direkodkan di seluruh Malaysia';

  @override
  String get consentTitle => 'Sebelum imbasan pertama anda';

  @override
  String get consentBody =>
      'FishDex dalam beta tertutup. Gambar ikan yang anda imbas dihantar ke AI Gemini Google pada peringkat percuma, di mana Google boleh menggunakannya untuk menambah baik produknya dan manusia mungkin menyemaknya.';

  @override
  String get consentPoint1 => 'Ambil gambar ikan sahaja — elakkan wajah, nombor plat dan dokumen.';

  @override
  String get consentPoint2 => 'Kami tidak sekali-kali menghantar nama, e-mel atau lokasi tepat anda kepada AI.';

  @override
  String get consentPoint3 => 'Anda boleh memadam akaun dan gambar anda pada bila-bila masa.';

  @override
  String get consentAccept => 'Saya faham — aktifkan imbasan';

  @override
  String get consentLater => 'Bukan sekarang';

  @override
  String get comingSoon => 'Akan datang dalam binaan beta seterusnya';

  @override
  String get scanIntro => 'Halakan kamera ke arah ikan untuk mengenal pastinya dan menambahnya ke FishDex anda.';

  @override
  String get enableScanning => 'Aktifkan imbasan AI';

  @override
  String get scanningEnabled => 'Imbasan AI telah diaktifkan';

  @override
  String get language => 'Bahasa';

  @override
  String get scansToday => 'Imbasan hari ini';

  @override
  String scansLeft(int remaining, int limit) {
    return '$remaining daripada $limit berbaki';
  }

  @override
  String get signOut => 'Log keluar';

  @override
  String get deleteAccount => 'Padam akaun';

  @override
  String get deleteAccountBody =>
      'Akaun, gambar dan koleksi anda akan dipadam secara kekal selepas 30 hari. Log masuk semula sebelum itu akan membatalkan pemadaman.';

  @override
  String get deleteAccountConfirm => 'Padam akaun saya';

  @override
  String get cancel => 'Batal';

  @override
  String get betaBadge => 'Beta tertutup';
}
