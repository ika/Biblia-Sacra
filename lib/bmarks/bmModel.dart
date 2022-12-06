// BookMark Model

class BmModel {
  int id;
  String title;
  String subtitle;
  String lang;
  int version; // version book number
  String abbr; // version abbreviation
  int book; // book number
  int chapter; // chapter number
  int verse;
  String name; // book name

  BmModel(
      {this.id,
      this.title,
      this.subtitle,
      this.lang,
      this.version,
      this.abbr,
      this.book,
      this.chapter,
      this.verse,
      this.name});
  
    factory BmModel.fromJson(Map<String, dynamic> json) => BmModel(
        id: json['id'],
        title: json['title'],
        subtitle: json['subtitle'],
        lang: json['lang'],
        version: json['version'],
        abbr: json['abbr'],
        book: json['book'],
        chapter: json['chapter'],
        verse: json['verse'],
        name: json['name']
      );

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
      'name': name
      };
}
