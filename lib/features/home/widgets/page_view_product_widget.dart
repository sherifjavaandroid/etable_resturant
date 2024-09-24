import 'package:efood_table_booking/features/home/controllers/product_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/common/widgets/custom_loader_widget.dart';
import 'package:efood_table_booking/features/home/widgets/product_widget.dart';
import 'package:efood_table_booking/common/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'product_shimmer_list_widget.dart';

class PageViewProductWidget extends StatelessWidget {
  final int totalPage;
  final String? search;

  const PageViewProductWidget({Key? key, required this.totalPage, this.search,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<ProductController>(
      builder: (productController) {
        return productController.productList == null ? const ProductShimmerListWidget() :
        productController.productList!.isNotEmpty ? PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: totalPage,
          onPageChanged: (index) {
            productController.updatePageViewCurrentIndex(index);
            if(totalPage == index + 1) {
              int totalSize = (productController.totalSize! / 10).ceil();
              if (productController.productOffset < totalSize) {
                productController.productOffset++;

                productController.getProductList(false, true,
                  offset: productController.productOffset,
                  searchPattern: search, categoryId: productController.selectedCategory,
                  productType: productController.selectedProductType,
                );
                // productController.filterFormattedProduct (false, true, offset: productController.productOffset);


              }
            }
          },

          itemBuilder: (context, index) {
            int initialLength = ResponsiveHelper.getLen(context);
            final itemLen = ResponsiveHelper.getLen(context);

            int currentIndex = initialLength * index;
            if(index + 1 == totalPage) {
              initialLength = productController.productList!.length - (index * initialLength);
            }
            return productController.productList != null && productController.productList?[index] != null ?
            Stack(
              children: [
                GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: ResponsiveHelper.isSmallTab() ? 5 : Dimensions.paddingSizeDefault,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: itemLen == 6 ? 1 :  0.9,
                    crossAxisCount: itemLen == 8 ? 4 :  3,
                    crossAxisSpacing: Dimensions.paddingSizeDefault,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                  ),
                  itemCount: initialLength,
                  itemBuilder: (BuildContext context, int item) {
                    int currentIndex0 = item  + currentIndex;
                    return ProductWidget(
                      product: productController.productList![currentIndex0]!,
                    );
                  },
                ),

                if(productController.isLoading) Positioned.fill(
                  child: Align(alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: CustomLoaderWidget(color: Theme.of(context).primaryColor,),
                    ),
                  ),
                ),
              ],
            ) : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor));
          },
        ) : SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(100),
          child: NoDataWidget(text: 'no_food_available'.tr,),
        ));
      }
    );
  }
}
