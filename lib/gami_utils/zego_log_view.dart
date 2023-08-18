import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class ZegoLog {
  factory ZegoLog() => _instance;
  void clearnLog() {
    _logController.sink.add("clearn Log");
  }

  void addLog(String log) {
    print(log);
    _logController.sink.add(log);
  }

  void _setListener(Function(String) func) {
    _stream.listen(func);
  }

  ZegoLog._() {
    _logController = StreamController<String>();
    _stream = _logController.stream.asBroadcastStream();

    ZegoExpressEngine.onApiCalledResult = (errorCode, funcName, info) {
      ZegoLog().addLog(
          '🚩 📥 onApiCalledResult, errorCode: $errorCode, funcName: $funcName, info: $info');
    };
  }
  static final ZegoLog _instance = ZegoLog._();

  late StreamController<String> _logController;
  late Stream<String> _stream;
}

class ZegoLogView extends StatefulWidget {
  const ZegoLogView({Key? key, this.logs}) : super(key: key);

  final List<String>? logs;

  @override
  State<ZegoLogView> createState() => _ZegoLogViewState();
}

class _ZegoLogViewState extends State<ZegoLogView> {
  late List<String> _logs;
  late List<String> _showLogs;
  late bool _isDispose;
  // late String _filer;
  late final ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _logs = widget.logs ?? [];
    _showLogs = [];
    onFilter(true);
    // _filer = "";
    _controller = ScrollController();

    ZegoLog()._setListener(onUpdate);

    _isDispose = false;
  }

  @override
  void dispose() {
    super.dispose();
    _isDispose = true;
    _logs.clear();
    _showLogs.clear();
  }

  void onFilter([bool isInit = false]) {
    if (_filer.isNotEmpty) {
      _showLogs = _logs.where((log) {
        if (log.contains(_filer)) {
          return true;
        }
        return false;
      }).toList();
    } else {
      _showLogs = _logs;
    }
    if (!isInit) {
      setState(() {});
    }
  }

  void onUpdate(String log) {
    if (_isDispose) {
      _logs.clear();
      _showLogs.clear();
    } else {
      if (log == "clearn Log") {
        _logs.clear();
        _showLogs.clear();
      } else {
        _logs.add(log);
      }
      onFilter();
      Timer(Duration(milliseconds: 10),
          (() => _controller.jumpTo(_controller.position.maxScrollExtent)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onDoubleTap: onTap,
      child: Container(
          color: Colors.black,
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  controller: _controller,
                  child: SelectableText(_showLogs.join('\n'),
                      style: TextStyle(color: Colors.white),
                      scrollPhysics: NeverScrollableScrollPhysics())))),
    ));
  }

  void onTap() {
    showDialog(
        context: context,
        builder: (context) {
          return ZegoLogWidget(
            key: ValueKey(DateTime.now()),
            logs: _logs,
            onFilter: (filter) {
              _filer = filter;
              onFilter();
            },
            onClear: () {
              setState(() {
                _logs.clear();
                _showLogs.clear();
              });
            },
          );
        });
  }
}

class ZegoLogWidget extends StatefulWidget {
  const ZegoLogWidget({Key? key, this.logs, this.onFilter, this.onClear})
      : super(key: key);

  final List<String>? logs;
  final Function(String filter)? onFilter;
  final Function()? onClear;

  @override
  State<ZegoLogWidget> createState() => _ZegoLogWidgetState();
}

class _ZegoLogWidgetState extends State<ZegoLogWidget> {
  late List<String> _logs;
  late List<String> _showLogs;
  late bool _isDispose;
  // static String _filer = '';

  late final ScrollController _controller;
  late TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    _logs = [];
    if (widget.logs != null) {
      _logs.addAll(widget.logs!.where((element) => true));
    }
    _showLogs = _logs;

    _controller = ScrollController();

    _textEditingController = TextEditingController();
    _textEditingController.text = _filer;

    onFilter(true);

    ZegoLog()._setListener(onUpdate);

    _isDispose = false;
  }

  @override
  void dispose() {
    super.dispose();
    _isDispose = true;
  }

  void onFilter([bool isInit = false]) {
    if (_filer.isNotEmpty) {
      _showLogs = _logs.where((log) {
        if (log.contains(_filer)) {
          return true;
        }
        return false;
      }).toList();
    } else {
      _showLogs = _logs;
    }
    if (!isInit) {
      widget.onFilter?.call(_filer);
    }
  }

  void onCopy() {
    Clipboard.setData(ClipboardData(text: _showLogs.join('\n')));
  }

  void onClear() {
    setState(() {
      _logs.clear();
      _showLogs.clear();
    });
    widget.onClear?.call();
  }

  void onUpdate(String log) {
    if (_isDispose) {
      _logs.clear();
      _showLogs.clear();
    } else {
      if (log == "clearn Log") {
        _logs.clear();
        _showLogs.clear();
      } else {
        _logs.add(log);
      }
      onFilter();

      setState(() {});
      Timer(Duration(milliseconds: 10),
          (() => _controller.jumpTo(_controller.position.maxScrollExtent)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.black,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                // SelectableText(_showLogs.join('\n'),
                //     style: TextStyle(color: Colors.white)),
                SingleChildScrollView(
                    controller: _controller,
                    child: SelectableText(_showLogs.join('\n'),
                        style: TextStyle(color: Colors.white),
                        scrollPhysics: NeverScrollableScrollPhysics())),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    // alignment: Alignment.center,
                                    titlePadding: EdgeInsets.zero,
                                    contentPadding: EdgeInsets.all(12.0),
                                    children: [
                                      TextField(
                                        controller: _textEditingController,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10.0),
                                            isDense: true,
                                            labelText: 'Log Filter:',
                                            labelStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14.0),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff0e88eb)))),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              12.0, 12.0, 12.0, 0.0),
                                          child: TextButton(
                                            onPressed: () {
                                              _filer = _textEditingController
                                                  .text
                                                  .trim();
                                              onFilter();
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue)),
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            'Filter',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey)),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: TextButton(
                              onPressed: onCopy,
                              child: Text(
                                'Copy',
                                style: TextStyle(color: Colors.red),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey)),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: TextButton(
                              onPressed: onClear,
                              child: Text(
                                'Clear',
                                style: TextStyle(color: Colors.red),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey)),
                            ))
                      ],
                    )
                  ],
                )
              ],
            )));
  }
}

String _filer = '';
