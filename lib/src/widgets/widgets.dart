import 'package:flutter/material.dart';
import 'package:movies_scrapper/src/api/movie_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

makeMovieCard(BuildContext context, Movies movie) {
  return VxBox(
          child: HStack([
    ClipRRect(
      borderRadius: BorderRadius.circular(context.screenWidth * .04),
      child: Image.network(
        movie.thumbnailUrl,
        height: context.screenHeight * .4,
        fit: BoxFit.cover,
      ),
    )
        .box
        .shadow3xl
        .size(context.screenWidth * .23, context.screenHeight * .15)
        .make(),
    (context.screenWidth * .07).widthBox,
    VxBox(
        child: VStack([
      movie.title.text.semiBold
          .overflow(TextOverflow.ellipsis)
          .size(context.screenWidth * .04)
          .hexColor(Vx.whiteHex)
          .fontFamily('Corporate')
          .make()
          .pSymmetric(
            h: context.screenWidth * .02,
            v: context.screenWidth * .02,
          ),
      (context.screenHeight * .02).heightBox,
      MaterialButton(
        child: VxBox(
                child: 'Watch Now'
                    .text
                    .bold
                    .size(context.screenWidth * .03)
                    .hexColor(Vx.blackHex)
                    .fontFamily('Corporate')
                    .makeCentered())
            .size(context.screenWidth * .35, context.screenHeight * .05)
            .roundedLg
            .shadow5xl
            .border(color: Vx.hexToColor(Vx.blackHex))
            .hexColor(Vx.whiteHex)
            .makeCentered(),
        onPressed: () async {
          try {
            VxToast.show(context, msg: 'Launching...');

            await launch(movie.movieRef);
          } catch (e) {
            VxToast.show(context, msg: 'Invalid URL');
          }
        },
      )
    ])).size(context.screenWidth * .60, context.screenHeight * .15).make()
  ]))
      .size(context.screenWidth * .8, context.screenHeight * .2)
      .make()
      .pSymmetric(h: context.screenWidth * .04);
}
