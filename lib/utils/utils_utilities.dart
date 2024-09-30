class Utilities {
  Utilities(this.bibleVersion);
  final int bibleVersion;

  String getLanguage() {
    return (bibleVersion == 2 || bibleVersion == 4) ? 'lat' : 'eng';
  }

  String getVersionAbbr() {
    String abbr = '';
    switch (bibleVersion) {
      case 1:
        abbr = 'KJV';
        break;
      case 2:
        abbr = 'CLEM';
        break;
      case 3:
        abbr = 'CPDV';
        break;
      case 4:
        abbr = 'NVUL';
        break;
      case 5:
        abbr = '';
        break;
      case 6:
        abbr = '';
        break;
      case 7:
        abbr = 'UKVJ';
        break;
      case 8:
        abbr = 'WEB';
        break;
      case 9:
        abbr = '';
        break;
      case 10:
        abbr = 'ASV';
        break;
      default:
        abbr = '';
    }
    return abbr;
  }
}
