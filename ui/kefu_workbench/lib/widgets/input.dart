
import 'dart:io';

import '../core_flutter.dart';

typedef BoolCallBack = Function(bool b);
class Input extends StatefulWidget{

  Input({
    Key key,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.placeholder,
    this.obscureText = false,
    this.width,
    this.height,
    this.bgColor = Colors.transparent,
    this.border = const Border(bottom: BorderSide(width: 1.0, color: Color(0xfff3f3f3))),
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.minLines = 1,
    this.controller,
    this.focusNode,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.onEditingComplete,
    this.textInputAction,
    this.showClear = false,
    this.maxHeight = double.infinity,
    this.onClear,
    this.isToUpperCase = false,
    this.onFocus,
    this.enabled = true,
    this.onClick,
    this.counterText = "",
    this.textMaxLength,
    this.style,
    this.placeholderAlignment,
    this.contentPadding
  }) : super(key : key);


  final TextStyle style;
  final BoolCallBack onFocus;
  final int maxLength;
  final int textMaxLength;
  final bool showClear;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final bool obscureText;
  final double width;
  final double height;
  final Color bgColor;
  final BoxBorder border;
  final TextAlign textAlign;
  final int maxLines;
  final int minLines;
  final TextEditingController controller;
  final FocusNode focusNode;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry contentPadding;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final VoidCallback onEditingComplete;
  final VoidCallback onClear;
  final TextInputAction textInputAction;
  final bool isToUpperCase;
  final double maxHeight;
  final bool enabled;
  final VoidCallback onClick;
  final String counterText;
  final AlignmentGeometry placeholderAlignment;


  @override
  State<StatefulWidget> createState() {
    return _InputState();
  }


}

class _InputState extends State<Input>{

  TextEditingController controller;
  FocusNode focusNode;
  bool isShowClear = false;
  double maxHeight = double.infinity;
  double minHeight = ToPx.size(90);
  bool isInputEmpty = false;
  bool isShowVisibility = false;
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    if(mounted){
      if(widget.height != null) minHeight = widget.height;
      if(widget.maxHeight != null && widget.maxHeight > minHeight) maxHeight = widget.maxHeight;
      obscureText = widget.obscureText;
      if(widget.obscureText) isShowVisibility = true;
      setState(() {});

      // 判断外部是否给控制器
      if(widget.controller == null){
        controller = TextEditingController();
      }else{
        controller = widget.controller;
      }

      // 监听输入框判断是否显示清除按钮
      controller.addListener(() async{
        // 清除按钮
        if(controller.value.text.length == 0){
          isShowClear = false;
          isInputEmpty = false;
        }else{
          if(widget.showClear) isShowClear = true;
          isInputEmpty = true;
        }
        // 判断长度截取掉
        if(widget.maxLength != null && controller.value.text.length > widget.maxLength && Platform.isAndroid){
          controller.text = controller.value.text.substring(0, widget.maxLength);
          controller.selection = TextSelection.collapsed(offset: widget.maxLength);
        }
        setState(() {});
      });

      // 判断外部是否给focusNode
      if(widget.focusNode == null){
        focusNode = FocusNode();
      }else{
        focusNode = widget.focusNode;
      }
      focusNode.addListener((){
        // 判断长度截取掉
        if(widget.maxLength != null && controller.value.text.length > widget.maxLength && Platform.isIOS){
          controller.text = controller.value.text.substring(0, widget.maxLength);
          controller.selection = TextSelection.collapsed(offset: widget.maxLength);
        }
        if(widget.onFocus != null) widget.onFocus(focusNode.hasFocus);
        if(!focusNode.hasFocus && widget.isToUpperCase){
          controller.text = controller.value.text.toUpperCase();
        }
        controller.text = controller.value.text.trim();
      });
      
      if(controller.value.text.length > 0){
        isInputEmpty = true;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    if(widget.controller == null){
      controller?.dispose();
    }
    if(widget.focusNode == null){
      focusNode?.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
      ),
      child: GestureDetector(
        onTap: widget.onClick,
        child: SizedBox(
          width: widget.width == null ? MediaQuery.of(context).size.width : widget.width,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                width: widget.width == null ? MediaQuery.of(context).size.width : widget.width,
                padding: widget.padding,
                constraints: BoxConstraints(
                    minHeight:  minHeight,
                    maxHeight:  maxHeight
                ),
                decoration: BoxDecoration(
                    color: widget.bgColor,
                    border: widget.border,
                    borderRadius: widget.borderRadius
                ),
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: <Widget>[
                    Offstage(
                      offstage: isInputEmpty,
                      child: SizedBox(
                        height: minHeight,
                        child: Align(
                        alignment: widget.placeholderAlignment != null ? widget.placeholderAlignment :widget.minLines > 1 ? Alignment.topLeft : widget.textAlign == TextAlign.center ?
                         Alignment.center : widget.textAlign == TextAlign.right || widget.textAlign == TextAlign.end ?
                          Alignment.centerRight : Alignment.centerLeft,
                        child: Text(widget.placeholder, style: themeData.textTheme.caption.copyWith(
                          color: themeData.disabledColor
                        ),),
                      ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                      scrollPhysics: Platform.isAndroid ? BouncingScrollPhysics() : null,
                      controller: controller,
                      focusNode: focusNode,
                      enabled: widget.enabled,
                      textCapitalization: widget.textCapitalization,
                      onEditingComplete: widget.onEditingComplete,
                      textInputAction: widget.textInputAction,
                      decoration: InputDecoration(
                        contentPadding: widget.contentPadding != null ? widget.contentPadding : EdgeInsets.all(0.0),
                        counterText: widget.counterText,
                        hintStyle: themeData.textTheme.body1.copyWith(
                          fontSize: widget.style != null ? widget.style.fontSize : themeData.textTheme.body1.fontSize,
                          color: themeData.disabledColor
                        ),
                        hintText: "",
                        border: InputBorder.none,
                      ),
                      cursorColor: themeData.primaryColor,
                      cursorRadius: Radius.circular(ToPx.size(3)),
                      cursorWidth: ToPx.size(5),
                      style: widget.style ?? themeData.textTheme.body1,
                      obscureText: obscureText,
                      keyboardType: widget.keyboardType,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      maxLength: widget.textMaxLength,
                      onChanged: widget.onChanged,
                      textAlign: widget.textAlign,
                      autofocus: widget.autofocus,
                      keyboardAppearance: Brightness.light,
                    ),
                    )
                  ],
                ),
              ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                   Offstage(
                    offstage: !isShowVisibility,
                    child: Button(
                        onPressed: (){
                            setState(() {
                              obscureText = !obscureText;
                            });
                        },
                        alignment: Alignment.centerRight,
                        useIosStyle: true,
                        disabledColor:  Colors.transparent,
                        color: Colors.transparent,
                        width: ToPx.size(45),
                        child: Icon(obscureText ? Icons.visibility : Icons.visibility_off, size: ToPx.size(40), color: Color(0xffcccccc),),
                      ),
                  ),
                  Align(
                  alignment: Alignment.centerRight,
                  child: Offstage(
                    offstage: !widget.showClear,
                    child: Offstage(
                      offstage: !isShowClear,
                      child: Button(
                        onPressed: (){
                          controller.clear();
                          if(widget.onClear != null) widget.onClear();
                        },
                        alignment: Alignment.centerRight,
                        useIosStyle: true,
                        disabledColor:  Colors.transparent,
                        color: Colors.transparent,
                        width: ToPx.size(45),
                        child: Icon(Icons.cancel, size: ToPx.size(35), color: Color(0xffcccccc),),
                      ),
                    ),
                  )
              ),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}