import 'package:flutter/material.dart';
import 'package:wowsports/utils/color_resource.dart';

class AppButton extends StatelessWidget {
  final Function() onPressed;
  Widget child;
  Color color;

  AppButton({Key key, this.onPressed, this.color, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:const  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColorResource.Color_0EA,
              AppColorResource.Color_1FFF,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: SizedBox(
        width: ((MediaQuery.of(context).size.width) / 1.4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            // backgroundColor: Colors.transparent,
            // disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            // padding:
            //     const EdgeInsets.symmetric(horizontal: 50.0, vertical: 70.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );

    Container(
      width: ((MediaQuery.of(context).size.width) / 1.3),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(8),
        gradient: const LinearGradient(
            colors: <Color>[
              AppColorResource.Color_1FFF,
              AppColorResource.Color_0EA,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror),
      ),
      child: SizedBox(
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.transparent),
            child: child),
      ),
    );
  }
}
