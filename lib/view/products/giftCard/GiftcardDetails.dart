import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/my_wishlist_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/Product/Review.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/MainNavigation.dart';
import 'package:amazcart/view/account/Account.dart';
import 'package:amazcart/view/account/SignInOrRegister.dart';
import 'package:amazcart/view/authentication/LoginPage.dart';
import 'package:amazcart/view/cart/CartMain.dart';
import 'package:amazcart/view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/SliverAppBarTitleWidget.dart';
import 'package:amazcart/widgets/custom_clipper.dart';
// import 'package:amazcart/widgets/flutter_swiper/flutter_swiper.dart';
import 'package:badges/badges.dart' as badges;
import 'package:expandable/expandable.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_html/flutter_html.dart';

// import '../../../widgets/flutter_swiper/src/swiper.dart';
// import '../../../widgets/flutter_swiper/src/swiper_control.dart';
// import '../../../widgets/flutter_swiper/src/swiper_pagination.dart';
// import '../../../widgets/flutter_swiper/src/swiper_plugin.dart';

// ignore: must_be_immutable
class GiftcardDetails extends StatefulWidget {
  final ProductModel giftcard;

  GiftcardDetails({required this.giftcard});

  @override
  _GiftcardDetailsState createState() => _GiftcardDetailsState();
}

class _GiftcardDetailsState extends State<GiftcardDetails> {
  final CartController cartController = Get.put(CartController());

  final HomeController homeController = Get.put(HomeController());

  final GeneralSettingsController settingsController =
      Get.put(GeneralSettingsController());

  final LoginController _loginController = Get.put(LoginController());

  String popUpItem1 = "Home";

  String popUpItem2 = "Share";

  String popUpItem3 = "Search";

  var shippingValue;

  Future? productFuture;

  bool _inWishList = false;
  int? _wishListId;

  var split;
  DateTime? endDate;

  String getDiscountType(ProductModel productModel) {
    String discountType;

    if (productModel.hasDeal != null) {
      if (productModel.hasDeal?.discountType == 0) {
        discountType =
            '(-${productModel.hasDeal?.discount?.toStringAsFixed(2)}%)';
      } else {
        discountType =
            '(-${((productModel.hasDeal?.discount ?? 1) * settingsController.conversionRate.value).toStringAsFixed(2)}${settingsController.appCurrency.value})';
      }
    } else {
      if ((productModel.discount ?? 0) > 0) {
        if (productModel.discountType == '0') {
          discountType = '(-${productModel.discount?.toStringAsFixed(2)}%)';
        } else {
          discountType =
              '(-${((productModel.discount ?? 1) * settingsController.conversionRate.value).toStringAsFixed(2)}${settingsController.appCurrency.value})';
        }
      } else {
        discountType = '';
      }
    }

    return discountType;
  }

  RecommendedProductsLoadMore? source;

  @override
  void initState() {
    source = RecommendedProductsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source?.dispose();
    // Get.delete<ProductDetailsController>();

    super.dispose();
  }

  List<Review> productReviews = [];

  int stockManage = 0;
  int stockCount = 0;

