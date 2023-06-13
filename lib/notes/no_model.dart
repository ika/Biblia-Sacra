
class NtModel {
  int? id;
  String? title;
  String? contents;
  String? lang;
  int? version; // version book number
  String? abbr; // version abbreviation
  int? book; // book number
  int? chapter; // chapter number
  int? verse;
  String? name; // book name
  int? bid; // bible id

  NtModel(
      {this.id,
      this.title,
      this.contents,
      this.lang,
      this.version,
      this.abbr,
      this.book,
      this.chapter,
      this.verse,
      this.name,
      this.bid});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'contents': contents,
        'lang': lang,
        'version': version,
        'abbr': abbr,
        'book': book,
        'chapter': chapter,
        'verse': verse,
        'name': name,
        'bid': bid
      };

  factory NtModel.fromJson(Map<String, dynamic> json) => NtModel(
        id: json['id'],
        title: json['title'],
        contents: json['contents'],
        lang: json['lang'],
        version: json['version'],
        abbr: json['abbr'],
        book: json['book'],
        chapter: json['chapter'],
        verse: json['verse'],
        name: json['name'],
        bid: json['bid'],
      );
}
