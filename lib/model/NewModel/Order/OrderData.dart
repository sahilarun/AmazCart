import 'package:amazcart/model/NewModel/Customer/CustomerData.dart';
import 'package:amazcart/model/NewModel/Customer/CustomerShippingAddress.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';

class OrderData {
  OrderData({
    this.id,
    this.customerId,
    this.orderPaymentId,
    this.orderType,
    this.orderNumber,
    this.paymentType,
    this.isPaid,
    this.isConfirmed,
    this.isCompleted,
    this.isCancelled,
    this.customerEmail,
    this.customerPhone,
    this.numberOfPackage,
    this.grandTotal,
    this.subTotal,
    this.discountTotal,
    this.shippingTotal,
    this.numberOfItem,
    this.orderStatus,
    this.taxAmount,
    this.customer,
    this.packages,
    this.shippingAddress,
    this.billingAddress,
    this.orderAddress,
    this.createdAt,
    this.updatedAt,
    this.deliveryType,
  });

  dynamic id;
  dynamic customerId;
  dynamic orderPaymentId;
  dynamic orderType;
  String? orderNumber;
  dynamic paymentType;
  dynamic isPaid;
  dynamic isConfirmed;
  dynamic isCompleted;
  dynamic isCancelled;
  String? customerEmail;
  String? customerPhone;
  String? deliveryType;
  dynamic numberOfPackage;
  double? grandTotal;
  dynamic subTotal;
  dynamic discountTotal;
  dynamic shippingTotal;
  dynamic numberOfItem;
  dynamic orderStatus;
  double? taxAmount;
  CustomerData? customer;
  List<Package>? packages;
  CustomerShippingAddress? shippingAddress;
  CustomerShippingAddress? billingAddress;
  OrderAddress? orderAddress;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        id: json["id"],
        customerId: json["customer_id"],
        orderPaymentId:
            json["order_payment_id"] == null ? null : json["order_payment_id"],
        orderType: json["order_type"],
        orderNumber: json["order_number"],
        paymentType: json["payment_type"],
        isPaid: json["is_paid"],
        isConfirmed: json["is_confirmed"],
        isCompleted: json["is_completed"],
        isCancelled: json["is_cancelled"],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        deliveryType: json["delivery_type"],
        numberOfPackage: json["number_of_package"],
        grandTotal: json["grand_total"].toDouble(),
        subTotal: json["sub_total"],
        discountTotal: json["discount_total"],
        shippingTotal: json["shipping_total"],
        numberOfItem: json["number_of_item"],
        orderStatus: json["order_status"],
        taxAmount: json["tax_amount"].toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customer: json["customer"] == null
            ? null
            : CustomerData.fromJson(json["customer"]),
        packages: json["packages"] == null
            ? null
            : List<Package>.from(
                json["packages"].map((x) => Package.fromJson(x))),
        shippingAddress: json["shipping_address"] == null
            ? null
            : CustomerShippingAddress.fromJson(json["shipping_address"]),
        billingAddress: json["billing_address"] == null
            ? null
            : CustomerShippingAddress.fromJson(json["billing_address"]),
        orderAddress: json["address"] == null
            ? null
            : OrderAddress.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "order_payment_id": orderPaymentId == null ? null : orderPaymentId,
        "order_type": orderType,
        "order_number": orderNumber,
        "payment_type": paymentType,
        "is_paid": isPaid,
        "is_confirmed": isConfirmed,
        "is_completed": isCompleted,
        "is_cancelled": isCancelled,
        "customer_email": customerEmail,
        "customer_phone": customerPhone,
        "delivery_type": deliveryType,
        "number_of_package": numberOfPackage,
        "grand_total": grandTotal,
        "sub_total": subTotal,
        "discount_total": discountTotal,
        "shipping_total": shippingTotal,
        "number_of_item": numberOfItem,
        "order_status": orderStatus,
        "tax_amount": taxAmount,
        "customer": customer?.toJson(),
        "packages": List<dynamic>.from(packages!.map((x) => x.toJson())),
        "shipping_address": shippingAddress?.toJson(),
        "billing_address": billingAddress?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class OrderAddress {
  OrderAddress({
    this.id,
    this.orderId,
    this.customerId,
    this.shippingName,
    this.shippingEmail,
    this.shippingPhone,
    this.shippingAddress,
    this.shippingCountryId,
    this.shippingStateId,
    this.shippingCityId,
    this.shippingPostcode,
    this.billToSameAddress,
    this.billingName,
    this.billingEmail,
    this.billingPhone,
    this.billingAddress,
    this.billingCountryId,
    this.billingStateId,
    this.billingCityId,
    this.billingPostcode,
    this.createdAt,
    this.updatedAt,
    this.getShippingCountry,
    this.getShippingState,
    this.getShippingCity,
    this.getBillingCountry,
    this.getBillingState,
    this.getBillingCity,
  });

  int? id;
  int? orderId;
  int? customerId;
  String? shippingName;
  String? shippingEmail;
  String? shippingPhone;
  String? shippingAddress;
  String? shippingCountryId;
  String? shippingStateId;
  String? shippingCityId;
  String? shippingPostcode;
  int? billToSameAddress;
  String? billingName;
  String? billingEmail;
  String? billingPhone;
  String? billingAddress;
  String? billingCountryId;
  String? billingStateId;
  String? billingCityId;
  String? billingPostcode;
  DateTime? createdAt;
  DateTime? updatedAt;
  GetIngCountry? getShippingCountry;
  GetIngCountry2? getShippingState;
  GetIngCountry2? getShippingCity;
  GetIngCountry? getBillingCountry;
  GetIngCountry2? getBillingState;
  GetIngCountry2? getBillingCity;

  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
        id: json["id"],
        orderId: json["order_id"],
        customerId: json["customer_id"],
        shippingName: json["shipping_name"],
        shippingEmail: json["shipping_email"],
        shippingPhone: json["shipping_phone"],
        shippingAddress: json["shipping_address"],
        shippingCountryId: json["shipping_country_id"],
        shippingStateId: json["shipping_state_id"],
        shippingCityId: json["shipping_city_id"],
        shippingPostcode: json["shipping_postcode"],
        billToSameAddress: json["bill_to_same_address"],
        billingName: json["billing_name"],
        billingEmail: json["billing_email"],
        billingPhone: json["billing_phone"],
        billingAddress: json["billing_address"],
        billingCountryId: json["billing_country_id"],
        billingStateId: json["billing_state_id"],
        billingCityId: json["billing_city_id"],
        billingPostcode: json["billing_postcode"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        getShippingCountry:
            GetIngCountry.fromJson(json["get_shipping_country"]),
        getShippingState: GetIngCountry2.fromJson(json["get_shipping_state"]),
        getShippingCity: GetIngCountry2.fromJson(json["get_shipping_city"]),
        getBillingCountry: GetIngCountry.fromJson(json["get_billing_country"]),
        getBillingState: GetIngCountry2.fromJson(json["get_billing_state"]),
        getBillingCity: GetIngCountry2.fromJson(json["get_billing_city"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "customer_id": customerId,
        "shipping_name": shippingName,
        "shipping_email": shippingEmail,
        "shipping_phone": shippingPhone,
        "shipping_address": shippingAddress,
        "shipping_country_id": shippingCountryId,
        "shipping_state_id": shippingStateId,
        "shipping_city_id": shippingCityId,
        "shipping_postcode": shippingPostcode,
        "bill_to_same_address": billToSameAddress,
        "billing_name": billingName,
        "billing_email": billingEmail,
        "billing_phone": billingPhone,
        "billing_address": billingAddress,
        "billing_country_id": billingCountryId,
        "billing_state_id": billingStateId,
        "billing_city_id": billingCityId,
        "billing_postcode": billingPostcode,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "get_shipping_country": getShippingCountry?.toJson(),
        "get_shipping_state": getShippingState?.toJson(),
        "get_shipping_city": getShippingCity?.toJson(),
        "get_billing_country": getBillingCountry?.toJson(),
        "get_billing_state": getBillingState?.toJson(),
        "get_billing_city": getBillingCity?.toJson(),
      };
}

class GetIngCountry2 {
  GetIngCountry2({
    this.id,
    this.name,
    this.stateId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.countryId,
  });

  int? id;
  String? name;
  int? stateId;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;
  int? countryId;

  factory GetIngCountry2.fromJson(Map<String, dynamic> json) => GetIngCountry2(
        id: json["id"],
        name: json["name"],
        stateId: json["state_id"] == null ? null : json["state_id"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        countryId: json["country_id"] == null ? null : json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state_id": stateId == null ? null : stateId,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "country_id": countryId == null ? null : countryId,
      };
}

class GetIngCountry {
  GetIngCountry({
    this.id,
    this.code,
    this.name,
    this.phonecode,
    this.flag,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? code;
  String? name;
  String? phonecode;
  String? flag;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;

  factory GetIngCountry.fromJson(Map<String, dynamic> json) => GetIngCountry(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        phonecode: json["phonecode"],
        flag: json["flag"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "phonecode": phonecode,
        "flag": flag,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
