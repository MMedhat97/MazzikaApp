import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazzika/consts/colors.dart';
import 'package:mazzika/consts/text_style.dart';
import 'package:mazzika/controller/play_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';


class Player extends StatelessWidget {
  final List<SongModel> data;

  const Player({super.key,required this.data});



  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(),
      body:  Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: [
            Obx(()=> Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                    ),
                    alignment: Alignment.center,
                    child: QueryArtworkWidget(
                        id: data[controller.playIndex.value].id,
                        type: ArtworkType.AUDIO,
                        artworkHeight: double.infinity,
                        artworkWidth: double.infinity,
                        nullArtworkWidget: const Icon(Icons.music_note,color: Colors.white,size: 48,),
                    ),

                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top:Radius.circular(16),)
                  ),
                  child: Obx(()=> Column(

                      children: [
                        Text(data[controller.playIndex.value].displayNameWOExt,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: ourStyle(
                          size: 20,
                          family: bold,
                          color: bgDarkColor,
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(data[controller.playIndex.value].artist.toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: ourStyle(
                          size: 15,
                          family: regular,
                          color: bgDarkColor,
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(()=> Row(
                            children: [
                              Text(controller.position.value
                                ,style: ourStyle(
                                color: bgDarkColor,
                              ),),
                              Expanded(
                                  child: Slider(
                                  thumbColor: sliderColor,
                                  inactiveColor: bgDarkColor,
                                  activeColor: sliderColor,
                                  min:Duration(seconds: 0).inSeconds.toDouble(),
                                  max:controller.max.value,
                                  value: controller.value.value,
                                  onChanged: (newValue){
                                      controller.changeDurationToSecond(newValue.toInt());
                                      newValue = newValue;
                                  },
                                  )),
                              Text(controller.duoration.value
                                ,style: ourStyle(
                                color: bgDarkColor,
                              ),),

                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(onPressed: (){
                              controller.playSong(data[controller.playIndex.value -1].uri, controller.playIndex.value -1);
                            },
                              icon: const Icon(Icons.skip_previous_rounded,
                                size: 40,
                                color: bgDarkColor,
                              )
                            ),

                            Obx(()=>
                               CircleAvatar(
                                radius: 35,
                                backgroundColor: bgDarkColor,
                                  child: Transform.scale(
                                    scale: 2.5,
                                      child: IconButton(onPressed: (){
                                        if (controller.isplaying.value){
                                          controller.audioPlayer.pause();
                                          controller.isplaying(false);
                                        }else{
                                          controller.audioPlayer.play();
                                          controller.isplaying(true);
                                        }
                                      },
                                        icon:controller.isplaying.value
                                          ? const Icon(Icons.pause,
                                          size: 30,
                                          color: Colors.white)
                                          :const Icon(Icons.play_arrow_rounded,
                                            size: 30,
                                            color: Colors.white)))),
                            ),

                            IconButton(onPressed: (){
                              controller.playSong(data[controller.playIndex.value +1].uri, controller.playIndex.value +1);
                            },
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 40,
                                color: bgDarkColor,),),

                          ],
                        ),


                      ],
                    ),
                  ),
                  ),
            ),

          ],
        ),
        
      ),
    );
  }
}
