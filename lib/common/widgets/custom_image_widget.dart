import 'package:efood_table_booking/util/images.dart';
import 'package:flutter/cupertino.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String placeholder;
  const CustomImageWidget({super.key, required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder = Images.placeholderImage});

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      image: image, height: height, width: width, fit: fit,
      placeholder: placeholder,
      imageErrorBuilder: (context, url, error) => Image.asset(placeholder, height: height, width: width, fit: fit, filterQuality: FilterQuality.low,),
    );
  }
}
