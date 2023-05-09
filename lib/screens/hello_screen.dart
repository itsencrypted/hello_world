import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/ethereum_utils.dart';
import '../components/custom_text.dart';

final imageOpacityProvider = StateProvider<double>((ref) => 1.0);

class HelloScreen extends ConsumerStatefulWidget {
  const HelloScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HelloScreenState createState() => _HelloScreenState();
}

class _HelloScreenState extends ConsumerState<HelloScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focusNode.hasFocus.toString()}");
    if (_focusNode.hasFocus) {
      ref.read(imageOpacityProvider.notifier).state = 0.4;
    } else {
      ref.read(imageOpacityProvider.notifier).state = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ethUtilsProvider);

    final ethUtils = ref.watch(ethUtilsProvider.notifier);
    final imageOpacity = ref.watch(imageOpacityProvider);

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          ref.read(imageOpacityProvider) == 1.0;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const CustomText(text: "Hello World!"),
            centerTitle: true,
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.white],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
                child: ethUtils.isLoading
                    ? const CircularProgressIndicator()
                    : Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            widthFactor: 1.2,
                            child: Opacity(
                              opacity: imageOpacity,
                              child:
                                  Image.asset('assets/images/hello_image.png'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Flexible(
                                        flex: 1,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "HELLO",
                                            style: TextStyle(
                                                fontSize: 60,
                                                color: Colors.blue),
                                          ),
                                        )),
                                    Flexible(
                                        flex: 1,
                                        child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: CustomText(
                                                text: ethUtils.deployedName!))),
                                    const SizedBox(height: 50),
                                    TextField(
                                      focusNode: _focusNode,
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter a name',
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.lightBlueAccent,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32)))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue),
                                        onPressed: () {
                                          if (_nameController.text.isEmpty) {
                                            return;
                                          }
                                          ethUtils
                                              .setName(_nameController.text);
                                          ref.read(imageOpacityProvider) == 1.0;
                                          _nameController.clear();
                                        },
                                        child: const Text(
                                          'Set Name',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
          ),
        ));
  }
}
