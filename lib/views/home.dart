import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazzika/consts/colors.dart';
import 'package:mazzika/consts/text_style.dart';
import 'package:mazzika/controller/play_controller.dart';
import 'package:mazzika/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());



    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search,color: whiteColor,))
        ],
        leading: Icon(Icons.sort_rounded,color: whiteColor,),
        title: Text("Mazzika",style: ourStyle(size: 18,family: bold,color: whiteColor),),
      ),
      
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null , uriType: UriType.EXTERNAL,
        ),

          builder: (BuildContext context , snapshot){
          if (snapshot.data==null){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if (snapshot.data!.isEmpty){
            print(snapshot.data);

            return Center(
                child: Text("No Songs Found",style: ourStyle(),));
          }else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context , int index){
                  return Container(
                    margin: const EdgeInsets.only(bottom:4),
                    child: Obx(()=>ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        tileColor: bgColor,
                        title:
                        Text("${snapshot.data![index].displayNameWOExt}"
                          ,style: ourStyle(size: 15,family: bold),
                        ),
                        subtitle:
                        Text("${snapshot.data![index].artist}"
                          ,style: ourStyle(size: 15,family: bold),
                        ),

                        leading: QueryArtworkWidget(id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                        nullArtworkWidget: Icon (Icons.music_note,color: whiteColor,size: 32,),

                        ),
                        trailing:controller.playIndex.value == index && controller.isplaying.value
                        ?const Icon(Icons.play_arrow,color: whiteColor,size: 26,)
                            :null,
                        onTap: (){
                          Get.to(()=> Player(data:snapshot.data!
                          ),
                            transition: Transition.downToUp
                          );
                           controller.playSong(snapshot.data![index].uri,index);

                        },
                      ),
                    ),
                  );

                },
              ),
            );
          }
    }
      ),
    );
  }
}
