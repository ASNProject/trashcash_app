import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashcash_app/theme/box_shadows.dart';

enum TextInputFieldSize {
  sm,
  md,
}

class TextInputField extends StatefulWidget {
  final String? label;
  final String? errorText;
  final String? hintText;
  final Widget? prefixIconAssetName;
  final String? prefixText;
  final String? prefixAddOnText;
  final bool prefixUseMastercard;
  final String? suffixIconAssetName;
  final String? suffixErrorIconAssetName;
  final VoidCallback? onTapSuffix;
  final TextInputFieldSize size;

  final bool enabled;
  final bool isRequired;
  final String? helperText;

  final TextEditingController? controller;
  final String? initialValue;

  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  final TextInputAction? textInputAction;

  final bool autofocus;

  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;

  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })? buildCounter;

  final ScrollPhysics? scrollPhysics;

  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;

  const TextInputField({
    super.key,
    this.label,
    this.errorText,
    this.hintText,
    this.enabled = true,
    this.helperText,
    this.size = TextInputFieldSize.md,
    this.prefixIconAssetName,
    this.prefixText,
    this.prefixAddOnText,
    this.prefixUseMastercard = false,
    this.suffixIconAssetName,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.maxLengthEnforcement,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.cursorHeight,
    this.cursorRadius,
    this.keyboardAppearance,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.mouseCursor,
    this.enableIMEPersonalizedLearning = true,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.cursorWidth = 2.0,
    this.maxLines = 1,
    this.obscuringCharacter = '•',
    this.enableSuggestions = true,
    this.expands = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.autofocus = false,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.suffixErrorIconAssetName = "",
    this.onTapSuffix,
    this.focusNode,
    this.isRequired = false,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
    }
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry contentPadding;
    EdgeInsetsGeometry prefixAddOnTextContentPadding;
    if (widget.size == TextInputFieldSize.sm) {
      contentPadding = const EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 12.0,
      );
      prefixAddOnTextContentPadding = const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 12.0,
      );

    } else {
      contentPadding = const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 14.0,
      );
      prefixAddOnTextContentPadding = const EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 14.0,
      );
    }

    // Color suffixIconColor;
    // String? suffixIcon;
    // if (widget.enabled && widget.errorText != null) {
    //   suffixIconColor = Colors.red;
    //   suffixIcon = widget.suffixErrorIconAssetName;
    // } else {
    //   suffixIconColor = Colors.grey;
    //   suffixIcon = widget.suffixIconAssetName;
    // }

    Widget? prefixWidget;
    if (widget.prefixText != null) {
      prefixWidget = FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 8.0,
          ),
          child: Center(
            child: Text(
              widget.prefixText!,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      );
    } else if (widget.prefixIconAssetName != null) {
      prefixWidget = FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 8.0,
          ),
          child: widget.prefixIconAssetName!,
        ),
      );
    } else if (widget.prefixAddOnText != null) {
      prefixWidget = FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          margin: const EdgeInsets.only(
            right: 12.0,
          ),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: widget.errorText == null
                    ? Colors.grey
                    : Colors.red,
              ),
            ),
            // color: Colors.yellow,
          ),
          child: Padding(
            padding: prefixAddOnTextContentPadding,
            child: Center(
              child: Text(
                widget.prefixAddOnText!,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    // else if (widget.prefixUseMastercard) {
    //
    //   prefixWidget = FittedBox(
    //     fit: BoxFit.fitHeight,
    //     child: Padding(
    //       padding: prefixMastercardContentPadding,
    //       child: Center(
    //         child: SvgPicture.asset(
    //           'packages/elevarm_ui/assets/images/mastercard.svg',
    //           height: 34.0,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? TextInputField(
                label: widget.label!,
                isRequired: widget.isRequired,
              )
            : Container(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: !_isFocused
                ? BoxShadows.xs
                : [
                    const BoxShadow(
                      color: Color.fromRGBO(16, 24, 40, 0.05),
                      offset: Offset(1.0, 0.0),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                    ),
                    BoxShadow(
                      color: widget.errorText == null
                          ? const Color(0xFFEBF1FF)
                          : const Color(0xFFFEE4E2),
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 4.0,
                    ),
                  ],
          ),
          child: TextFormField(
            enabled: widget.enabled,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            cursorColor: widget.errorText == null
                ? Colors.green
                : Colors.red,
            focusNode: _focusNode,
            decoration: InputDecoration(
              isDense: true,
              counterText: '',
              contentPadding: contentPadding,
              fillColor: widget.enabled
                  ? Colors.white
                  : Colors.grey,
              filled: true,
              hintText: widget.hintText,
              hintStyle:GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w100,
                ),
              ),
              border: widget.errorText == null
                  ? OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    )
                  : OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
              enabledBorder: widget.errorText == null
                  ? OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    )
                  : OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: widget.errorText == null
                  ? OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    )
                  : OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
              prefixIcon: prefixWidget,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0.0,
                minHeight: 0.0,
              ),
              // suffixIcon: suffixIcon != null
              //     ? FittedBox(
              //         fit: BoxFit.scaleDown,
              //         child: IconButton(
              //           onPressed: widget.onTapSuffix,
              //           icon: ElevarmIcon(
              //             suffixIcon,
              //             color: suffixIconColor,
              //             height: 16.0,
              //             width: 16.0,
              //           ),
              //         ),
              //       )
              //     : null,
            ),
            controller: widget.controller,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            showCursor: widget.showCursor,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onEditingComplete: widget.onEditingComplete,
            onFieldSubmitted: widget.onFieldSubmitted,
            onSaved: widget.onSaved,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            cursorHeight: widget.cursorHeight,
            cursorRadius: widget.cursorRadius,
            keyboardAppearance: widget.keyboardAppearance,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            selectionControls: widget.selectionControls,
            buildCounter: widget.buildCounter,
            scrollPhysics: widget.scrollPhysics,
            autofillHints: widget.autofillHints,
            autovalidateMode: widget.autovalidateMode,
            scrollController: widget.scrollController,
            restorationId: widget.restorationId,
            mouseCursor: widget.mouseCursor,
            enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
            scrollPadding: widget.scrollPadding,
            cursorWidth: widget.cursorWidth,
            maxLines: widget.maxLines,
            obscuringCharacter: widget.obscuringCharacter,
            enableSuggestions: widget.enableSuggestions,
            expands: widget.expands,
            obscureText: widget.obscureText,
            autocorrect: widget.autocorrect,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            textCapitalization: widget.textCapitalization,
          ),
        ),
        widget.helperText != null &&
                (widget.errorText == null || !widget.enabled)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6.0),
                  Text(
                    widget.helperText!,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
        widget.errorText != null && widget.enabled
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6.0),
                  Text(
                    widget.errorText!,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
