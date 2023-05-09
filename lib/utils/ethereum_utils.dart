// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

final ethUtilsProvider = StateNotifierProvider<EthereumUtils, bool>((ref) {
  return EthereumUtils();
});

class EthereumUtils extends StateNotifier<bool> {
  EthereumUtils() : super(true) {
    initialSetup();
  }

  final String _rpcUrl = "http://127.0.0.1:8545/";
  final String _wsUrl = "ws://127.0.0.1:8545/";
  final String _privateKey = dotenv.env["HARDHAT_PRIVATE_KEY"]!;

  Web3Client? _web3client;
  bool isLoading = true;
  String? _abi;
  EthereumAddress? _contractAddress;
  EthPrivateKey? _credentials;
  DeployedContract? _contract;
  ContractFunction? _setName;
  ContractFunction? _getUserName;
  String? deployedName;

  initialSetup() async {
    http.Client _httpClient = http.Client();
    _web3client = Web3Client(_rpcUrl, _httpClient, socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("artifacts/contracts/Lock.sol/Lock.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abi = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        //EthereumAddress.fromHex(jsonAbi["networks"]["31337"]["address"]);
        EthereumAddress.fromHex("0x5FbDB2315678afecb367f032d93F642f64180aa3");
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abi!, "Lock"), _contractAddress!);
    _setName = _contract!.function("setName");
    _getUserName = _contract!.function("getUserName");
    //setName(nameToSet);
    getUserName();
  }

// ContractFunction? _setName;
  setName(String nameToSet) async {
    isLoading = true;
    state = isLoading;
    await _web3client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _setName!,
            parameters: [nameToSet]));
    getUserName();
  }

// ContractFunction? _getuserName;
  getUserName() async {
    var currentName = await _web3client!
        .call(contract: _contract!, function: _getUserName!, params: []);
    deployedName = currentName[0];
    isLoading = false;
    state = isLoading;
    //getUserName();
  }
}
