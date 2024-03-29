// // To parse this JSON data, do
// //
// //     final currencyModel = currencyModelFromJson(jsonString);

// import 'dart:convert';

// CurrencyModel currencyModelFromJson(String str) => CurrencyModel.fromJson(json.decode(str));

// String currencyModelToJson(CurrencyModel data) => json.encode(data.toJson());

// class CurrencyModel {
//   CurrencyModel({
//     this.currencies,
//     this.msg,
//   });

//   List<Currency> currencies;
//   String msg;

//   factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
//     currencies: List<Currency>.from(json["currencies"].map((x) => Currency.fromJson(x))),
//     msg: json["msg"],
//   );

//   Map<String, dynamic> toJson() => {
//     "currencies": List<dynamic>.from(currencies.map((x) => x.toJson())),
//     "msg": msg,
//   };
// }

class Currency {
  Currency({
    this.id,
    this.name,
    this.code,
    this.status,
    this.convertRate,
    this.symbol,
  });

  int? id;
  String? name;
  String? code;
  int? status;
  double? convertRate;
  String? symbol;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        status: json["status"],
        convertRate: json["convert_rate"].toDouble(),
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "status": status,
        "convert_rate": convertRate,
        "symbol": symbol,
      };
}
