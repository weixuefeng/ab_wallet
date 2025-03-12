part 'keypair_singer.dart';
part 'privatekey_signer.dart';

base class ABWeb3Signer {

  static ABWeb3PrivateKeySigner fromPrivateKey(String privateKey) {
    return ABWeb3PrivateKeySigner(privateKey);
  }

  static ABWeb3KeypairSigner fromKeypair(String publicKey, String privateKey) {
    return ABWeb3KeypairSigner(privateKey, publicKey);
  }
}
