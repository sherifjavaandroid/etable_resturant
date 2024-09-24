import 'package:efood_table_booking/features/cart/controllers/cart_controller.dart';
import 'package:efood_table_booking/features/splash/controllers/splash_controller.dart';
import 'package:efood_table_booking/features/splash/domain/models/config_model.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/common/widgets/custom_button_widget.dart';
import 'package:efood_table_booking/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TableInputWidget extends StatefulWidget {
  const TableInputWidget({Key? key}) : super(key: key);

  @override
  State<TableInputWidget> createState() => _TableInputWidgetState();
}

class _TableInputWidgetState extends State<TableInputWidget> {
  final TextEditingController _peopleNumberController = TextEditingController();
  final FocusNode _peopleNumberFocusNode = FocusNode();
  List<String> _errorText = [];


  @override
  void initState() {
    final SplashController splashController = Get.find<SplashController>();
    TableModel? table =  splashController.getTable(splashController.getTableId(), branchId: splashController.getBranchId());
    Get.find<SplashController>().updateTableId(
      Get.find<SplashController>().getTableId() < 0 || table == null
          ? null : Get.find<SplashController>().getTableId(),
      isUpdate: false,
    );
    super.initState();
  }


  @override
  void dispose() {
    _peopleNumberController.dispose();
    _peopleNumberFocusNode .dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        builder: (splashController) {
        return GetBuilder<CartController>(
          builder: (cartController) {
            if(cartController.peopleNumber != null && _errorText.isEmpty){
              _peopleNumberController.text = cartController.peopleNumber.toString();
            }
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                  color: Theme.of(context).colorScheme.surface,
                ),
                width: 650,
                padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,  children: [

                  SizedBox(height: Dimensions.paddingSizeDefault,),

                  Text('table_number'.tr),
                  SizedBox(height: Dimensions.paddingSizeDefault,),

                  IgnorePointer(
                    ignoring: splashController.getIsFixTable(),
                    child: Container(
                      height: ResponsiveHelper.isSmallTab() ? 40 :  ResponsiveHelper.isTab(context) ? 50 : 40,
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,),

                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.4))
                        // boxShadow: [BoxShadow(color: Theme.of(context).cardColor, spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                      ),
                      child: DropdownButton<int>(
                        menuMaxHeight: Get.height * 0.5,

                        hint: Text(
                          'set_your_table_number'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        value: splashController.selectedTableId,

                        items: splashController.configModel?.branch?.firstWhere(
                                (branch) => branch.id == splashController.getBranchId()).table?.map((value) {
                          return DropdownMenuItem<int>(
                            value: value.id,
                            child: Text(
                              '${value.id == -1 ? 'no_table_available'.tr : value.number}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),
                          );
                        }).toList(),

                        onChanged: (value) {
                          splashController.updateTableId(value == -1 ? null : value, isUpdate: true);
                        },

                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.paddingSizeDefault,),

                  Row(
                    children: [
                      Text('number_of_people'.tr),
                      SizedBox(width: Dimensions.paddingSizeExtraSmall,),

                      if(splashController.selectedTableId != null)
                        Text(
                          '( ${'max_capacity'.tr} : ${splashController.getTable(splashController.selectedTableId)?.capacity})',
                          style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                        ),
                    ],
                  ),
                  SizedBox(height: Dimensions.paddingSizeDefault,),


                  SizedBox(
                    height: ResponsiveHelper.isSmallTab() ? 40 :  ResponsiveHelper.isTab(context) ? 50 : 40,
                    child: CustomTextFieldWidget(
                      borderColor: Theme.of(context).hintColor.withOpacity(0.4),
                      controller: _peopleNumberController,
                      inputType: TextInputType.number,
                      inputFormatter:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                      hintText: '${'ex'.tr}: 3',
                      hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                      focusNode: _peopleNumberFocusNode,
                    ),
                  ),
                  SizedBox(height: Dimensions.paddingSizeDefault,),

                  if(_errorText.isNotEmpty) Text(_errorText.first, style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error,
                  )),
                  SizedBox(height: Dimensions.paddingSizeDefault,),

                  CustomButtonWidget(
                    buttonText: 'save'.tr,  width: 300,
                    height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                    onPressed: (){

                      if(splashController.selectedTableId != null && _peopleNumberController.text.isNotEmpty) {
                        // if(Get.find<OrderController>().orderTableNumber != -1 && Get.find<OrderController>().orderTableNumber != splashController.selectedTableId!) {
                        //
                        // }
                        if(splashController.getTable(splashController.selectedTableId)!.capacity! < int.parse(_peopleNumberController.text)) {
                          _errorText = [];
                          _errorText.add('you_reach_max_capacity'.tr);

                        }else{
                          splashController.setTableId(splashController.selectedTableId!);
                          cartController.setPeopleNumber = int.parse(_peopleNumberController.text);
                          cartController.update();
                          Get.back();
                        }


                      }else{

                        _errorText = [];
                        _errorText.add(splashController.selectedTableId == null
                            ? 'set_your_table_number'.tr : 'set_people_number'.tr,
                        );
                      }
                      splashController.update();
                    },
                  ),
                ],),
              ),
            );
          }
        );
      }
    );
  }
}
