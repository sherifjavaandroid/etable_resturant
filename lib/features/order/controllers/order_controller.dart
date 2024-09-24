import 'dart:async';
import 'package:efood_table_booking/features/splash/controllers/splash_controller.dart';
import 'package:efood_table_booking/data/api/api_checker.dart';
import 'package:efood_table_booking/features/order/domain/models/order_details_model.dart';
import 'package:efood_table_booking/features/order/domain/models/order_success_model.dart';
import 'package:efood_table_booking/features/order/domain/models/place_order_body.dart';
import 'package:efood_table_booking/features/order/domain/reposotories/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({required this.orderRepo});

  bool _isLoading = false;
  final List<String> _paymentMethodList = ['cash', 'card'];
  String _selectedMethod = 'cash';
  PlaceOrderModel? _placeOrderBody;
  String? _orderNote;
  String? _currentOrderId;
  String? _currentOrderToken;
  OrderDetails? _currentOrderDetails;
  OrderSuccessModel? _orderSuccessModel;
  Duration _duration = const Duration();
  Timer? _timer;
  List<Order>? _orderList;

  String get selectedMethod => _selectedMethod;

  List<String> get paymentMethodList => _paymentMethodList;
  bool get isLoading => _isLoading;
  PlaceOrderModel? get placeOrderBody => _placeOrderBody;
  String? get orderNote => _orderNote;
  String? get currentOrderId => _currentOrderId;
  String? get currentOrderToken => _currentOrderToken;
  OrderDetails? get currentOrderDetails => _currentOrderDetails;
  OrderSuccessModel? get orderSuccessModel => _orderSuccessModel;
  Duration get duration => _duration;
  List<Order>? get orderList => _orderList;

  set setPlaceOrderBody(PlaceOrderModel value) {
    _placeOrderBody = value;
  }
  set isLoadingUpdate(bool isLoad) {
    _isLoading = isLoad;
  }

  set setCurrentOrderId(String? value) {
    _currentOrderId = value;
  }

  void setSelectedMethod(String value, {bool isUpdate = true}) {
    _selectedMethod = value;
   if(isUpdate) {
     update();
   }
  }

  void updateOrderNote(String? value) {
    _orderNote = value;
    update();
  }




  Future<void> placeOrder(PlaceOrderModel placeOrderBody, Function callback, String paidAmount, double changeAmount) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.placeOrder(placeOrderBody);
    _isLoading = false;

    if (response.statusCode == 200) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();

      _orderSuccessModel = OrderSuccessModel(
        orderId: '${response.body['order_id']}',
        branchTableToken: response.body['branch_table_token'],
        // paidAmount: double.parse(paidAmount.trim().isEmpty ? '0.0' : paidAmount),
        changeAmount: changeAmount,
        tableId: Get.find<SplashController>().getTableId().toString(),
        branchId: Get.find<SplashController>().getBranchId().toString(),
      );



      List<OrderSuccessModel> list = [];
     try{
       list.addAll(orderRepo.getOrderSuccessModelList());
     }catch(error){
       debugPrint('orderSuccess -$error');

     }

      list.add(_orderSuccessModel!);

     orderRepo.addOrderModel(list);
     callback(true, message, orderID);

    } else {
      callback(false, response.statusText, '-1',);
    }
    update();
  }

  List<OrderSuccessModel>? getOrderSuccessModel() {
    List<OrderSuccessModel>?  list;
    try {
      list =   orderRepo.getOrderSuccessModelList();
      list = list.reversed.toList();
      _orderSuccessModel = list.firstWhere((model) {
        return model.tableId == Get.find<SplashController>().getTableId().toString() &&
            Get.find<SplashController>().getBranchId().toString() == model.branchId.toString();
      });
    }catch(e) {
      list = [OrderSuccessModel(orderId: '-1', branchTableToken: '',)];
      _orderSuccessModel = list.first;
    }

    return list;
  }

  Future<List<Order>?> getOrderList() async {
    getOrderSuccessModel();
    _orderList = null;
    if(_orderSuccessModel?.orderId != '-1') {
      _isLoading = true;
      Response response = await  orderRepo.getOderList(
        _orderSuccessModel!.branchTableToken!,
      );
      if (response.statusCode == 200) {
       try{
         _orderList = OrderList(order: OrderList.fromJson(response.body).order?.reversed.toList()).order;
       }catch(e) {
         _orderList = [];
       }


      } else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }else{
      _orderList = [];
    }

    return _orderList;

  }

  double previousDueAmount() {
    double amount = 0;
    _orderList?.forEach((order) {
      if(order.paymentStatus == 'unpaid' && order.orderAmount != null) {
        amount = amount + order.orderAmount!.toDouble() ;
      }
    });

    return amount;

  }



  Future<void> getCurrentOrder(String? orderId, {bool isLoading = true}) async {
    if(isLoading) {
      _isLoading = true;
    }
    _currentOrderDetails = null;

   update();

   if(_orderSuccessModel?.orderId != '-1' && orderId != null) {
     Response response = await  orderRepo.getOrderDetails(
       orderId, _orderSuccessModel!.branchTableToken!,
     );

     if (response.statusCode == 200) {
       _currentOrderDetails =  OrderDetails.fromJson(response.body);

     } else {
       ApiChecker.checkApi(response);
     }
   }

   _isLoading = false;
   update();

  }


  Future<void> countDownTimer() async {
    DateTime orderTime;
    if(Get.find<SplashController>().configModel?.timeFormat == '12') {
      orderTime =  DateFormat("yyyy-MM-dd HH:mm").parse('${_currentOrderDetails?.order?.deliveryDate} ${_currentOrderDetails?.order?.deliveryTime}');

    }else{
      orderTime =  DateFormat("yyyy-MM-dd HH:mm").parse('${_currentOrderDetails?.order?.deliveryDate} ${_currentOrderDetails?.order?.deliveryTime}');
    }

    DateTime endTime = orderTime.add(Duration(minutes: int.parse('${_currentOrderDetails?.order?.preparationTime}')));

    _duration = endTime.difference(DateTime.now());
    cancelTimer();
    _timer = null;
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if(!_duration.isNegative && _duration.inMinutes > 0) {
        _duration = _duration - const Duration(minutes: 1);
        getOrderSuccessModel();
        getCurrentOrder(_orderSuccessModel?.orderId).then((value) => countDownTimer());
      }

    });




    if(_duration.isNegative) {
      _duration = const Duration();
    }_duration = endTime.difference(DateTime.now());

  }

  void cancelTimer() => _timer?.cancel();




}