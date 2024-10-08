import 'package:efood_table_booking/features/order/controllers/order_controller.dart';
import 'package:efood_table_booking/common/controllers/theme_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/helper/animated_dialog_helper.dart';
import 'package:efood_table_booking/common/widgets/custom_app_bar_widget.dart';
import 'package:efood_table_booking/common/widgets/custom_rounded_button_widget.dart';
import 'package:efood_table_booking/features/cart/widgets/cart_detais_widget.dart';
import 'package:efood_table_booking/features/order/screens/order_screen.dart';
import 'package:efood_table_booking/features/order/screens/order_success_screen.dart';
import 'package:efood_table_booking/common/widgets/setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BodyTemplateWidget extends StatelessWidget {
  final Widget body;
  final bool showSetting;
  final bool showOrderButton;
  final bool  isOrderDetails;

  const BodyTemplateWidget({
    Key? key, required this.body,
    this.showSetting = false,
    this.showOrderButton = false,
    this.isOrderDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomAppBarWidget(showCart: true, isBackButtonExist: true, onBackPressed: null),

        Column(
          children: [

            Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4,
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).viewPadding.top + (ResponsiveHelper.isSmallTab() ? 50 : 90),),

                          body,
                        ],
                      )),

                  GetBuilder<OrderController>(
                      builder: (orderController) {
                      return (orderController.isLoading || orderController.currentOrderDetails == null) && isOrderDetails ?
                      const SizedBox() :
                      Expanded(flex: 2,
                          child: SafeArea(
                            child: Container(
                              // transform: Matrix4.translationValues(0.0, 10.0, 0.0),
                              margin: EdgeInsets.only(
                                bottom: Dimensions.paddingSizeDefault,
                                right: Dimensions.paddingSizeDefault,
                                left: Dimensions.paddingSizeSmall,
                              ),
                              decoration: BoxDecoration(
                                color:  Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Get.isDarkMode ?  Theme.of(context).canvasColor.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 3.75), blurRadius: 9.29,
                                  )
                                ],
                              ),

                              child: Column(children: [
                                ClipPath(
                                  clipper: _CustomClipper(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    height: 13,
                                  ),
                                ),

                               isOrderDetails ? const Expanded(child: OrderScreen()) : CartDetailsWidget(
                                  showButton: showOrderButton,
                                ),
                              ],),
                            ),
                          ));
                    }
                  ),
                ],
              ),
            )




          ],
        ),

       if(showSetting) Positioned.fill(child: Align(alignment: Alignment.bottomCenter, child: Padding(
         padding: EdgeInsets.all(
           ResponsiveHelper.isSmallTab() ?
           Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault,
         ),
         child: Row(children: [
           CustomRoundedButtonWidget(
             image: Images.themeIcon,
             onTap: ()=> Get.find<ThemeController>().toggleTheme(),
           ),
           SizedBox(width: Dimensions.paddingSizeLarge,),

           CustomRoundedButtonWidget(image: Images.settingIcon, onTap: (){
             showAnimatedDialog(
               context: context,
               barrierDismissible: true,
               builder: (BuildContext context) {
                 return const Dialog(
                   backgroundColor: Colors.transparent,
                   child: SettingWidget(formSplash: false),
                 );
               },
               animationType: DialogTransitionType.slideFromBottomFade,
             );
           }),
           SizedBox(width: Dimensions.paddingSizeLarge,),

           CustomRoundedButtonWidget(
             image: Images.order,
             onTap: ()=> Get.to(()=> const OrderSuccessScreen()),
           ),





         ],),
       ))),


      ],
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override

  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(-5, size.height);
    double x = -5;
    double y = size.height;
    double yControlPoint = size.height * .40;
    double increment = size.width / 40;

    while (x < size.width) {
      path.quadraticBezierTo(
        x + increment / 2, yControlPoint, x + increment, y,
      );
      x += increment;
    }

    path.lineTo(size.width, 0.0);


    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return oldClipper != this;
  }
}

class MyPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = const Color(0x0000ff00);
    path = Path();
    path.lineTo(0, size.height / 2);
    path.cubicTo(0, size.height / 2, size.width * 0.04, 0, size.width * 0.04, 0);
    path.cubicTo(size.width * 0.04, 0, size.width * 0.08, size.height * 0.1, size.width * 0.08, size.height * 0.1);
    path.cubicTo(size.width * 0.08, size.height * 0.1, size.width * 0.13, size.height * 0.1, size.width * 0.13, size.height * 0.1);
    path.cubicTo(size.width * 0.13, size.height * 0.1, size.width * 0.17, size.height * 0.1, size.width * 0.17, size.height * 0.1);
    path.cubicTo(size.width * 0.17, size.height * 0.1, size.width / 5, size.height / 5, size.width / 5, size.height / 5);
    path.cubicTo(size.width / 5, size.height / 5, size.width / 4, size.height * 0.4, size.width / 4, size.height * 0.4);
    path.cubicTo(size.width / 4, size.height * 0.4, size.width * 0.29, size.height * 0.8, size.width * 0.29, size.height * 0.8);
    path.cubicTo(size.width * 0.29, size.height * 0.8, size.width / 3, size.height * 0.1, size.width / 3, size.height * 0.1);
    path.cubicTo(size.width / 3, size.height * 0.1, size.width * 0.38, size.height / 2, size.width * 0.38, size.height / 2);
    path.cubicTo(size.width * 0.38, size.height / 2, size.width * 0.42, size.height * 0.9, size.width * 0.42, size.height * 0.9);
    path.cubicTo(size.width * 0.42, size.height * 0.9, size.width * 0.46, size.height * 0.9, size.width * 0.46, size.height * 0.9);
    path.cubicTo(size.width * 0.46, size.height * 0.9, size.width / 2, size.height * 0.7, size.width / 2, size.height * 0.7);
    path.cubicTo(size.width / 2, size.height * 0.7, size.width * 0.54, size.height * 0.4, size.width * 0.54, size.height * 0.4);
    path.cubicTo(size.width * 0.54, size.height * 0.4, size.width * 0.58, size.height * 0.9, size.width * 0.58, size.height * 0.9);
    path.cubicTo(size.width * 0.58, size.height * 0.9, size.width * 0.63, 0, size.width * 0.63, 0);
    path.cubicTo(size.width * 0.63, 0, size.width * 0.67, size.height * 0.1, size.width * 0.67, size.height * 0.1);
    path.cubicTo(size.width * 0.67, size.height * 0.1, size.width * 0.71, size.height * 0.3, size.width * 0.71, size.height * 0.3);
    path.cubicTo(size.width * 0.71, size.height * 0.3, size.width * 0.75, size.height * 0.7, size.width * 0.75, size.height * 0.7);
    path.cubicTo(size.width * 0.75, size.height * 0.7, size.width * 0.79, size.height * 0.1, size.width * 0.79, size.height * 0.1);
    path.cubicTo(size.width * 0.79, size.height * 0.1, size.width * 0.83, size.height * 0.4, size.width * 0.83, size.height * 0.4);
    path.cubicTo(size.width * 0.83, size.height * 0.4, size.width * 0.88, size.height / 5, size.width * 0.88, size.height / 5);
    path.cubicTo(size.width * 0.88, size.height / 5, size.width * 0.92, size.height * 0.6, size.width * 0.92, size.height * 0.6);
    path.cubicTo(size.width * 0.92, size.height * 0.6, size.width * 0.96, 0, size.width * 0.96, 0);
    path.cubicTo(size.width * 0.96, 0, size.width, size.height * 0.7, size.width, size.height * 0.7);
    path.cubicTo(size.width, size.height * 0.7, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, size.width * 0.96, size.height, size.width * 0.96, size.height);
    path.cubicTo(size.width * 0.96, size.height, size.width * 0.92, size.height, size.width * 0.92, size.height);
    path.cubicTo(size.width * 0.92, size.height, size.width * 0.88, size.height, size.width * 0.88, size.height);
    path.cubicTo(size.width * 0.88, size.height, size.width * 0.83, size.height, size.width * 0.83, size.height);
    path.cubicTo(size.width * 0.83, size.height, size.width * 0.79, size.height, size.width * 0.79, size.height);
    path.cubicTo(size.width * 0.79, size.height, size.width * 0.75, size.height, size.width * 0.75, size.height);
    path.cubicTo(size.width * 0.75, size.height, size.width * 0.71, size.height, size.width * 0.71, size.height);
    path.cubicTo(size.width * 0.71, size.height, size.width * 0.67, size.height, size.width * 0.67, size.height);
    path.cubicTo(size.width * 0.67, size.height, size.width * 0.63, size.height, size.width * 0.63, size.height);
    path.cubicTo(size.width * 0.63, size.height, size.width * 0.58, size.height, size.width * 0.58, size.height);
    path.cubicTo(size.width * 0.58, size.height, size.width * 0.54, size.height, size.width * 0.54, size.height);
    path.cubicTo(size.width * 0.54, size.height, size.width / 2, size.height, size.width / 2, size.height);
    path.cubicTo(size.width / 2, size.height, size.width * 0.46, size.height, size.width * 0.46, size.height);
    path.cubicTo(size.width * 0.46, size.height, size.width * 0.42, size.height, size.width * 0.42, size.height);
    path.cubicTo(size.width * 0.42, size.height, size.width * 0.38, size.height, size.width * 0.38, size.height);
    path.cubicTo(size.width * 0.38, size.height, size.width / 3, size.height, size.width / 3, size.height);
    path.cubicTo(size.width / 3, size.height, size.width * 0.29, size.height, size.width * 0.29, size.height);
    path.cubicTo(size.width * 0.29, size.height, size.width / 4, size.height, size.width / 4, size.height);
    path.cubicTo(size.width / 4, size.height, size.width / 5, size.height, size.width / 5, size.height);
    path.cubicTo(size.width / 5, size.height, size.width * 0.17, size.height, size.width * 0.17, size.height);
    path.cubicTo(size.width * 0.17, size.height, size.width * 0.13, size.height, size.width * 0.13, size.height);
    path.cubicTo(size.width * 0.13, size.height, size.width * 0.08, size.height, size.width * 0.08, size.height);
    path.cubicTo(size.width * 0.08, size.height, size.width * 0.04, size.height, size.width * 0.04, size.height);
    path.cubicTo(size.width * 0.04, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, size.height / 2, 0, size.height / 2);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => oldClipper != this;

}
