import 'package:flutter/material.dart';
import 'package:wowsports/utils/color_resource.dart';

class CustomContainer extends StatelessWidget {
  final text;

  CustomContainer({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
            color: AppColorResource.Color_F3F,
            borderRadius: BorderRadius.circular(15),
            shape: BoxShape.rectangle,
            border: Border.all(color: AppColorResource.Color_0EA)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              text ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColorResource.Color_000,
                fontFamily: 'Nunito',
                fontStyle: FontStyle.normal,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
