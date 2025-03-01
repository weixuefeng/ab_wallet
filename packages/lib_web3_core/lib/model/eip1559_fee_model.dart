import 'dart:convert';

class Eip1559Fee {
  /// The constructor.
  Eip1559Fee({
    required this.maxPriorityFeePerGas, // low /avg/fast
    required this.maxFeePerGas, //  用不到
    required this.estimatedGas, // low /avg/fast  + base
    this.baseFee,
  });

  /// Creates a [Eip1559Fee] from JSON data.
  factory Eip1559Fee.fromJson(Map<String, dynamic> json) {
    final maxPriorityFeePerGas = json['maxPriorityFeePerGas'];
    final maxFeePerGas = json['maxFeePerGas'];
    final estimatedGas = json['estimatedGas'];
    final baseFee = json['baseFee'];

    if (maxPriorityFeePerGas == null || maxPriorityFeePerGas is! String) {
      throw Exception();
    }

    if (maxFeePerGas == null || maxFeePerGas is! String) {
      throw Exception();
    }

    if (estimatedGas == null || estimatedGas is! String) {
      throw Exception();
    }

    return Eip1559Fee(
      maxPriorityFeePerGas: BigInt.parse(maxPriorityFeePerGas),
      maxFeePerGas: BigInt.parse(maxFeePerGas),
      estimatedGas: BigInt.parse(estimatedGas),
      baseFee: BigInt.parse(baseFee),
    );
  }

  static Eip1559Fee zero() {
    return Eip1559Fee(
      maxPriorityFeePerGas: BigInt.zero,
      maxFeePerGas: BigInt.zero,
      estimatedGas: BigInt.zero,
      baseFee: BigInt.zero,
    );
  }

  /// Converts the [Fee] object to JSON map.
  Map<String, dynamic> toJson() => {
    'maxPriorityFeePerGas': maxPriorityFeePerGas.toString(),
    'maxFeePerGas': maxFeePerGas.toString(),
    'estimatedGas': estimatedGas.toString(),
    'baseFee': baseFee.toString(),
  };

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  /// Max priority fee per gas.
  final BigInt maxPriorityFeePerGas;

  /// Max fee per gas.
  final BigInt maxFeePerGas;

  /// Estimated gas.
  final BigInt estimatedGas;

  /// baseFee.
  BigInt? baseFee = BigInt.zero;
}
