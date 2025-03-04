class ABOridinalsInfo {
  late String tick;

  ABOridinalsInfo({required this.tick});

  toJson() {
    return {'tick': tick};
  }

  factory ABOridinalsInfo.fromJson(Map<String, dynamic> json) {
    return ABOridinalsInfo(tick: json['tick']);
  }
}
