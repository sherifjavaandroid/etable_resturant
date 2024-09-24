import 'package:efood_table_booking/features/order/controllers/order_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/common/widgets/custom_app_bar_widget.dart';
import 'package:efood_table_booking/common/widgets/custom_loader_widget.dart';
import 'package:efood_table_booking/common/widgets/filter_button_widget.dart';
import 'package:efood_table_booking/features/order/widgets/order_details_widget.dart';
import 'package:efood_table_booking/common/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  final bool isOrderDetails;
  const OrderScreen({Key? key, this.isOrderDetails = false}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  @override
  void initState() {

   if(widget.isOrderDetails) {
     SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
       DeviceOrientation.portraitDown,
     ]);
     Get.find<OrderController>().getOrderList();

     Get.find<OrderController>().setCurrentOrderId = null;
   }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
   if(widget.isOrderDetails) {
     SystemChrome.setPreferredOrientations([
       DeviceOrientation.landscapeRight,
       DeviceOrientation.landscapeLeft,
       DeviceOrientation.portraitUp,
       DeviceOrientation.portraitDown,
     ]);
   }
    Get.find<OrderController>().cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isTab(context) ? orderBody() : Scaffold(
      appBar: CustomAppBarWidget( isBackButtonExist: true, showCart: false, onBackPressed:()=> Get.back(),),
      body: orderBody(),
    );
  }

  GetBuilder<OrderController> orderBody() {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        List<String> orderIdList = [];
        orderController.orderList?.map((order) => orderIdList.add('${'order'.tr}# ${order.id}')).toList();

        return orderController.isLoading || orderController.orderList == null ?
        Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor,)) :
        orderController.orderList!.isNotEmpty ? Column(
          children: [
            SizedBox(height: Dimensions.paddingSizeDefault,),

            Container(
              margin: EdgeInsets.only(left: Dimensions.paddingSizeLarge),
              child: FilterButtonWidget(type: orderController.currentOrderId == null ? orderIdList.first : orderController.currentOrderId!,
                onSelected: (id){
                orderController.setCurrentOrderId = id;
                orderController.getCurrentOrder(id.replaceAll('${'order'.tr}# ', ''), isLoading:  !widget.isOrderDetails).then((value) {
                  Get.find<OrderController>().cancelTimer();
                  Get.find<OrderController>().countDownTimer();
                });


              }, items: orderIdList, isBorder: true,),
            ),
            SizedBox(height: Dimensions.paddingSizeSmall,),

            const Flexible(child: OrderDetailsWidget()),

          ],
        ) : NoDataWidget(text: 'no_order_available'.tr);
      }
    );
  }
}
