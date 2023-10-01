import 'package:cliffordproperty/Helpers/Nav_Helper.dart';
import 'package:cliffordproperty/Screens/Filter.dart';
import 'package:cliffordproperty/Widgets/My_Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MySearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String value)? onChange;
  final Function(String value)? onSubmit;
  final bool hasTrailing;
  final bool hasPadding;

  const MySearchBar(
      {this.hasTrailing = true,
      this.hasPadding = false,
      this.onChange,
      this.onSubmit,
      this.controller,
      super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> with Nav_Helper {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  String text = '';
  @override
  Widget build(BuildContext context) {
    widget.controller?.text = text;
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    return Padding(
      padding: widget.hasPadding
          ? EdgeInsets.symmetric(horizontal: 16.w)
          : EdgeInsets.zero,
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChange,
        onSubmitted: widget.onSubmit,
        decoration: InputDecoration(
          filled: true,
          hintText: appLocale.searchHint,
          suffixIcon: widget.hasTrailing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          text = '';
                          _speechToText.listen(
                            listenMode: ListenMode.search,
                            onResult: (result) {
                              setState(() {
                                text += '${result.recognizedWords} ';
                              });
                            },
                          );
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    const Text('Listening'),
                                    Icon(Icons.mic, size: 64.h),
                                    SizedBox(height: 32.h),
                                    My_Button(
                                      buttonText: 'End listening',
                                      onTap: () {
                                        _speechToText.stop();
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                          setState(() {});
                        },
                        child: SvgPicture.asset('assets/images/Voice.svg')),
                    SizedBox(width: 8.w),
                    GestureDetector(
                        onTap: () => jump(context, const Filter()),
                        child: SvgPicture.asset('assets/images/Filter.svg')),
                    SizedBox(width: 8.w),
                  ],
                )
              : const SizedBox.shrink(),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: SvgPicture.asset('assets/images/search_icon.svg'),
          ),
          fillColor: const Color(0xffF1F1F2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
