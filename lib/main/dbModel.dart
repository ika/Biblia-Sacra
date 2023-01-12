// Bible Database Model

class Bible {
  int id; // id
  int b; // book
  int c; // chapter
  int v; // verse
  String t; // text
  int n; // note
  int m; // bookmark

  Bible({this.id, this.b, this.c, this.v, this.t, this.n, this.m});

  Map<String, dynamic> toJson() => {
        'id': id,
        'b': b,
        'c': c,
        'v': v,
        't': t,
        'n': n,
        'm': m,
      };

  factory Bible.fromJson(Map<String, dynamic> json) => Bible(
        id: json['id'],
        b: json['b'],
        c: json['c'],
        v: json['v'],
        t: json['t'],
        n: json['n'],
        m: json['m'],
      );
}
