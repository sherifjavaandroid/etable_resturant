import 'package:efood_table_booking/features/home/controllers/product_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/helper/custom_snackbar_helper.dart';
import 'package:efood_table_booking/features/home/widgets/search_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? type;
  const SearchBarWidget({Key? key, required this.controller, this.type}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ProductController>(
      builder: (productController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          height:  ResponsiveHelper.isSmallTab() ? 35 : ResponsiveHelper.isTab(context) ?  50 : 40,
          child: SearchFieldWidget(
            controller: widget.controller,
            hint: 'search'.tr,
            iconPressed: (){
              if(productController.isSearch) {
                if(widget.controller.value.text.isEmpty) {
                  showCustomSnackBarHelper('please_enter_food_name'.tr, isToast: true);
                }else{
                  // productController.filterFormattedProduct(true, widget.controller.text, From.search);
                  productController.getProductList(
                    true, true, categoryId: productController.selectedCategory,
                    productType:  widget.type,
                    searchPattern: widget.controller.text.trim().isEmpty ? null : widget.controller.text,
                  );
                  //productController.searchProduct(widget.controller.text, widget.type);
                }
              }else{
                widget.controller.clear();
                if(productController.searchIs) {
                  productController.getProductList(
                    true, true, categoryId: productController.selectedCategory,
                    productType:  widget.type,
                    searchPattern: widget.controller.text.trim().isEmpty ? null : widget.controller.text,
                  );
                }

                FocusScope.of(context).unfocus();
              }




            },
            onChanged: (String pattern){
              // if(pattern.trim().isEmpty) {
              //   FocusScope.of(context).unfocus();
              // }

            },
            onSubmit: (String pattern){
              if(pattern.trim().isNotEmpty) {
                // productController.filterFormattedProduct(true, widget.controller.text, From.search);
                // productController.searchProduct(widget.controller.text, widget.type);

                productController.getProductList(
                  true, true, categoryId: productController.selectedCategory,
                  productType:  widget.type,
                  searchPattern: widget.controller.text.trim().isEmpty ? null : widget.controller.text,
                );
              }

            },
            suffixIcon: productController.isSearch ? Icons.search : Icons.cancel,
          ),
        );
      }
    );
  }
}
