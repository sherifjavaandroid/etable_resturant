import 'package:efood_table_booking/features/promotion/controllers/promotional_controller.dart';
import 'package:efood_table_booking/features/splash/controllers/splash_controller.dart';
import 'package:efood_table_booking/common/controllers/theme_controller.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/helper/animated_dialog_helper.dart';
import 'package:efood_table_booking/common/widgets/custom_app_bar_widget.dart';
import 'package:efood_table_booking/common/widgets/custom_button_widget.dart';
import 'package:efood_table_booking/common/widgets/custom_rounded_button_widget.dart';
import 'package:efood_table_booking/features/promotion/widgets/custom_youtube_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_slider_widget.dart';
import '../../../common/widgets/setting_widget.dart';

class PromotionalPageScreen extends StatelessWidget {
  const PromotionalPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBarWidget(onBackPressed: null, isBackButtonExist: false),
      body: GetBuilder<SplashController>(
          builder: (splashController) {
          return GetBuilder<PromotionalController>(
            builder: (promotionalController) {
              Get.find<PromotionalController>().getVideoUrls();
              double getHeight = (context.width * (promotionalController.getPromotion('top_right_banner').isNotEmpty ? 0.6 : 0.8)) / 2;
              double getSecondHeight = (context.width * (promotionalController.getPromotion('bottom_right_banner').isNotEmpty ? 0.8 : 1)) * 0.35;
              bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

              final List<String> promotionTextList = 'promotion_title'.tr.split('\n');

              return Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault).copyWith(top: Dimensions.paddingSizeLarge),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: isPortrait ? Column(children: [

                        SizedBox(
                          height: context.height * 0.3,
                          child: Row(children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                                  child: Text.rich(
                                    style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeOverLarge,
                                      height: 1.4,
                                      color: Theme.of(context).textTheme.bodyMedium?.color,

                                    ),

                                    TextSpan(
                                      children: promotionTextList.map((text) {
                                        return TextSpan(text: '$text\n',
                                          style: [1,2].contains(promotionTextList.indexOf(text)) ? robotoBold.copyWith(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: Dimensions.fontSizeOverLarge,

                                          ) : null,

                                        );
                                      }).toList(),
                                    ),

                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: Dimensions.paddingSizeSmall,),

                            if(promotionalController.getPromotion('top_right_banner').isNotEmpty) Expanded(
                              child: CustomSliderWidget(
                                branchPromotionList : promotionalController.getPromotion('top_right_banner'),
                              ),
                            ),
                            SizedBox(width: Dimensions.paddingSizeSmall,),

                            if(promotionalController.getPromotion('bottom_right_banner').isNotEmpty) Expanded(
                              child: CustomSliderWidget(
                                branchPromotionList : promotionalController.getPromotion('top_right_banner'),
                              ),
                            ),




                          ],),
                        ),

                        SizedBox(height: Dimensions.paddingSizeSmall,),

                        promotionalController.videoIds.isNotEmpty ? CustomYoutubePLayerWidget(
                          width: context.width, height: context.height * 0.25,
                        ) : Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset(Images.videoPlaceHolder, width: context.width, height: context.height * 0.25,
                            ),
                          ),
                        SizedBox(height: Dimensions.paddingSizeSmall,),

                        promotionalController.getPromotion('bottom_banner').isNotEmpty ? SizedBox(
                          height : context.width * 0.32,
                          child: CustomSliderWidget(
                            branchPromotionList: promotionalController.getPromotion('bottom_banner'),
                          ),
                        ) : SizedBox(height:  context.width * 0.32),




                      ],) :
                      Column(children: [
                        SizedBox(
                          height: getHeight,
                          child: Row(children: [
                            Expanded(flex: 2,child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                                child: Text.rich(
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeOverLarge,
                                    height: 1.4,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,

                                  ),

                                  TextSpan(
                                    children: promotionTextList.map((text) {
                                      return TextSpan(text: '$text\n',
                                        style: [1,2].contains(promotionTextList.indexOf(text)) ? robotoBold.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: Dimensions.fontSizeOverLarge,

                                        ) : null,

                                      );
                                    }).toList(),
                                  ),

                                ),
                              ),
                            )),
                            SizedBox(width: Dimensions.paddingSizeSmall,),

                            Expanded(flex: promotionalController.videoIds.isNotEmpty ?  6 : 8,
                              child: promotionalController.videoIds.isNotEmpty ? CustomYoutubePLayerWidget(
                                width: context.width * 0.6, height: getHeight,
                              ) : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(Images.videoPlaceHolder,  width: context.width * 0.6, height: getHeight,
                                ),
                              ),
                            ),
                            SizedBox(width: Dimensions.paddingSizeSmall,),

                            if(promotionalController.getPromotion('top_right_banner').isNotEmpty) Expanded(flex: 2, child: CustomSliderWidget(
                              branchPromotionList : promotionalController.getPromotion('top_right_banner'),
                            )),


                          ],),
                        ),

                        SizedBox(height: Dimensions.fontSizeLarge,),


                        promotionalController.getPromotion('bottom_banner').isNotEmpty || promotionalController.getPromotion('bottom_right_banner').isNotEmpty ? SizedBox(
                          height: getSecondHeight,
                          child: Row(children: [
                            Expanded(flex: 4, child:promotionalController.getPromotion('bottom_banner').isNotEmpty ? CustomSliderWidget(
                              branchPromotionList: promotionalController.getPromotion('bottom_banner'),
                            ) : Opacity(opacity: 0.3,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(Images.emptyBox),
                              ),
                            )),

                            Expanded(flex: 1, child: Padding(
                              padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                              child:promotionalController.getPromotion('bottom_right_banner').isNotEmpty ? CustomSliderWidget(
                                branchPromotionList : promotionalController.getPromotion('bottom_right_banner'),
                              ) : Opacity(opacity: 0.3,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Image.asset(Images.emptyBox),
                                ),
                              ),
                            )),


                          ],),
                        ) : const SizedBox(),

                      ],),
                    ),

                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: isPortrait && promotionalController.getPromotion('bottom_banner').isNotEmpty ? BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.15), offset:  const Offset(0, 5),blurRadius: 10)
                            ],
                          ) : null,
                          height: Get.height * 0.1,
                          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                          child: CustomButtonWidget(
                            buttonText: 'check_here_to_order'.tr,
                            fontSize: Dimensions.fontSizeDefault,
                            onPressed:  ()=> Get.offAllNamed(RouteHelper.home, ),
                          ),
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: Container(
                        transform: Matrix4.translationValues(
                          0,
                          -Dimensions.paddingSizeSmall, 0.0,
                        ),

                        alignment: Alignment.topRight,
                        child: Column(children: [
                          CustomRoundedButtonWidget(image: Images.themeIcon, onTap: ()=> Get.find<ThemeController>().toggleTheme(),
                            boxBorder:  Border.all( color: Theme.of(context).primaryColor, width: 2),
                          ),
                          SizedBox(height: Dimensions.paddingSizeLarge,),

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
                          }, boxBorder:  Border.all( color: Theme.of(context).primaryColor, width: 2),),
                        ],),
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        }
      ),
    );
  }
}


