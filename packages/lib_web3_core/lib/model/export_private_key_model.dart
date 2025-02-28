// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExportPrivateKeyParams {
  String privateKeyHex = "";
  String password = "";
  ExportPrivateKeyParams({required this.privateKeyHex, required this.password});

  ExportPrivateKeyParams copyWith({String? privateKeyHex, String? password}) {
    return ExportPrivateKeyParams(
      privateKeyHex: privateKeyHex ?? this.privateKeyHex,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'privateKeyHex': privateKeyHex, 'password': password};
  }

  factory ExportPrivateKeyParams.fromMap(Map<String, dynamic> map) {
    return ExportPrivateKeyParams(privateKeyHex: map['privateKeyHex'] as String, password: map['password'] as String);
  }

  String toJson() => json.encode(toMap());

  factory ExportPrivateKeyParams.fromJson(String source) =>
      ExportPrivateKeyParams.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ExportPrivateKeyParams(privateKeyHex: $privateKeyHex, password: $password)';

  @override
  bool operator ==(covariant ExportPrivateKeyParams other) {
    if (identical(this, other)) return true;

    return other.privateKeyHex == privateKeyHex && other.password == password;
  }

  @override
  int get hashCode => privateKeyHex.hashCode ^ password.hashCode;
}
