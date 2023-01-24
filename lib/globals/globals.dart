class Globals {
  //----initial read-----------------------
  static int bibleVersion = 1; // KJV bible version
  static String bibleLang = 'eng'; // Bible language
  static String versionAbbr = 'KJV'; // version abbreviation KJV
  //static String versionName = 'King James Version';  // version full name
  static int bibleBook = 43; // Gospel of John
  //static int bookNameIndex = 42; // index is one less that book number
  static int bookChapter = 1; // Chapter
  static int chapterVerse = 1; // Verse
  static String bookName = 'John'; // Book name
  //--------------------------------------

  static String verseText; // for Dialogue
  static int verseNumber; // for Dialogue

  // Bookmarks and Highlights
  static bool scrollToVerse = false;
  static bool initialScroll = false;

  // Dialog height
  static double dialogHeight = 0.0;

  // SelectorCubit
  static String selectorText = bookName;

  // colorListNumber
  static int colorListNumber = 12; //Blue

  // Dictionary mode
  static bool dictionaryMode = false;
  static String dictionaryLookup = '';

  // Text Size
  static double initialTextSize = 16;

  // Active Version count
  static int activeVersionCount = 0;
}
