part of 'signer.dart';

final class ABWeb3KeypairSigner extends ABWeb3PrivateKeySigner {
  final String publickKey;
  ABWeb3KeypairSigner(super.privateKey, this.publickKey);
}
