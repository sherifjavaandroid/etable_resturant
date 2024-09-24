import 'package:efood_table_booking/common/models/language_model.dart';
import 'package:efood_table_booking/util/images.dart';

class AppConstants {
  static const String appName = 'eFood Table';
  static const String appVersion = '1.6';
  static const String fontFamily = 'Roboto';

  // demo
  static const String baseUrl = 'https://efood-admin.6amtech.com';
  static const String configUri = '/api/v1/config/table';
  static const String categoryUri = '/api/v1/categories';
  static const String productUri = '/api/v1/products/latest';
  static const String categoryProductUri = '/api/v1/categories/products';
  static const String placeOrderUri = '/api/v1/table/order/place';
  static const String orderDetailsUri = '/api/v1/table/order/details?';
  static const String orderList = '/api/v1/table/order/list?branch_table_token=';


  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String searchAddress = 'search_address';
  static const String topic = 'notify';
  static const String tableNumber = 'table_number';
  static const String branch = 'branch';
  static const String orderInfo = 'order_info';
  static const String isFixTable = 'is_fix_table';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.unitedKingdom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.unitedKingdom, languageName: 'Bengali', countryCode: 'BD', languageCode: 'bn'),
    LanguageModel(imageUrl: Images.saudi, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  ];
}
