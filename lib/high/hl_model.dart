// hi_model.dart

class HlModel {
  int? id;
  String? title;
  String? subtitle;
  String? lang;
  int? version; // version book number
  String? abbr; // version abbreviation
  int? book; // book number
  int? chapter; // chapter number
  int? verse;
  String? name; // book name
  int? bid; // bible id

  HlModel(
      {this.id,
      this.title,
      this.subtitle,
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
        'subtitle': subtitle,
        'lang': lang,
        'version': version,
        'abbr': abbr,
        'book': book,
        'chapter': chapter,
        'verse': verse,
        'name': name,
        'bid': bid
      };

  factory HlModel.fromJson(Map<String, dynamic> json) => HlModel(
        id: json['id'],
        title: json['title'],
        subtitle: json['subtitle'],
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
