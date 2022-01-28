import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:movies_scrapper/src/api/movie_model.dart';
import 'package:movies_scrapper/src/api/movies_api.dart';
import 'package:movies_scrapper/src/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

// home page
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // get initial movies from api
    MoviesAPI.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VxAppBar(
        searchBar: true,
        searchHintText: 'Search movie name..',
        searchHintStyle: TextStyle(color: Vx.hexToColor(Vx.grayHex300)),
        onSubmitted: (movieName) async {
          String status = '';

          if (movieName.isEmpty) {
            status = 'Returing to home';
          } else {
            status = 'Searching for ${movieName.trim()}';
          }

          EasyLoading.show(
              status: status,
              indicator: CircularProgressIndicator(
                color: Vx.hexToColor(Vx.whiteHex),
              ));

          await MoviesAPI.searchForMovies(movieName);

          EasyLoading.dismiss();
        },
        searchBarColorTheme: Vx.hexToColor(Vx.whiteHex),
        elevation: .0,
        flexibleSpace: VxBox()
            .gradientFromTo(
                from: Vx.hexToColor('#2c3e50'), to: Vx.hexToColor('#000000'))
            .make(),
        title: 'Scrapper Movies'
            .text
            .light
            .size(context.screenWidth * .07)
            .hexColor(Vx.whiteHex)
            .fontFamily('Corporate')
            .make(),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Movies>>(
            stream: MoviesAPI.movies,
            builder: (context, AsyncSnapshot<List<Movies>> snapshot) {
              if (snapshot.hasData == false) {
                return ListView(
                  children: [
                    (context.screenHeight * .4).heightBox,
                    CircularProgressIndicator(
                      color: Vx.hexToColor(Vx.whiteHex),
                    ).centered()
                  ],
                )
                    .box
                    .gradientFromTo(
                        from: Vx.hexToColor('#2c3e50'),
                        to: Vx.hexToColor('#000000'))
                    .make();
              }

              if (snapshot.data!.isEmpty) {
                return ListView(children: [
                  (context.screenHeight * .4).heightBox,
                  'No Results Found...'
                      .text
                      .light
                      .hexColor(Vx.whiteHex)
                      .fontFamily('Corporate')
                      .makeCentered()
                ])
                    .box
                    .gradientFromTo(
                        from: Vx.hexToColor('#2c3e50'),
                        to: Vx.hexToColor('#000000'))
                    .make();
              }

              return ListView(
                children: List.generate(snapshot.data!.length,
                    (index) => makeMovieCard(context, snapshot.data![index])),
              )
                  .box
                  .gradientFromTo(
                      from: Vx.hexToColor('#2c3e50'),
                      to: Vx.hexToColor('#000000'))
                  .make();
            }),
      ),
    );
  }
}
