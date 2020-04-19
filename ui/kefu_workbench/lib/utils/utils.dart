
import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:path_provider/path_provider.dart';

typedef DownloadProgress(int sent,int total); // 下载进度

class Utils{

  // 日期轉中文表示
  static String toChineseDate(date){
    if(date == null) return "";
    if(date is String && date.isEmpty) return "";
    int dateTimeStamp = DateTime.tryParse(date)?.millisecondsSinceEpoch;

    int minute = 1000 * 60;
    int hour = minute * 60;
    int day = hour * 24;
    int month = day * 30;
    int now = DateTime.now().millisecondsSinceEpoch;
    int diffValue = now - dateTimeStamp;
    var monthC =diffValue/month ~/ 1;
    var weekC =diffValue/(7*day) ~/ 1;
    var dayC =diffValue/day ~/ 1;
    var hourC =diffValue/hour ~/ 1;
    var minC =diffValue/minute ~/ 1;
    String result;
    if(monthC >= 12){
      result= date ;
    }else if(monthC>=1){
      result="$monthC个月前";
    }
    else if(weekC>=1){
      result="$weekC周前";
    }
    else if(dayC>=1){
      result="$dayC天前";
    }
    else if(hourC>=1){
      result="$hourC小时前";
    }
    else if(minC>=1){
      result="$minC分钟前";
    }else
      result="刚刚";

    return result;
  }

  /// 是否是当天.
  static bool isToday(int milliseconds, {bool isUtc = false}) {
    if (milliseconds == null || milliseconds == 0) return false;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime fixDate = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    return date.year == fixDate.year && date.month == fixDate.month && date.day == fixDate.day;
  }

  /// 是否是昨天.
  static bool isYesterday(int milliseconds, {bool isUtc = false}) {
    if (milliseconds == null || milliseconds == 0) return false;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime _fixDate = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    DateTime fixDate = DateTime.fromMillisecondsSinceEpoch(_fixDate.millisecondsSinceEpoch-86400000, isUtc: isUtc);
    return date.year == fixDate.year && date.month == fixDate.month && date.day == fixDate.day;
  }

  /// 是否是前天.
  static bool isBeforeYesterday(int milliseconds, {bool isUtc = false}) {
    if (milliseconds == null || milliseconds == 0) return false;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime _fixDate = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    DateTime fixDate = DateTime.fromMillisecondsSinceEpoch(_fixDate.millisecondsSinceEpoch-86400000*2, isUtc: isUtc);
    return date.year == fixDate.year && date.month == fixDate.month && date.day == fixDate.day;
  }

  // 日期格式化
  static String formatDate(int timeStamp, {bool  isformatFull = false}){
    if(timeStamp.toString().length <= 10){
      timeStamp = int.parse(timeStamp.toString() + '000');
    }
    if(timeStamp == null) return "";
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    if(isformatFull){
      return "${date.year}-${date.month < 10 ? "0" + date.month.toString() : date.month}-${date.day < 10 ? "0" + date.day.toString() + "日" : date.day} ${date.hour}:${date.minute < 10 ? "0" + date.minute.toString() : date.minute}";
    }
    return "${date.year}/${date.month}/${date.day}";
  }

  // 日期格式化1
  static String epocFormat(int timeStamp){
    if(timeStamp.toString().length <= 10){
      timeStamp = int.parse(timeStamp.toString() + '000');
    }
    if(timeStamp == null) return "";
    String result;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    String d = "";
    if(Utils.isToday(timeStamp)){
      if(date.hour>1 && date.hour < 6){
        d = "凌晨";
      }else if(date.hour>6 && date.hour< 12){
        d = "上午";
      }else if(date.hour>12 && date.hour < 18){
        d = "下午";
      }else if(date.hour>18 && date.hour < 24){
        d = "晚上";
      }
      result= "$d ${date.hour}:${date.minute < 10 ? "0" + date.minute.toString() : date.minute}";
    }else if(Utils.isYesterday(timeStamp)){
      d = "昨天";
      result= "$d ${date.hour}:${date.minute < 10 ? "0" + date.minute.toString() : date.minute}";
    }else if(Utils.isBeforeYesterday(timeStamp)){
      d = "前天";
      result= "$d ${date.hour}:${date.minute < 10 ? "0" + date.minute.toString() : date.minute}";
    }else{
      result= "${date.year}年${date.month < 10 ? "0" + date.month.toString() : date.month}月${date.day < 10 ? "0" + date.day.toString() + "日" : date.day} ${date.hour}:${date.minute < 10 ? "0" + date.minute.toString() : date.minute}";
    }
    return result;
  }

  // 下载文件
  static Future<String> downloadFile(String url, {DownloadProgress showDownloadProgress}) async {
    try {
      Response response = await Dio().get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String savePath = tempPath + '/'+ url.substring(url.lastIndexOf('/')+1, url.length);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return savePath;
    } catch (e) {
      return null;
    }
  }

  // 保存网络图片到相册
//  static  Future<bool> savedGallery(String url) async{
//    String path = await Utils.downloadFile(url);
//    if(path != null){
//      ByteData bytes = await rootBundle.load(path);
//      final filePath = await ImageSaver.toFile(
//          fileData: Uint8List.view(bytes.buffer)
//      );
//      if(filePath != null){
//        return true;
//      }else{
//        return false;
//      }
//    }else{
//      return false;
//    }
//  }





}
