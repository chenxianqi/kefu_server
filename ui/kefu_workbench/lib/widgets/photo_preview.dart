import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../core_flutter.dart';
class PhotoPreview extends StatefulWidget{
  PhotoPreview({this.images, this.initIndex = 0, @required this.context});
  final List<String> images;
  final int initIndex;
  final BuildContext context;
  @override
  State<StatefulWidget> createState() {
    return PhotoPreviewState();
  }
}

class PhotoPreviewState extends State<PhotoPreview>{
  int tabIndex = 0;
  PageController pageController;

  // 是否是本地资源
  bool get isLocal => widget.images[tabIndex] != null && !widget.images[tabIndex].contains(RegExp(r'^(http://|https://)'));

  Widget pagination({bool on = false}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
      width: ToPx.size(18),
      height: ToPx.size(18),
      decoration: BoxDecoration(
          color: on ? Color.fromRGBO(255, 255, 255, .9) : Color.fromRGBO(255, 255, 255, .5),
          shape: BoxShape.circle
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    tabIndex = widget.initIndex;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(_) {

    ThemeData themeData = Theme.of(widget.context);

    tabIndex = widget.initIndex;
    pageController = PageController(initialPage: tabIndex);
    List<Widget> paginationWidgets = [];
    for(var i =0; i< widget.images.length; i++){
      paginationWidgets.add(pagination(on: i == tabIndex));
    }
    List<PhotoViewGalleryPageOptions> imageWidgets = [];
    for(var i =0; i< widget.images.length; i++){
      imageWidgets.add(PhotoViewGalleryPageOptions.customChild(
          heroAttributes: PhotoViewHeroAttributes(tag: widget.images[tabIndex]),
          onTapUp: (ctx, _, __){
            Navigator.pop(context);
          },
                                                                                                                                                                                                                                                                                                                                       minScale: 0.5,
          maxScale: 5.0,
          child: AspectRatio(
            aspectRatio: MediaQuery.of(context).size.aspectRatio,
            child: CachedNetworkImage(
              bgColor: Color.fromRGBO(0, 0, 0, 0.0),
              src: widget.images[i],
            ),
          ),
          childSize: Size.fromRadius(100.0)
      )
      );
    }
    return  Material(
      color: Colors.transparent,
      child: Theme(
          data: themeData,
          child: Stack(
            children: <Widget>[
              PhotoViewGallery(
                pageController: pageController,
                onPageChanged: (index) => setState(() => tabIndex = index),
                pageOptions: imageWidgets.toList(),
                backgroundDecoration: BoxDecoration(color: Color(0xff000000)),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    height: ToPx.size(100),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: paginationWidgets.toList()
                    ),
                  )
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Offstage(
                    offstage: isLocal,
                    child: Button(
                        color: Colors.transparent,
                        useIosStyle: true,
                        onPressed: () async{
//                          bool isComplete = await Utils.savedGallery(widget.images[tabIndex]);
//                          if(isComplete){
//                            UX.showToast("已保存到相册");
//                          }else{
//                            UX.showToast("保存失败");
//                          }
                        },
                        width:ToPx.size(200),
                        height: ToPx.size(100),
                        alignment: Alignment.center,
                        child: Icon(Icons.file_download, color: Colors.white.withAlpha(100),size: ToPx.size(80),)
                    ),
                  )
              ),
            ],
          )
      ),
    );

  }
}
