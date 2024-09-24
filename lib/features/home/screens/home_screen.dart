import 'dart:async';

import 'package:efood_table_booking/common/controllers/theme_controller.dart';
import 'package:efood_table_booking/common/widgets/body_template_widget.dart';
import 'package:efood_table_booking/common/widgets/confirmation_dialog_widget.dart';
import 'package:efood_table_booking/common/widgets/custom_app_bar_widget.dart';
import 'package:efood_table_booking/common/widgets/custom_loader_widget.dart';
import 'package:efood_table_booking/common/widgets/custom_rounded_button_widget.dart';
import 'package:efood_table_booking/common/widgets/filter_button_widget.dart';
import 'package:efood_table_booking/common/widgets/no_data_widget.dart';
import 'package:efood_table_booking/common/widgets/setting_widget.dart';
import 'package:efood_table_booking/features/home/controllers/product_controller.dart';
import 'package:efood_table_booking/features/home/widgets/category_widget.dart';
import 'package:efood_table_booking/features/home/widgets/fab_circular_menu_widget.dart';
import 'package:efood_table_booking/features/home/widgets/page_view_product_widget.dart';
import 'package:efood_table_booking/features/home/widgets/product_shimmer_list_widget.dart';
import 'package:efood_table_booking/features/home/widgets/product_widget.dart';
import 'package:efood_table_booking/features/home/widgets/search_bar_widget.dart';
import 'package:efood_table_booking/features/order/controllers/order_controller.dart';
import 'package:efood_table_booking/features/order/screens/order_success_screen.dart';
import 'package:efood_table_booking/helper/animated_dialog_helper.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  late String selectedProductType;
  final GlobalKey<FabCircularMenuWidgetState> _fabKey = GlobalKey();
  Timer? _timer;


  @override
  void initState() {
    final productController = Get.find<ProductController>();

    Get.find<OrderController>().getOrderList();
    selectedProductType = productController.productTypeList.first;
    productController.getCategoryList(true);
    productController.getProductList(false, false);

    searchController.addListener(() {
      if(searchController.text.trim().isNotEmpty) {
        productController.isSearchChange(false);

      }else{
        productController.isSearchChange(true);
        FocusScope.of(context).unfocus();
      }
    });




    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        int totalSize = (productController.totalSize! / 10).ceil();

        if (productController.productOffset < totalSize) {
          productController.productOffset++;

          productController.getProductList(
            false, true, offset: productController.productOffset, productType: selectedProductType,
            categoryId: productController.selectedCategory,
            searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,

          );
        }
      }

    });


    super.initState();
  }

  @override
  void dispose() {
   _scrollController.dispose();
   searchController.dispose();
   changeButtonState();
    super.dispose();
  }

  void changeButtonState() {
    if (_fabKey.currentState != null && _fabKey.currentState!.isOpen) {
      _fabKey.currentState?.close();
      _timer?.cancel();
      _timer = null;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    changeButtonState();
    timer.cancel();
    });

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        if(searchController.text.trim().isEmpty) {
          openResponsiveDialog(
              context, ConfirmationDialogWidget(
            title: '${'exit'.tr} !',
            icon: Icons.question_mark_sharp,
            description: 'are_you_exit_the_app'.tr,
            onYesPressed: () => SystemNavigator.pop(),
            onNoPressed: ()=> Get.back(),
          ));
        }else{
          searchController.clear();
        }

      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: ResponsiveHelper.isTab(context) ? null : const CustomAppBarWidget(
          isBackButtonExist: false, onBackPressed: null, showCart: true,
        ),
        body: ResponsiveHelper.isTab(context) ? BodyTemplateWidget(
          body: _TabBodyWidget(
            searchController: searchController,
            scrollController: _scrollController,
            selectedProductType: selectedProductType,
            onChangeProductType: (type){
              setState(() {
                selectedProductType = type;
              });
            },
          ),
          showSetting: true,
          showOrderButton: true,
        ) : _MobileBodyWidget(
          searchController: searchController,
          scrollController: _scrollController,
          selectedProductType: selectedProductType,
          onChangeProductType: (type){
            setState(() {
              selectedProductType = type;
            });
          },
        ),
        floatingActionButton: ResponsiveHelper.isTab(context) ? null : Padding(
          padding:  EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: FabCircularMenuWidget(
            onDisplayChange: (isOpen) {
              if(isOpen){
                _startTimer();
              }
            },
            key: _fabKey,
            ringColor: Theme.of(context).cardColor.withOpacity(0.2),
            fabSize: 50,
            ringWidth: 90,
            ringDiameter: 300,
            fabOpenIcon: const Icon(Icons.settings, color: Colors.white),
            children: [
              CustomRoundedButtonWidget(
                image: Images.themeIcon,
                onTap: ()=> Get.find<ThemeController>().toggleTheme(),
              ),

              CustomRoundedButtonWidget(image: Images.settingIcon, onTap: (){
                Get.bottomSheet(
                  const SettingWidget(formSplash: false), backgroundColor: Colors.transparent,
                );

              }),


              CustomRoundedButtonWidget(
                image: Images.order,
                onTap: ()=> Get.to(()=> const OrderSuccessScreen()),
              ),

            ],
          ),
        ),

      ),
    );
  }
}


