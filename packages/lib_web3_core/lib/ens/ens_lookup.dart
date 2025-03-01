import 'dart:typed_data';

import 'package:lib_web3_core/ens/model/errors.dart';
import 'package:lib_web3_core/ens/utils/address_utils.dart';
import 'package:lib_web3_core/ens/utils/hash_utils.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

/// Address of ENSRegistryWithFallback
const _mainnetEnsAddressContact = "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e";

/// The ENS namespace includes both .eth names (which are native to ENS) and DNS names imported into ENS.
/// Because the DNS suffix namespace expands over time, a hardcoded list of name suffixes for recognizing ENS names will
/// regularly be out of date, leading to your application not recognizing all valid ENS names. To remain future-proof,
/// a correct integration of ENS treats any dot-separated name as a potential ENS name and will attempt a look-up.
///
/// via https://github.com/ensdomains/docs/blob/master/dapp-developer-guide/resolving-names.md#resolving-names
final _domainRegExp = RegExp(r"^[a-zA-Z0-9-.]+$");

abstract class EnsLookup {
  static EnsLookup create(Web3Client client) => EnsLookupImpl(client: client);

  /// Returns ethereum address if ENS name can be resolved.
  /// throws InvalidEnsName if domain is invalid
  Future<String?> resolveName(String domain);
}

class EnsLookupImpl extends EnsLookup {
  EnsLookupImpl({required this.client, this.ensContractAddress = _mainnetEnsAddressContact});

  final Web3Client client;
  final String ensContractAddress;

  @override
  Future<String?> resolveName(String domain) async {
    if (!_domainRegExp.hasMatch(domain)) throw InvalidEnsName();

    // Get the resolver from the registry
    final resolverAddress = await _getResolver(domain);
    if (resolverAddress == null) return null;

    // keccak256('addr(bytes32)')
    final nodeHash = hashDomainName(domain);
    final hexDataStr = '0x3b3b57de${nodeHash.substring(2)}';
    final data = hexToBytes(hexDataStr);

    final value = await _callContract(resolverAddress, data);

    if (value.length != 66) return null;
    final result = hexToAddress(value);

    if (result == "0x0000000000000000000000000000000000000000") return null;
    return result;
  }

  /// Returns the entity resolver contract that corresponds to the given settings
  Future<String?> _getResolver(String domain) async {
    final nodeHash = hashDomainName(domain);

    final hexDataStr = '0x0178b8bf${nodeHash.substring(2)}';
    final data = hexToBytes(hexDataStr);

    final value = await _callContract(ensContractAddress, data);

    if (value.length != 66) return null;
    final resolverAddress = hexToAddress(value);

    if (resolverAddress == "0x0000000000000000000000000000000000000000") return null;
    return resolverAddress;
  }

  Future<String> _callContract(String to, Uint8List data) =>
      client.callRaw(contract: EthereumAddress.fromHex(to), data: data);
}
