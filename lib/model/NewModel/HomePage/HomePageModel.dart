// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

HomePageModel homePageModelFromJson(String str) =>
    HomePageModel.fromJson(json.decode(str));

String homePageModelToJson(HomePageModel data) => json.encode(data.toJson());

class HomePageModel {
  HomePageModel({
    this.topCategories,
    this.featuredBrands,
    this.sliders,
    this.newUserZone,
    this.flashDeal,
    this.topPicks,
    this.msg,
  });

  List<CategoryBrand>? topCategories;
  List<CategoryBrand>? featuredBrands;
  List<HomePageSlider>? sliders;
  NewUserZone? newUserZone;
  HomePageModelFlashDeal? flashDeal;
  List<ProductModel>? topPicks;
  String? msg;

  factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
        topCategories: List<CategoryBrand>.from(
          json["top_categories"].map(
            (x) => CategoryBrand.fromJson(x),
          ),
        ),
        featuredBrands: List<CategoryBrand>.from(
          json["featured_brands"].map(
            (x) => CategoryBrand.fromJson(x),
          ),
        ),
        sliders: List<HomePageSlider>.from(
          json["sliders"].map(
            (x) => HomePageSlider.fromJson(x),
          ),
        ),
        newUserZone: json["new_user_zone"] == null
            ? null
            : NewUserZone.fromJson(json["new_user_zone"]),
        flashDeal: json["flash_deal"] == null
            ? null
            : HomePageModelFlashDeal.fromJson(json["flash_deal"]),
        topPicks: List<ProductModel>.from(
          json["top_picks"].map(
            (x) => ProductModel.fromJson(x),
          ),
        ),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "top_categories": List<CategoryBrand>.from(
          topCategories!.map(
            (x) => x.toJson(),
          ),
        ),
        "featured_brands": List<CategoryBrand>.from(
          featuredBrands!.map(
            (x) => x.toJson(),
          ),
        ),
        "sliders": List<HomePageSlider>.from(
          sliders!.map(
            (x) => x.toJson(),
          ),
        ),
        "new_user_zone": newUserZone!.toJson(),
        "flash_deal": flashDeal!.toJson(),
        "top_picks": List<dynamic>.from(
          topPicks!.map(
            (x) => x.toJson(),
          ),
        ),
        "msg": msg,
      };
}

class CategoryBrand {
  CategoryBrand({
    this.id,
    this.name,
    this.logo,
    this.slug,
    this.icon,
    this.image,
  });

  int? id;
  String? name;
  String? logo;
  String? slug;
  String? icon;
  String? image;

  factory CategoryBrand.fromJson(Map<String, dynamic> json) => CategoryBrand(
        id: json["id"],
        name: json["name"],
        logo: json["logo"] == null ? null : json["logo"],
        slug: json["slug"] == null ? null : json["slug"],
        icon: json["icon"] == null ? null : json["icon"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo == null ? null : logo,
        "slug": slug == null ? null : slug,
        "icon": icon == null ? null : icon,
        "image": image == null ? null : image,
      };
}

class HomePageModelFlashDeal {
  HomePageModelFlashDeal({
    this.id,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.startDate,
    this.endDate,
    this.slug,
    this.bannerImage,
    this.isFeatured,
    this.allProducts,
  });

  int? id;
  String? title;
  String? backgroundColor;
  String? textColor;
  DateTime? startDate;
  DateTime? endDate;
  String? slug;
  String? bannerImage;
  int? isFeatured;
  List<FlashDealAllProduct>? allProducts;

