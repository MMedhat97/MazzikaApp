import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';


class PlayerController extends GetxController {

  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  var playIndex = 0.obs;
  var isplaying = false.obs;
  var duoration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkPermission();
  }

  updatePosition(){
    audioPlayer.durationStream.listen((duo) {
      duoration.value = duo.toString().split(".")[0];
      max.value = duo!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((pos) {
      position.value = pos.toString().split(".")[0];
      value.value = pos.inSeconds.toDouble();
    });
  }

  changeDurationToSecond(seconds){
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);

  }

  playSong(String? uri , index) async {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(uri!)),
      );
      audioPlayer.play();
      isplaying(true);
      updatePosition();

    } on Exception catch (e){
      print(e.toString());
    }
  }



  checkPermission() async {

    // if (await Permission.contacts.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    // }
    var permission = await Permission.storage.request();
    if(permission.isGranted){

    }else{
      checkPermission();
    }
  }


}