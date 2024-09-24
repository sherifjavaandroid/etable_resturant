import 'package:efood_table_booking/features/home/controllers/product_controller.dart';
import 'package:efood_table_booking/common/models/product_model.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StockTagWidget extends StatelessWidget {
  final Product product;
  const StockTagWidget({
    Key? key, required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return !productController.checkStock(product)  ? Positioned.fill(child: Align(alignment: Alignment.topCenter, child: Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5), topRight: Radius.circular(5),
        ),
        gradient: LinearGradient(colors: [
          Colors.black.withOpacity(0.7),
          Colors.black.withOpacity(0.35),
        ]),
      ),
      child: Text('out_of_stock'.tr, textAlign: TextAlign.center,
          style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall)
      ),
    ))) : const SizedBox();
  }
}