  factory HomePageModelFlashDeal.fromJson(Map<String, dynamic> json) =>
      HomePageModelFlashDeal(
        id: json["id"],
        title: json["title"],
        backgroundColor: json["background_color"],
        textColor: json["text_color"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        slug: json["slug"],
        bannerImage: json["banner_image"],
        isFeatured: json["is_featured"],
        allProducts: List<FlashDealAllProduct>.from(
          json["AllProducts"].map(
            (x) => FlashDealAllProduct.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "background_color": backgroundColor,
        "text_color": textColor,
        "start_date":
            "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate?.year.toString().padLeft(4, '0')}-${endDate?.month.toString().padLeft(2, '0')}-${endDate?.day.toString().padLeft(2, '0')}",
        "slug": slug,
        "banner_image": bannerImage,
        "is_featured": isFeatured,
        "AllProducts": List<dynamic>.from(allProducts!.map((x) => x.toJson())),
      };
}

class FlashDealAllProduct {
  FlashDealAllProduct({
    this.id,
    this.flashDealId,
    this.sellerProductId,
    this.discount,
    this.discountType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  int? id;
  int? flashDealId;
  int? sellerProductId;
  int? discount;
  int? discountType;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductModel? product;

  factory FlashDealAllProduct.fromJson(Map<String, dynamic> json) =>
      FlashDealAllProduct(
        id: json["id"],
        flashDealId: json["flash_deal_id"],
        sellerProductId: json["seller_product_id"],
        discount: json["discount"],
        discountType: json["discount_type"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "flash_deal_id": flashDealId,
        "seller_product_id": sellerProductId,
        "discount": discount,
        "discount_type": discountType,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "product": product == null ? null : product?.toJson(),
      };
}

class NewUserZone {
  NewUserZone({
    this.id,
    this.title,
    this.backgroundColor,
    this.slug,
    this.bannerImage,
    this.productNavigationLabel,
    this.categoryNavigationLabel,
    this.couponNavigationLabel,
    this.productSlogan,
    this.categorySlogan,
    this.couponSlogan,
    this.coupon,
    this.allProducts,
  });

  int? id;
  String? title;
  String? backgroundColor;
  String? slug;
  String? bannerImage;
  String? productNavigationLabel;
  String? categoryNavigationLabel;
  String? couponNavigationLabel;
  String? productSlogan;
  String? categorySlogan;
  String? couponSlogan;
  Coupon? coupon;
  List<NewUserZoneAllProduct>? allProducts;

  factory NewUserZone.fromJson(Map<String, dynamic> json) => NewUserZone(
        id: json["id"],
        title: json["title"],
        backgroundColor: json["background_color"],
        slug: json["slug"],
        bannerImage: json["banner_image"],
        productNavigationLabel: json["product_navigation_label"],
        categoryNavigationLabel: json["category_navigation_label"],
        couponNavigationLabel: json["coupon_navigation_label"],
        productSlogan: json["product_slogan"],
        categorySlogan: json["category_slogan"],
        couponSlogan: json["coupon_slogan"],
        coupon: Coupon.fromJson(json["coupon"]),
        allProducts: List<NewUserZoneAllProduct>.from(
          json["AllProducts"].map(
            (x) {
              return NewUserZoneAllProduct.fromJson(x);
            },
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "background_color": backgroundColor,
        "slug": slug,
        "banner_image": bannerImage,
        "product_navigation_label": productNavigationLabel,
        "category_navigation_label": categoryNavigationLabel,
        "coupon_navigation_label": couponNavigationLabel,
        "product_slogan": productSlogan,
        "category_slogan": categorySlogan,
        "coupon_slogan": couponSlogan,
        "coupon": coupon?.toJson(),
        "AllProducts": List<dynamic>.from(allProducts!.map((x) => x.toJson())),
      };
}

class NewUserZoneAllProduct {
  NewUserZoneAllProduct({
    this.id,
    this.newUserZoneId,
    this.sellerProductId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  int? id;
  int? newUserZoneId;
  int? sellerProductId;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductModel? product;

  factory NewUserZoneAllProduct.fromJson(Map<String, dynamic> json) =>
      NewUserZoneAllProduct(
        id: json["id"],
        newUserZoneId: json["new_user_zone_id"],
        sellerProductId: json["seller_product_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        // product: ProductModel.fromJson(json["product"]),
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
      );
  //superadmin to leave

  Map<String, dynamic> toJson() => {
        "id": id,
        "new_user_zone_id": newUserZoneId,
        "seller_product_id": sellerProductId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "product": product?.toJson(),
      };
}

class Coupon {
  Coupon({
    this.id,
    this.title,
    this.couponCode,
    this.startDate,
    this.endDate,
    this.discount,
    this.discountType,
    this.minimumShopping,
    this.maximumDiscount,
  });

  int? id;
  String? title;
  String? couponCode;
  DateTime? startDate;
  DateTime? endDate;
  int? discount;
  int? discountType;
  int? minimumShopping;
  int? maximumDiscount;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        title: json["title"],
        couponCode: json["coupon_code"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        discount: json["discount"],
        discountType: json["discount_type"],
        minimumShopping: json["minimum_shopping"],
        maximumDiscount: json["maximum_discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "coupon_code": couponCode,
        "start_date":
            "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate?.year.toString().padLeft(4, '0')}-${endDate?.month.toString().padLeft(2, '0')}-${endDate?.day.toString().padLeft(2, '0')}",
        "discount": discount,
        "discount_type": discountType,
        "minimum_shopping": minimumShopping,
        "maximum_discount": maximumDiscount,
      };
}

class HomePageSlider {
  HomePageSlider({
    this.id,
    this.name,
    this.dataType,
    this.dataId,
    this.sliderImage,
    this.position,
    this.category,
    this.brand,
    this.tag,
  });

  int? id;
  String? name;
  SliderDataType? dataType;
  int? dataId;
  String? sliderImage;
  int? position;
  CategoryBrand? category;
  CategoryBrand? brand;
  CategoryBrand? tag;

  factory HomePageSlider.fromJson(Map<String, dynamic> json) => HomePageSlider(
        id: json["id"],
        name: json["name"],
        dataType: nameValues.map[json["data_type"]],
        dataId: json["data_id"],
        sliderImage: json["slider_image"],
        position: json["position"],
        category: json["category"] == null
            ? null
            : CategoryBrand.fromJson(json["category"]),
        brand: json["brand"] == null
            ? null
            : CategoryBrand.fromJson(json["brand"]),
        tag: json["tag"] == null ? null : CategoryBrand.fromJson(json["tag"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "data_type": nameValues.reverse?[dataType],
        "data_id": dataId,
        "slider_image": sliderImage,
        "position": position,
        "category": category == null ? null : category?.toJson(),
        "brand": brand == null ? null : brand?.toJson(),
        "tag": tag == null ? null : tag?.toJson(),
      };
}

enum SliderDataType { PRODUCT, CATEGORY, BRAND, TAG }

final nameValues = EnumValues({
  "product": SliderDataType.PRODUCT,
  "category": SliderDataType.CATEGORY,
  "brand": SliderDataType.BRAND,
  "tag": SliderDataType.TAG,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
