// Version Key Model

class VkModel {
  int? i; // id
  int? n; // bible version number
  int? a; // active
  String? r; // version abbreviation
  String? l; // version language
  String? m; // version name

  VkModel({this.i, this.n, this.a, this.r, this.l, this.m});

  factory VkModel.fromJson(Map<String, dynamic> json) => VkModel(
        i: json['id'],
        n: json['number'],
        a: json['active'],
        r: json['abbr'],
        l: json['lang'],
        m: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': i,
        'number': n,
        'active': a,
        'abbr': r,
        'lang': l,
        'name': m,
      };

}