  Future checkWishList() async {
    if (!_loginController.loggedIn.value) {
      return;
    } else {
      final MyWishListController _myWishListController =
          Get.put(MyWishListController());
      await _myWishListController.getAllWishList();
      if (_myWishListController.wishListModel.value.products != null) {
        _myWishListController.wishListModel.value.products?.values
            .forEach((element) {
          element.forEach((element2) {
            if (element2.type == ProductType.GIFT_CARD) {
              if (element2.giftcard?.id == widget.giftcard.id) {
                setState(() {
                  _inWishList = true;
                  _wishListId = int.parse(element2.giftcard?.id.toString() ??  '');
                });
              }
            } else {
              return null;
            }
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      body: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              pinned: true,
              collapsedHeight: 70,
              stretch: false,
              forceElevated: false,
              titleSpacing: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: SliverAppBarTitleWidget(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 2),
                      child: IconButton(
                        tooltip: "Back",
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.giftcard.giftCardName ?? '',
                          maxLines: 1,
                          style: AppStyles.kFontBlack17w5
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          child: IconButton(
                            tooltip: "Cart",
                            onPressed: () {
                              Get.to(() => CartMain(false));
                            },
                            icon: Container(
                              width: 45,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/icon_cart_white.png',
                                width: 35,
                                height: 35,
                                color: AppStyles.blackColor,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppStyles.pinkColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Obx(() {
                                return Text(
                                  '${cartController.cartListSelectedCount.value}',
                                  textAlign: TextAlign.center,
                                  style: AppStyles.kFontWhite12w5,
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              actions: [Container()],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: (widget.giftcard.giftCardGalleryImages?.length ?? 1) > 1
                            ? Container(
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(() => PhotoViewerWidget(
                                              giftCard: widget.giftcard,
                                              initialIndex: index,
                                            ));
                                      },
                                      child: FancyShimmerImage(
                                        imageUrl:
                                            "${AppConfig.assetPath}/${widget.giftcard.giftCardGalleryImages?[index].giftCardImage}",
                                        boxFit: BoxFit.contain,
                                        errorWidget: FancyShimmerImage(
                                          imageUrl:
                                              "${AppConfig.assetPath}/backend/img/default.png",
                                          boxFit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: widget.giftcard.giftCardGalleryImages?.length ?? 0,
                                  control: new SwiperControl(
                                      color: AppStyles.pinkColor),
                                  pagination: SwiperPagination(
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      builder: SwiperCustomPagination(builder:
                                          (BuildContext context,
                                              SwiperPluginConfig config) {
                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: RectSwiperPaginationBuilder(
                                            color: AppStyles.lightBlueColorAlt,
                                            activeColor: AppStyles.pinkColor,
                                            size: Size(10.0, 10.0),
                                            activeSize: Size(25.0, 10.0),
                                          ).build(context, config),
                                        );
                                      })),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  // Get.to(() => PhotoViewerWidget(
                                  //       productDetailsModel:
                                  //           _productDetailsModel,
                                  //       initialIndex: 0,
                                  //     ));
                                },
                                child: FancyShimmerImage(
                                  imageUrl:
                                      "${AppConfig.assetPath}/${widget.giftcard.giftCardThumbnailImage}",
                                  boxFit: BoxFit.contain,
                                  errorWidget: FancyShimmerImage(
                                    imageUrl:
                                        "${AppConfig.assetPath}/backend/img/default.png",
                                    boxFit: BoxFit.contain,
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: FloatingActionButton(
                                  heroTag: null,
                                  tooltip: "Back",
                                  elevation: 0,
                                  enableFeedback: false,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: FloatingActionButton(
                                heroTag: null,
                                tooltip: "Cart",
                                elevation: 0,
                                enableFeedback: false,
                                backgroundColor: Colors.transparent,
                                child: badges.Badge(
                                  badgeStyle: badges.BadgeStyle(
                                    badgeColor: AppStyles.pinkColor,
                                  ),
                                  badgeAnimation: badges.BadgeAnimation.fade(
                                    toAnimate: false,
                                  ),

                                  badgeContent: Text(
                                    '${cartController.cartListSelectedCount.value.toString()}',
                                    style: AppStyles.appFont.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/images/icon_cart_white.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(() => CartMain(false));
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        // pinnedHeaderSliverHeightBuilder: () {
        //   return pinnedHeaderHeight;
        // },
        body: LoadingMoreCustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              settingsController
                                      .calculateGiftcardPrice(widget.giftcard) +
                                  settingsController.appCurrency.value,
                              style: AppStyles.kFontPink15w5.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Expanded(child: Container()),
                            Container(
                              width: 30,
                              height: 30,
                              child: InkWell(
                                onTap: () async {
                                  final LoginController loginController =
                                      Get.put(LoginController());

                                  if (loginController.loggedIn.value) {
                                    final MyWishListController
                                        wishListController =
                                        Get.put(MyWishListController());
                                    if (_inWishList) {
                                      await wishListController
                                          .deleteWishListProduct(_wishListId)
                                          .then((value) {
                                        setState(() {
                                          _inWishList = false;
                                        });
                                      });
                                    } else {
                                      Map data = {
                                        'seller_product_id': widget.giftcard.id,
                                        'seller_id': 1,
                                        'type': 'gift_card',
                                      };

                                      await wishListController
                                          .addProductToWishList(data)
                                          .then((value) {
                                        setState(() {
                                          _inWishList = true;
                                        });
                                      });
                                    }
                                  } else {
                                    Get.dialog(LoginPage(), useSafeArea: false);
                                  }
                                },
                                child: Icon(
                                  _inWishList
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  size: 20,
                                  color: _inWishList
                                      ? AppStyles.pinkColor
                                      : AppStyles.greyColorLight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        (widget.giftcard.giftCardEndDate?.compareTo(DateTime.now()) ?? 0) > 0
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        settingsController.calculateMainPrice(
                                            widget.giftcard),
                                        style: AppStyles.kFontGrey14w5.copyWith(
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        getDiscountType(widget.giftcard),
                                        style: AppStyles.kFontGrey14w5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                ],
                              )
                            : Container(),
                        Text(
                          widget.giftcard.giftCardName ?? '',
                          style: AppStyles.kFontBlack15w4.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: Color(0xff242424),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Text(
                              'Product Specifications'.tr,
                              style: AppStyles.kFontGrey14w5,
                            )),
                        Divider(
                          color: AppStyles.textFieldFillColor,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //** SKU */
                        widget.giftcard.giftCardSku != null
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        color: AppStyles.darkBlueColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Product SKU".tr + ": ",
                                        style: AppStyles.kFontGrey14w5,
                                      ),
                                      Text(
                                        "${widget.giftcard.giftCardSku}",
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),

                        //** TAGS */
                        // _productDetailsModel.data.product.tags.length > 0
                        //     ? Column(
                        //         children: [
                        //           Wrap(
                        //             spacing: 5,
                        //             children: List.generate(
                        //                 _productDetailsModel
                        //                         .data.product.tags.length +
                        //                     1, (tagIndex) {
                        //               if (tagIndex == 0) {
                        //                 return Row(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.start,
                        //                   children: [
                        //                     Text(
                        //                       'Tags'.tr + ':',
                        //                       style: AppStyles.kFontGrey14w5,
                        //                     ),
                        //                     SizedBox(
                        //                       width: 5,
                        //                     ),
                        //                   ],
                        //                 );
                        //               }
                        //               return InkWell(
                        //                 onTap: () {
                        //                   Get.to(() => ProductsByTags(
                        //                         tagName: _productDetailsModel
                        //                             .data
                        //                             .product
                        //                             .tags[tagIndex - 1]
                        //                             .name,
                        //                         tagId: _productDetailsModel
                        //                             .data
                        //                             .product
                        //                             .tags[tagIndex - 1]
                        //                             .id,
                        //                       ));
                        //                 },
                        //                 child: Chip(
                        //                   backgroundColor:
                        //                       AppStyles.lightBlueColorAlt,
                        //                   shape: RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius.circular(5)),
                        //                   label: Text(
                        //                     '${_productDetailsModel.data.product.tags[tagIndex - 1].name}',
                        //                     style: AppStyles.kFontBlack14w5,
                        //                   ),
                        //                 ),
                        //               );
                        //             }),
                        //           ),
                        //           SizedBox(
                        //             height: 15,
                        //           ),
                        //         ],
                        //       )
                        //     : SizedBox.shrink(),
                      ],
                    ),
                  ),

                  widget.giftcard.giftCardDescription != null
                      ? Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    'Description'.tr,
                                    style: AppStyles.kFontGrey14w5,
                                  )),
                              Divider(
                                color: AppStyles.textFieldFillColor,
                                thickness: 1,
                                height: 1,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: htmlExpandingWidget(
                                    "${widget.giftcard.giftCardDescription ?? ""}"),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),

                  //** Ratings And reviews
                  // productReviews.length > 0
                  //     ? ListView(
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         padding: EdgeInsets.symmetric(vertical: 10),
                  //         children: [
                  //           InkWell(
                  //             onTap: () {
                  //               Get.to(() => RatingsAndReviews(
                  //                     productReviews: productReviews,
                  //                   ));
                  //             },
                  //             child: Container(
                  //               color: Colors.white,
                  //               padding: EdgeInsets.symmetric(
                  //                   horizontal: 20, vertical: 15),
                  //               child: Row(
                  //                 children: [
                  //                   Text(
                  //                     'Ratings & Reviews'.tr,
                  //                     textAlign: TextAlign.center,
                  //                     style: AppStyles.kFontBlack14w5.copyWith(
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 14,
                  //                     ),
                  //                   ),
                  //                   Expanded(child: Container()),
                  //                   Row(
                  //                     children: [
                  //                       Text(
                  //                         'VIEW ALL'.tr,
                  //                         textAlign: TextAlign.center,
                  //                         style: AppStyles.kFontBlack14w5
                  //                             .copyWith(
                  //                                 color: AppStyles.pinkColor),
                  //                       ),
                  //                       Icon(
                  //                         Icons.arrow_forward_ios,
                  //                         size: 14,
                  //                         color: AppStyles.pinkColor,
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           Divider(
                  //             color: AppStyles.textFieldFillColor,
                  //             thickness: 1,
                  //             height: 1,
                  //           ),
                  //           Container(
                  //             color: Colors.white,
                  //             child: ListView.separated(
                  //               separatorBuilder: (context, index) {
                  //                 return Divider(
                  //                   height: 20,
                  //                   thickness: 2,
                  //                   color: AppStyles.appBackgroundColor,
                  //                 );
                  //               },
                  //               physics: NeverScrollableScrollPhysics(),
                  //               padding: EdgeInsets.symmetric(
                  //                   horizontal: 20, vertical: 10),
                  //               shrinkWrap: true,
                  //               itemCount: productReviews.take(4).length,
                  //               itemBuilder: (context, index) {
                  //                 Review review = productReviews[index];
                  //                 return Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     SizedBox(
                  //                       height: 10,
                  //                     ),
                  //                     Row(
                  //                       children: <Widget>[
                  //                         review.isAnonymous == 1
                  //                             ? Text(
                  //                                 'User'.tr,
                  //                                 style: AppStyles.kFontGrey12w5
                  //                                     .copyWith(
                  //                                   fontWeight: FontWeight.bold,
                  //                                   color: AppStyles.blackColor,
                  //                                 ),
                  //                               )
                  //                             : Text(
                  //                                 review.customer.firstName
                  //                                             .toString()
                  //                                             .capitalizeFirst +
                  //                                         ' ' +
                  //                                         review
                  //                                             .customer.lastName
                  //                                             .toString()
                  //                                             .capitalizeFirst ??
                  //                                     "",
                  //                                 style: AppStyles.kFontGrey12w5
                  //                                     .copyWith(
                  //                                   fontWeight: FontWeight.bold,
                  //                                   color: AppStyles.blackColor,
                  //                                 ),
                  //                               ),
                  //                         SizedBox(
                  //                           width: 5,
                  //                         ),
                  //                         Text(
                  //                           '- ' +
                  //                               CustomDate().formattedDate(
                  //                                   review.createdAt),
                  //                           style: AppStyles.kFontGrey12w5,
                  //                         ),
                  //                         Expanded(child: Container()),
                  //                         StarCounterWidget(
                  //                           value: int.parse(
                  //                                   review.rating.toString())
                  //                               .toDouble(),
                  //                           color: AppStyles.goldenYellowColor,
                  //                           size: 15,
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(
                  //                       height: 5,
                  //                     ),
                  //                     Text(
                  //                       review.review,
                  //                       style: AppStyles.kFontGrey12w5,
                  //                     ),
                  //                   ],
                  //                 );
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : Container(),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppStyles.textFieldFillColor,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'You might like'.tr,
                  textAlign: TextAlign.center,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            LoadingMoreSliverList<ProductModel>(
              SliverListConfig<ProductModel>(
                padding: EdgeInsets.all(5),
                indicatorBuilder: BuildIndicatorBuilder(
                  source: source,
                  isSliver: true,
                  name: 'Recommended Products'.tr,
                ).buildIndicator,
                extendedListDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (BuildContext c, ProductModel prod, int index) {
                  return GridViewProductWidget(
                    productModel: prod,
                  );
                },
                sourceList: source!,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0.0, 0.3),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Get.to(() => MainNavigation(
                        navIndex: 0,
                        hideNavBar: false,
                      ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/icon_nav_home.svg',
                        color: AppStyles.pinkColor,
                        width: 25,
                      ),
                    ),
                    Text(
                      'Home'.tr,
                      style: AppStyles.kFontPink15w5.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => MessageNotifications());
              //   },
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         child: SvgPicture.asset(
              //           'assets/images/icon_nav_message.svg',
              //           color: AppStyles.pinkColor,
              //           width: 25.h,
              //         ),
              //       ),
              //       Text(
              //         'Notification'.tr,
              //         style: AppStyles.kFontPink15w5.copyWith(
              //           fontSize: 12.sp,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   width: 10,
              // ),

              GestureDetector(
                onTap: () {
                  Get.to(() => CartMain(false));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/icon_nav_cart.svg',
                        color: AppStyles.pinkColor,
                        width: 25,
                      ),
                    ),
                    Text(
                      'Cart'.tr,
                      style: AppStyles.kFontPink15w5.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),

              GestureDetector(
                onTap: () {
                  if (_loginController.loggedIn.value) {
                    Get.to(() => Account());
                  } else {
                    Get.to(() => SignInOrRegister());
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/icon_nav_account.svg',
                        color: AppStyles.pinkColor,
                        width: 25,
                      ),
                    ),
                    Text(
                      'Account'.tr,
                      style: AppStyles.kFontPink15w5.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ClipPath(
                clipper: SkewCutRight(),
                child: GestureDetector(
                  onTap: () async {},
                  child: Container(
                    alignment: Alignment.center,
                    width: Get.width * 0.40,
                    decoration: BoxDecoration(
                      color: AppStyles.pinkColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Add to Cart",
                        textAlign: TextAlign.center,
                        style: AppStyles.kFontWhite14w5.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  ExpandableNotifier htmlExpandingWidget(text) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expandable(
              controller: ExpandableController.of(context),
              collapsed: Container(
                height: 50,
                width: double.infinity,
                child: Html(
                  data: '''$text''',
                  style: {
                    "td": Style(
                      width: Width(double.infinity),
                      // width: double.infinity,
                    ),
                  },
                ),
              ),
              expanded: Container(
                child: Html(
                  data: '''$text''',
                  style: {
                    "td": Style(
                      width: Width(double.infinity),
                      // width: double.infinity,
                    ),
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    ExpandableController? controller =
                        ExpandableController.of(context);
                    return TextButton(
                      child: Text(
                        !controller!.expanded ? "View more" : "Show less",
                        style: AppStyles.kFontGrey12w5,
                      ),
                      onPressed: () {
                        controller.toggle();
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PhotoViewerWidget extends StatefulWidget {
  final ProductModel giftCard;
  final int initialIndex;

  PhotoViewerWidget({required this.giftCard, this.initialIndex = 0});

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget> {
  int currentIndex = 0;
  PageController? pageController;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    pageController = PageController(
      initialPage: widget.initialIndex,
    );
    currentIndex = pageController!.initialPage;
    super.initState();
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(AppConfig.assetPath + '/' + '${widget.giftCard.giftCardGalleryImages?[index].giftCardImage}'),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.giftCard.giftCardGalleryImages?[index].id ?? ''),
              );
            },
            itemCount: widget.giftCard.giftCardGalleryImages?.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / (event.expectedTotalBytes??0).toInt(),
                ),
              ),
            ),
            backgroundDecoration: const BoxDecoration(
              color: Colors.white,
            ),
            pageController: pageController,
            onPageChanged: onPageChanged,
            enableRotation: false,
          ),
        ),
        Positioned(
          top: Get.statusBarHeight * 0.3,
          left: 10,
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  )),
              Text("${widget.giftCard.giftCardName ?? ""}",
                  style: AppStyles.kFontBlack14w5),
            ],
          ),
        ),
        Positioned(
          bottom: Get.bottomBarHeight * 0.3,
          left: 0,
          right: 0,
          child: Container(
            height: Get.height * 0.1,
            width: 100,
            child: ListView.separated(
                itemCount: widget.giftCard.giftCardGalleryImages?.length ?? 0,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10);
                },
                itemBuilder: (context, imageIndex) {
                  return GestureDetector(
                    onTap: () {
                      pageController?.jumpToPage(imageIndex);
                    },
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: imageIndex == currentIndex
                            ? Colors.red
                            : Colors.white,
                      )),
                      child: FancyShimmerImage(
                        imageUrl: AppConfig.assetPath +
                            '/' +
                            '${widget.giftCard.giftCardGalleryImages?[imageIndex].giftCardImage}',
                        boxFit: BoxFit.contain,
                        errorWidget: FancyShimmerImage(
                          imageUrl:
                              "${AppConfig.assetPath}/backend/img/default.png",
                          boxFit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