class _TabBodyWidget extends StatelessWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final String selectedProductType;
  final Function(String value) onChangeProductType;
  const _TabBodyWidget({required this.searchController, required this.scrollController, required this.selectedProductType, required this.onChangeProductType});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        builder: (productController) {
          int totalPage = 0;
          if(productController.productList != null) {
            totalPage = (productController.productList!.length / ResponsiveHelper.getLen(context)).ceil();
          }
          return Flexible(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SearchBarWidget(controller: searchController, type: selectedProductType),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: IgnorePointer(
                      ignoring: productController.productList == null,
                      child: FilterButtonWidget(
                        items: productController.productTypeList, type: selectedProductType,
                        onSelected: (value){
                          onChangeProductType(value);
                          productController.setSelectedProductType = value;
                          productController.getProductList(
                            true, true, categoryId: productController.selectedCategory,
                            productType:  value,
                            searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,
                          );
                        },

                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.isSmallTab() ? 80 : 100,child: CategoryWidget(onSelected: (id){
                if(productController.selectedCategory == id) {
                  productController.setSelectedCategory(null);

                }else{
                  productController.setSelectedCategory(id);
                }
                productController.getProductList(
                  true, true, categoryId: productController.selectedCategory,
                  productType: selectedProductType,
                  searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,
                );

              })),

              Expanded(
                child: PageViewProductWidget(totalPage: totalPage, search: searchController.text.isEmpty ? null : searchController.text),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: GetBuilder<ProductController>(
                      builder: (productController) {
                        int totalPage = 0;
                        if(productController.productList != null) {
                          totalPage = (productController.totalSize! / ResponsiveHelper.getLen(context)).ceil();
                        }
                        List list = [for (var i = 0; i <= totalPage -1; i++) i];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: list.map((index) =>
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color:  index == productController.pageViewCurrentIndex
                                        ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                                  ),
                                  height: 5, width: Dimensions.paddingSizeExtraLarge,
                                ),

                            ).toList(),
                          ),
                        );
                      }
                  ),
                ),),
            ],),
          );
        }
    );
  }
}



class _MobileBodyWidget extends StatelessWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final String selectedProductType;
  final Function(String value) onChangeProductType;
  const _MobileBodyWidget({required this.searchController, required this.scrollController, required this.selectedProductType, required this.onChangeProductType});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        builder: (productController) {
          return Column(
            children: <Widget>[
              SizedBox(height: Dimensions.paddingSizeDefault,),

              Padding(
                padding:  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: SearchBarWidget(controller: searchController, type: selectedProductType),
              ),


              SizedBox(
                height: 90,
                child: CategoryWidget(onSelected: (id){
                  if(productController.selectedCategory == id) {
                    productController.setSelectedCategory(null);
                  }else{
                    productController.setSelectedCategory(id);
                  }
                  productController.getProductList(
                    true, true, categoryId: productController.selectedCategory,
                    productType:  selectedProductType,
                    searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,
                  );

                }),
              ),
              SizedBox(height: Dimensions.paddingSizeSmall,),

              IgnorePointer(
                ignoring: productController.productList == null,
                child: FilterButtonWidget(
                  items: productController.productTypeList, type: selectedProductType, onSelected: (type){
                    onChangeProductType(type);
                  productController.setSelectedProductType = type;
                  productController.getProductList(
                    true, true, categoryId: productController.selectedCategory,
                    productType:  type,
                    searchPattern: searchController.text.trim().isEmpty ? null : searchController.text,
                  );

                },),
              ),
              SizedBox(height: Dimensions.paddingSizeSmall,),



              Expanded(
                child: GetBuilder<ProductController>(
                    builder: (productController) {
                      final isBig = (Get.height / Get.width) > 1 && (Get.height / Get.width) < 1.7;

                      return productController.productList == null ?
                      const ProductShimmerListWidget() : productController.productList!.isNotEmpty ?
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child:  RefreshIndicator(
                              onRefresh: () async {
                                onChangeProductType(Get.find<ProductController>().productTypeList.first);
                                Get.find<ProductController>().setSelectedCategory(null);
                                await Get.find<ProductController>().getProductList(
                                  true, true, offset: 1,
                                );
                              },
                              child: GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller : scrollController,
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                itemCount: productController.productList?.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:  isBig ? 3 : 2,
                                  crossAxisSpacing: Dimensions.paddingSizeDefault,
                                  mainAxisSpacing: Dimensions.paddingSizeDefault,
                                ),

                                itemBuilder: (context, index) {
                                  return  productController.productList?[index] != null
                                      ? ProductWidget(product: productController.productList![index]!)
                                      : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor));
                                },
                              ),
                            ),
                          ),

                          if(productController.isLoading) Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: CustomLoaderWidget(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ) : RefreshIndicator(
                        onRefresh: () async {
                          onChangeProductType(Get.find<ProductController>().productTypeList.first);
                          Get.find<ProductController>().setSelectedCategory(null);
                          await Get.find<ProductController>().getProductList(
                            true, true, offset: 1,
                          );
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: NoDataWidget(text: 'no_food_available'.tr),
                        ),
                      );
                    }
                ),
              ),

            ],);
        }
    );
  }
}








