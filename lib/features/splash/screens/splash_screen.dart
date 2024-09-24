import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:efood_table_booking/features/cart/controllers/cart_controller.dart';
import 'package:efood_table_booking/features/promotion/controllers/promotional_controller.dart';
import 'package:efood_table_booking/features/splash/controllers/splash_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/features/promotion/screens/promotional_page_screen.dart';
import 'package:efood_table_booking/common/widgets/setting_widget.dart';
import 'package:efood_table_booking/helper/animated_dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen>  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver{
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection' : 'connected',
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    // Get.find<SplashController>().removeSharedData();

    Get.find<CartController>().getCartData();
    _route();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(AppLifecycleState.resumed == state) {
      if(Get.find<SplashController>().getBranchId() < 1) {

        openResponsiveDialog(
            context, const SettingWidget(formSplash: true),
            isDismissible: false
        );

      }
    }

  }


  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((value) {
      Timer(const Duration(seconds: 2), () async {
        if(Get.find<SplashController>().getBranchId() < 1) {
          openResponsiveDialog(
            context, const SettingWidget(formSplash: true),
            isDismissible: false
          );

        }else{
          if(ResponsiveHelper.isTab(context)
              && (Get.find<PromotionalController>().getPromotion('', all: true).isNotEmpty)
          ) {
            Get.offAll(()=> const PromotionalPageScreen());
          }else {
            Get.offNamed(RouteHelper.home);
          }
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: Get.find<SplashController>().getBranchId() < 1 ? () {
          openResponsiveDialog(
            context, const SettingWidget(formSplash: true),
            isDismissible: false,
          );
        } : null,

        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(Images.splashImage, width: Get.height * 0.1),

                  Image.asset(Images.logo, width: Get.height * 0.2),
                ],
              ),
            ),

            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: Get.width,
                  child: Lottie.asset(
                    fit: BoxFit.fitWidth,
                    Images.waveLoading,
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
