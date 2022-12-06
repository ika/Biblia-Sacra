class NtModel {
  int id;
  String title;
  String contents;
  int bid; // bible id

  NtModel({this.id, this.title, this.contents, this.bid});

  factory NtModel.fromJson(Map<String, dynamic> json) => NtModel(
        id: json["id"],
        title: json["title"],
        contents: json["contents"],
        bid: json["bid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "contents": contents,
        "bid": bid,
      };
}
