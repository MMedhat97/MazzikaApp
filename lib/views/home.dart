import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazzika/consts/colors.dart';
import 'package:mazzika/consts/text_style.dart';
import 'package:mazzika/controller/play_controller.dart';
import 'package:mazzika/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  Icon searchIcon = Icon(Icons.search);
  Widget searchBar = Text("Mazzika",style: ourStyle(size: 18,family: bold,color: whiteColor));
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());




    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              if(this.searchIcon.icon ==Icons.search){
                this.searchIcon=Icon(Icons.cancel);
                this.searchBar =TextField(
                  textInputAction: TextInputAction.go,
                  style: ourStyle(
                    size: 18,
                    color: whiteColor,
                    family: regular,
                  ),
                );

              }else{
                this.searchIcon = Icon(Icons.search);
                this.searchBar = Text("Mazzika",style: ourStyle(size: 18,family: bold,color: whiteColor));

              }
            });

          }, icon: searchIcon,color: whiteColor)
        ],
        leading: Icon(Icons.sort_rounded,color: whiteColor,),
        title: searchBar,
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
                          ,maxLines: 2
                          ,style: ourStyle(size: 15,family: bold),
                        ),
                        subtitle:
                        Text("${snapshot.data![index].artist}"
                          ,maxLines: 2
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
