// Bible Database Model

class Bible {
  int id; // id
  int b; // book
  int c; // chapter
  int v; // verse
  String t; // text

  Bible({this.id, this.b, this.c, this.v, this.t});

  Map<String, dynamic> toJson() =>
      {'id': id, 'b': b, 'c': c, 'v': v, 't': t};

  factory Bible.fromJson(Map<String, dynamic> json) => Bible(
      id: json['id'],
      b: json['b'],
      c: json['c'],
      v: json['v'],
      t: json['t']);
}

// class Bible {
//   int id; // id
//   int b; // book
//   int c; // chapter
//   int v; // verse
//   //int m; // bookmark
//   String t; // text

//   Bible({this.id, this.b, this.c, this.v, this.m, this.t});

//   Map<String, dynamic> toJson() =>
//       {'id': id, 'b': b, 'c': c, 'v': v, 'm': m, 't': t};

//   factory Bible.fromJson(Map<String, dynamic> json) => Bible(
//       id: json['id'],
//       b: json['b'],
//       c: json['c'],
//       v: json['v'],
//       m: json['m'],
//       t: json['t']);
// }
