import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';
import 'package:dodjaerrands_driver/core/utils/util.dart';

import '../text/label_text_with_instructions.dart';

class CustomTextField extends StatefulWidget {
  final String? instructions;
  final bool isShowInstructionWidget;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isIcon;
  final VoidCallback? onSuffixTap;
  final bool isSearch;
  final bool isCountryPicker;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool readOnly;
  final bool needRequiredSign;
  final int maxLines;
  final bool animatedLabel;
  final Color fillColor;
  Color? focusColor = MyColor.getTextFieldEnableBorder();
  final bool isRequired;
// edited /20-7-23
  final Widget? suffixWidget;
  final BoxConstraints? suffixIconConstraints;
  final bool? isDense;
  final bool? isPin;
  // edited /29-7-2023
  final bool isborderNone;
  final VoidCallback? onSubmit;
  final VoidCallback? onTap;
  // edited /28-10-2023
  List<TextInputFormatter>? inputFormatters;
  final bool shadowBox;
  double? radius;
  final Widget? prefixIcon;
  CustomTextField(
      {this.isShowInstructionWidget = true,
      this.instructions,
      super.key,
      this.labelText,
      this.labelTextStyle,
      this.readOnly = false,
      this.fillColor = MyColor.transparentColor,
      this.focusColor,
      required this.onChanged,
      this.hintText,
      this.hintTextStyle,
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.validator,
      this.textInputType,
      this.isEnable = true,
      this.isPassword = false,
      this.isShowSuffixIcon = false,
      this.isIcon = false,
      this.onSuffixTap,
      this.isSearch = false,
      this.isCountryPicker = false,
      this.inputAction = TextInputAction.next,
      this.needOutlineBorder = false,
      this.needRequiredSign = false,
      this.maxLines = 1,
      this.animatedLabel = false,
      this.isRequired = false,
      this.suffixWidget,
      this.suffixIconConstraints,
      this.isDense,
      this.isborderNone = false,
      this.isPin = false,
      this.onSubmit,
      this.radius = Dimensions.mediumRadius,
      this.inputFormatters,
      this.shadowBox = false,
      this.onTap,
      this.prefixIcon});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

// build the state
  @override
  Widget build(BuildContext context) {
    return widget.needOutlineBorder
        ? widget.animatedLabel
            ? widget.shadowBox == false
                ? Column(
                    children: [
                      TextFormField(
                        maxLines: widget.maxLines,
                        readOnly: widget.readOnly,
                        style: regularDefault.copyWith(color: MyColor.getTextColor()),
                        //textAlign: TextAlign.left,
                        cursorColor: MyColor.getTextColor(),
                        controller: widget.controller,
                        autofocus: false,
                        textInputAction: widget.inputAction,
                        enabled: widget.isEnable,
                        focusNode: widget.focusNode,
                        validator: widget.validator,
                        keyboardType: widget.textInputType,

                        obscureText: widget.isPassword ? obscureText : false,
                        inputFormatters: widget.inputFormatters,

                        decoration: InputDecoration(
                          errorStyle: regularDefault.copyWith(fontSize: 13, color: MyColor.colorRed),
                          contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 15, end: 15, bottom: 5),
                          labelText: widget.labelText?.tr ?? '',
                          labelStyle: widget.hintTextStyle ?? regularDefault.copyWith(color: MyColor.getRideSubTitleColor()),
                          fillColor: widget.fillColor,
                          filled: true,
                          hintText: widget.hintText?.tr ?? '',
                          hintStyle: widget.hintTextStyle ?? TextStyle(color: MyColor.getRideSubTitleColor()),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: MyColor.primaryColor.withOpacity(0.08),
                            ),
                            borderRadius: BorderRadius.circular(widget.radius!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: widget.focusColor ?? MyColor.getTextFieldEnableBorder(),
                            ),
                            borderRadius: BorderRadius.circular(widget.radius!),
                          ),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: MyColor.primaryColor.withOpacity(0.08)), borderRadius: BorderRadius.circular(widget.radius!)),
                          prefixIconConstraints: BoxConstraints.loose(Size(40, 40)),
                          prefixIcon: widget.prefixIcon,
                          suffixIconConstraints: widget.suffixIconConstraints ?? BoxConstraints(maxHeight: 50, maxWidth: 70, minHeight: 40, minWidth: 50),
                          suffixIcon: widget.isShowSuffixIcon
                              ? widget.isPassword
                                  ? GestureDetector(
                                      onTap: _toggle,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: Center(
                                          child: Text(
                                            (obscureText ? MyStrings.show.tr : MyStrings.hide.tr),
                                            style: boldDefault.copyWith(
                                              color: obscureText ? MyColor.primaryColor : MyColor.hintTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : widget.isIcon
                                      ? IconButton(
                                          onPressed: widget.onSuffixTap,
                                          icon: Icon(
                                            widget.isSearch
                                                ? Icons.search_outlined
                                                : widget.isCountryPicker
                                                    ? Icons.arrow_drop_down_outlined
                                                    : Icons.camera_alt_outlined,
                                            size: 25,
                                            color: MyColor.getPrimaryColor(),
                                          ),
                                        )
                                      : widget.suffixWidget
                              : null,
                        ),
                        onTap: widget.onTap,
                        onFieldSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
                        onChanged: (text) => widget.onChanged!(text),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Container(
                        height: 47,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(widget.radius!), boxShadow: MyUtils.getShadow2(blurRadius: 5)),
                      ),
                      TextFormField(
                        maxLines: widget.maxLines,
                        readOnly: widget.readOnly,
                        style: regularDefault.copyWith(color: MyColor.getTextColor()),
                        textAlign: TextAlign.left,
                        cursorColor: MyColor.colorBlack,
                        controller: widget.controller,
                        autofocus: false,
                        textInputAction: widget.inputAction,
                        enabled: widget.isEnable,
                        focusNode: widget.focusNode,
                        validator: widget.validator,
                        keyboardType: widget.textInputType,
                        obscureText: widget.isPassword ? obscureText : false,
                        decoration: InputDecoration(
                          errorStyle: regularDefault.copyWith(fontSize: 13, color: MyColor.colorRed),
                          contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
                          // labelText: widget.labelText,
                          labelStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor()),
                          fillColor: widget.fillColor,
                          filled: true,
                          prefixIconConstraints: BoxConstraints.loose(Size(40, 40)),
                          border: OutlineInputBorder(borderSide: const BorderSide(color: MyColor.textFieldDisableBorderColor, width: .5), borderRadius: BorderRadius.circular(widget.radius!)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: MyColor.textFieldEnableBorderColor, width: .5), borderRadius: BorderRadius.circular(widget.radius!)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyColor.getTextFieldDisableBorder(), width: 0.5), borderRadius: BorderRadius.circular(widget.radius!)),
                          focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: MyColor.colorRed, width: .5), borderRadius: BorderRadius.circular(widget.radius!)),
                          errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: MyColor.colorRed, width: .5), borderRadius: BorderRadius.circular(widget.radius!)),
                          suffixIconConstraints: widget.suffixIconConstraints ?? BoxConstraints(maxHeight: 50, maxWidth: 50, minHeight: 40, minWidth: 50),
                          suffixIcon: widget.isShowSuffixIcon
                              ? widget.isPassword
                                  ? GestureDetector(
                                      onTap: _toggle,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: Center(
                                          child: Text(
                                            (obscureText ? MyStrings.show.tr : MyStrings.hide.tr),
                                            style: boldDefault.copyWith(
                                              color: obscureText ? MyColor.primaryColor : MyColor.hintTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : widget.isIcon
                                      ? IconButton(
                                          onPressed: widget.onSuffixTap,
                                          icon: Icon(
                                            widget.isSearch
                                                ? Icons.search_outlined
                                                : widget.isCountryPicker
                                                    ? Icons.arrow_drop_down_outlined
                                                    : Icons.camera_alt_outlined,
                                            size: 25,
                                            color: MyColor.getPrimaryColor(),
                                          ),
                                        )
                                      : null
                              : null,
                        ),
                        onFieldSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
                        onChanged: (text) => widget.onChanged!(text),
                      ),
                    ],
                  )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isShowInstructionWidget
                      ? LabelTextInstruction(
                          text: widget.labelText.toString(),
                          isRequired: widget.isRequired,
                          instructions: widget.instructions,
                        )
                      : const SizedBox(),
                  const SizedBox(height: Dimensions.textToTextSpace),
                  TextFormField(
                    maxLines: widget.maxLines,
                    readOnly: widget.readOnly,
                    style: regularDefault.copyWith(color: MyColor.getTextColor()),
                    //textAlign: TextAlign.left,
                    cursorColor: MyColor.getTextColor(),
                    controller: widget.controller,
                    autofocus: false,
                    textInputAction: widget.inputAction,
                    enabled: widget.isEnable,
                    focusNode: widget.focusNode,
                    validator: widget.validator,
                    keyboardType: widget.textInputType,
                    obscureText: widget.isPassword ? obscureText : false,
                    inputFormatters: widget.inputFormatters,

                    decoration: InputDecoration(
                      errorStyle: regularDefault.copyWith(fontSize: 13, color: MyColor.colorRed),
                      contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 15, end: 15, bottom: 5),
                      hintText: widget.hintText != null ? widget.hintText!.tr : '',
                      hintStyle: regularLarge.copyWith(
                        color: MyColor.getHintTextColor().withOpacity(0.7),
                      ),
                      fillColor: widget.fillColor,
                      filled: true,
                      border: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()), borderRadius: BorderRadius.circular(widget.radius!)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: widget.focusColor ?? MyColor.getTextFieldEnableBorder(),
                        ),
                        borderRadius: BorderRadius.circular(widget.radius!),
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()), borderRadius: BorderRadius.circular(widget.radius!)),
                      prefixIcon: widget.prefixIcon,
                      prefixIconConstraints: BoxConstraints.loose(Size(40, 40)),
                      isDense: widget.isDense,
                      suffixIconConstraints: widget.suffixIconConstraints ?? BoxConstraints(maxHeight: 50, maxWidth: 50, minHeight: 40, minWidth: 50),
                      suffixIcon: widget.isShowSuffixIcon
                          ? widget.isPassword
                              ? const SizedBox.shrink()
                              : widget.isIcon
                                  ? IconButton(
                                      onPressed: widget.onSuffixTap,
                                      icon: Icon(
                                        widget.isSearch
                                            ? Icons.search_outlined
                                            : widget.isCountryPicker
                                                ? Icons.arrow_drop_down_outlined
                                                : Icons.camera_alt_outlined,
                                        size: 25,
                                        color: MyColor.getPrimaryColor(),
                                      ),
                                    )
                                  : widget.suffixWidget
                          : null,
                    ),
                    onFieldSubmitted: (text) => widget.nextFocus != null
                        ? FocusScope.of(context).requestFocus(widget.nextFocus)
                        : widget.onSubmit != null
                            ? widget.onSubmit!()
                            : null,
                    onChanged: (text) => widget.onChanged!(text),
                    onTap: widget.onTap,
                  )
                ],
              )
        : widget.isborderNone
            ? TextFormField(
                maxLines: widget.maxLines,
                readOnly: widget.readOnly,
                style: regularDefault.copyWith(color: MyColor.getTextColor()),
                //textAlign: TextAlign.left,
                cursorColor: MyColor.getPrimaryColor(),
                controller: widget.controller,
                autofocus: false,
                textInputAction: widget.inputAction,
                enabled: widget.isEnable,
                focusNode: widget.focusNode,
                validator: widget.validator,
                keyboardType: widget.textInputType,
                obscureText: widget.isPassword ? obscureText : false,
                inputFormatters: widget.inputFormatters,

                decoration: InputDecoration(
                  errorStyle: regularDefault.copyWith(fontSize: 13, color: MyColor.colorRed),
                  isDense: widget.isDense,
                  contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 0, end: 0, bottom: 0),
                  labelText: widget.labelText?.tr,
                  labelStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor()),
                  fillColor: MyColor.transparentColor,
                  filled: true,
                  border: InputBorder.none,
                  hintText: widget.hintText != null ? widget.hintText!.tr : '',
                  hintStyle: regularLarge.copyWith(
                    color: MyColor.getHintTextColor().withOpacity(0.7),
                  ),
                  prefixIconConstraints: BoxConstraints.loose(Size(40, 40)),
                  suffixIconConstraints: widget.suffixIconConstraints ?? BoxConstraints(maxHeight: 50, maxWidth: 50, minHeight: 40, minWidth: 50),
                  suffixIcon: widget.isShowSuffixIcon
                      ? widget.isPassword
                          ? GestureDetector(
                              onTap: _toggle,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Text(
                                  (obscureText ? MyStrings.show.tr : MyStrings.hide.tr),
                                  style: boldDefault.copyWith(
                                    color: obscureText ? MyColor.primaryColor : MyColor.hintTextColor,
                                  ),
                                ),
                              ),
                            )
                          : widget.isIcon
                              ? IconButton(
                                  onPressed: widget.onSuffixTap,
                                  icon: Icon(
                                    widget.isSearch
                                        ? Icons.search_outlined
                                        : widget.isCountryPicker
                                            ? Icons.arrow_drop_down_outlined
                                            : Icons.camera_alt_outlined,
                                    size: 25,
                                    color: MyColor.getPrimaryColor(),
                                  ),
                                )
                              : widget.suffixWidget
                      : null,
                ),
                onFieldSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
                onChanged: (text) => widget.onChanged!(text),
              )
            : TextFormField(
                maxLines: widget.maxLines,
                readOnly: widget.readOnly,
                style: regularDefault,
                //textAlign: TextAlign.left,
                cursorColor: MyColor.getHintTextColor(),
                controller: widget.controller,
                autofocus: false,
                textInputAction: widget.inputAction,
                enabled: widget.isEnable,
                focusNode: widget.focusNode,
                validator: widget.validator,
                keyboardType: widget.textInputType,
                obscureText: widget.isPassword ? obscureText : false,
                inputFormatters: widget.inputFormatters,

                decoration: InputDecoration(
                  errorStyle: regularDefault.copyWith(fontSize: 13, color: MyColor.colorRed),
                  isDense: widget.isDense,
                  contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 0, end: 0, bottom: 5),
                  labelText: widget.labelText?.tr,
                  labelStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor()),
                  fillColor: MyColor.transparentColor,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.5,
                      color: widget.focusColor ?? MyColor.getTextFieldEnableBorder(),
                    ),
                    borderRadius: BorderRadius.circular(widget.radius!),
                  ),
                  prefixIconConstraints: BoxConstraints.loose(Size(40, 40)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder())),
                  suffixIcon: widget.isShowSuffixIcon
                      ? widget.isPassword
                          ? GestureDetector(
                              onTap: _toggle,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Center(
                                  child: Text(
                                    (obscureText ? MyStrings.show.tr : MyStrings.hide.tr),
                                    style: boldDefault.copyWith(
                                      color: obscureText ? MyColor.primaryColor : MyColor.hintTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : widget.isIcon
                              ? IconButton(
                                  onPressed: widget.onSuffixTap,
                                  icon: Icon(
                                    widget.isSearch
                                        ? Icons.search_outlined
                                        : widget.isCountryPicker
                                            ? Icons.arrow_drop_down_outlined
                                            : Icons.camera_alt_outlined,
                                    size: 25,
                                    color: MyColor.getPrimaryColor(),
                                  ),
                                )
                              : widget.suffixWidget
                      : null,
                ),
                onFieldSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
                onChanged: (text) => widget.onChanged!(text),
              );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
