import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Category/SingleCategory.dart';
import 'package:amazcart/model/NewModel/HomePage/HomePageModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/marketing/AllTopPickProducts.dart';
import 'package:amazcart/view/marketing/FlashDealView.dart';
import 'package:amazcart/view/marketing/NewUserZone/NewUserZonePage.dart';
import 'package:amazcart/view/products/AllCategorySubCategory.dart';
import 'package:amazcart/view/products/product/ProductDetails.dart';
import 'package:amazcart/view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/products/brand/AllBrandsPage.dart';
import 'package:amazcart/view/products/brand/ProductsByBrands.dart';
import 'package:amazcart/view/products/category/ProductsByCategory.dart';
import 'package:amazcart/view/products/tags/ProductsByTags.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/HomeTitlesWidget.dart';
import 'package:amazcart/widgets/HorizontalProductWidget.dart';
import 'package:amazcart/widgets/custom_input_border.dart';
import 'package:amazcart/widgets/fa_icon_maker/fa_custom_icon.dart';
// import 'package:amazcart/widgets/flutter_swiper/flutter_swiper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:loading_skeleton_niu/loading_skeleton.dart';
// import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:supercharged/supercharged.dart';
import 'package:amazcart/widgets/custom_grid_delegate.dart';

// import '../widgets/flutter_swiper/src/swiper.dart';
// import '../widgets/flutter_swiper/src/swiper_pagination.dart';
// import '../widgets/flutter_swiper/src/swiper_plugin.dart';
import 'SearchPageMain.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final HomeController controller = Get.put(HomeController());

  final HomeController _homeController = Get.put(HomeController());

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  RecommendedProductsLoadMore? source;

  @override
  void initState() {
    source = RecommendedProductsLoadMore();
    super.initState();
  }

  @override
  void dispose() {
    source?.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    print('refres');
    // controller.forceR.value = true;
    // controller.allRecommendedProds.clear();
    // controller.recommendedPageNumber.value = 1;
    // controller.recommendedLastPage.value = false;

    // controller.allTopPicksProds.clear();
    // controller.chunkedBrands.clear();
    // controller.topPicksPageNumber.value = 1;
    // controller.topPicksLastPage.value = false;
    // controller.onInit();
    // controller.forceR.value = false;

    await _homeController.getHomePage();
    source?.refresh(true);
  }

  RadialGradient selectColor(int position) {
    RadialGradient c = RadialGradient(
      center: Alignment(0.7, -0.6), // near the top right
      radius: 0.2,
      colors:  [
        Color(0xFFFFFF00), // yellow sun
        Color(0xFF0099FF), // blue sky
      ],
      stops:  [0.4, 1.0],
    );
    if (position % 8 == 0)
      c = RadialGradient(colors: [
        Color(0xFFD35DDD),
        Color(0xFFA100AF),
      ]);
    if (position % 8 == 1)
      c = RadialGradient(colors: [
        Color(0xFF5580D3),
        Color(0xFF003464),
      ]);
    if (position % 8 == 2)
      c = RadialGradient(colors: [
        Color(0xFF8564E1),
        Color(0xFF4922B7),
      ]);
    if (position % 8 == 3)
      c = RadialGradient(colors: [
        Color(0xFFFF4387),
        Color(0xFFC60077),
      ]);
    if (position % 8 == 4)
      c = RadialGradient(colors: [
        Color(0xFFFF4370),
        Color(0xFFCE0019),
      ]);
    if (position % 8 == 5)
      c = RadialGradient(colors: [
        Color(0xFF36C25E),
        Color(0xFF00A324),
      ]);
    if (position % 8 == 6)
      c = RadialGradient(colors: [
        Color(0xFF852A8D),
        Color(0xFF5C0064),
      ]);
    if (position % 8 == 7)
      c = RadialGradient(colors: [
        Color(0xFFFF6C4B),
        Color(0xFFDB2B20),
      ]);
    return c;
  }

  final ScrollController scrollController = ScrollController();

  bool isScrolling = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        floatingActionButton: isScrolling
            ? Container(
                margin: EdgeInsets.only(bottom: 60),
                child: FloatingActionButton.small(
                  backgroundColor: AppStyles.pinkColor,
                  onPressed: () {
                    scrollController.animateTo(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: Icon(Icons.arrow_upward_sharp, size: 16),
                ),
              )
            : Container(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            onRefresh: refresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                FocusScope.of(context).unfocus();
                if (scrollController.offset > 0) {
                  setState(() {
                    isScrolling = true;
                  });
                } else {
                  setState(() {
                    isScrolling = false;
                  });
                }
                return false;
              },
              child: LoadingMoreCustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppStyles.appBackgroundColor,
                    titleSpacing: 10,
                    pinned: true,
                    elevation: 0,
                    title: Row(
                      children: [
                        Image.asset(
                          "${AppConfig.appBanner}",
                          height: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // Expanded(child: Container()),
                        // IconButton(
                        //   onPressed: () {
                        //     Get.to(() => SearchPageMain());
                        //   },
                        //   icon: Icon(
                        //     FontAwesomeIcons.search,
                        //   ),
                        // ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => SearchPageMain());
                            },
                            child: Container(
                              height: 40,
                              child: TextField(
                                autofocus: true,
                                enabled: false,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.text,
                                style: AppStyles.appFont.copyWith(
                                  fontSize: 12,
                                  color: AppStyles.greyColorDark,
                                ),
                                decoration: CustomInputBorder()
                                    .inputDecoration(
                                      '${AppConfig.appName}',
                                    )
                                    .copyWith(
                                      suffixIcon: Icon(Icons.search),
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      children: [
                        ///** SLIDER
                        Obx(() {
                          if (_homeController.isHomePageLoading.value) {
                            return ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: Container(
                                padding: EdgeInsets.all(1),
                                child: LoadingSkeleton(
                                  height: 150,
                                  width: Get.width,
                                  colors: [
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.2),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            if (_homeController
                                    .homePageModel.value.sliders!.length >
                                0) {
                              return ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: AspectRatio(
                                  aspectRatio: 16/5,
                                  child: Swiper(
                                    itemCount: _homeController
                                        .homePageModel.value.sliders!.length,
                                    autoplay: true,
                                    autoplayDelay: 5000,
                                    itemBuilder: (BuildContext context,
                                        int sliderIndex) {
                                      HomePageSlider slider = _homeController
                                          .homePageModel
                                          .value
                                          .sliders![sliderIndex];
                                      return FancyShimmerImage(
                                        imageUrl: AppConfig.assetPath +
                                            '/' +
                                            slider.sliderImage!,
                                        boxFit: BoxFit.cover,
                                        width: Get.width,
                                        errorWidget: FancyShimmerImage(
                                          imageUrl:
                                              "${AppConfig.assetPath}/backend/img/default.png",
                                          boxFit: BoxFit.contain,
                                          errorWidget: FancyShimmerImage(
                                            imageUrl:
                                                "${AppConfig.assetPath}/backend/img/default.png",
                                            boxFit: BoxFit.contain,
                                          ),
                                        ),
                                      );
                                    },
                                    onTap: (sliderIndex) {
                                      HomePageSlider slider = _homeController
                                          .homePageModel
                                          .value
                                          .sliders![sliderIndex];
                                      if (slider.dataType ==
                                          SliderDataType.PRODUCT) {
                                        Get.to(() => ProductDetails(
                                              productID: slider.dataId!,
                                            ));
                                      } else if (slider.dataType ==
                                          SliderDataType.CATEGORY) {
                                        print('category');
                                        _homeController.categoryId.value =
                                            slider.dataId!;
                                        _homeController.categoryIdBeforeFilter
                                            .value = slider.dataId!;
                                        _homeController.allProds.clear();
                                        _homeController.subCats.clear();
                                        _homeController.lastPage.value = false;
                                        _homeController.pageNumber.value = 1;
                                        _homeController.category.value =
                                            CategoryData();
                                        _homeController.catAllData.value =
                                            SingleCategory();
                                        // controller.dataFilter.value =
                                        //     FilterFromCatModel();
                                        _homeController.getCategoryProducts();
                                        _homeController.getCategoryFilterData();
                                        if (_homeController.dataFilterCat.value
                                                .filterDataFromCat !=
                                            null) {
                                          _homeController.dataFilterCat.value
                                              .filterDataFromCat!.filterType!
                                              .forEach((element) {
                                            if (element.filterTypeId ==
                                                    'brand' ||
                                                element.filterTypeId == 'cat') {
                                              print(element.filterTypeId);
                                              element.filterTypeValue!.clear();
                                            }
                                          });
                                        }

                                        _homeController.filterRating.value =
                                            0.0;

                                        Get.to(() => ProductsByCategory(
                                              categoryId: slider.dataId!,
                                            ));
                                      } else if (slider.dataType ==
                                          SliderDataType.BRAND) {
                                        print('brand');
                                        _homeController.brandId.value =
                                            slider.dataId!;
                                        _homeController.allBrandProducts
                                            .clear();
                                        _homeController.subCatsInBrands.clear();
                                        _homeController.lastBrandPage.value =
                                            false;
                                        _homeController.brandPageNumber.value =
                                            1;
                                        _homeController.getBrandProducts();
                                        _homeController.getBrandFilterData();

                                        if (_homeController.dataFilterCat.value
                                                .filterDataFromCat !=
                                            null) {
                                          _homeController.dataFilterCat.value
                                              .filterDataFromCat!.filterType!
                                              .forEach((element) {
                                            if (element.filterTypeId ==
                                                    'brand' ||
                                                element.filterTypeId == 'cat') {
                                              print(element.filterTypeId);
                                              element.filterTypeValue!.clear();
                                            }
                                          });
                                        }
                                        Get.to(() => ProductsByBrands(
                                              brandId: slider.dataId!,
                                            ));
                                      } else if (slider.dataType ==
                                          SliderDataType.TAG) {
                                        print('tag -- ${slider.tag!.name}');

                                        Get.to(() => ProductsByTags(
                                              tagName: slider.tag!.name!,
                                              tagId: slider.tag!.id!,
                                            ));
                                      }
                                    },
                                    pagination: SwiperPagination(
                                        margin: EdgeInsets.all(5.0),
                                        builder: SwiperCustomPagination(builder:
                                            (BuildContext context,
                                                SwiperPluginConfig config) {
                                          return Align(
                                            alignment: Alignment.bottomCenter,
                                            child: RectSwiperPaginationBuilder(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              activeColor: Colors.white,
                                              size: Size(5.0, 5.0),
                                              activeSize: Size(20.0, 5.0),
                                            ).build(context, config),
                                          );
                                        })),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }
                        }),
                        SizedBox(
                          height: 15,
                        ),

                        ///** CATEGORY

                        Obx(() {
                          if (!_homeController.isHomePageLoading.value) {
                            if (_homeController.homePageModel.value
                                .topCategories?.isEmpty ??
                                false) {
                              return SizedBox();
                            }
                            return ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                HomeTitlesWidget(
                                  title: 'Categories'.tr,
                                  btnOnTap: () {
                                    Get.to(() => AllCategorySubCategory());
                                  },
                                  showDeal: false,
                                ),
                                Container(
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 10,
                                      height: 100,
                                    ),
                                    itemCount: _homeController.homePageModel
                                        .value.topCategories!.length,
                                    itemBuilder: (context, index) {
                                      CategoryBrand category = _homeController
                                          .homePageModel
                                          .value
                                          .topCategories![index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            customBorder: CircleBorder(),
                                            onTap: () async {
                                              _homeController.categoryId.value =
                                                  category.id!;
                                              _homeController
                                                  .categoryIdBeforeFilter
                                                  .value = category.id!;
                                              _homeController.allProds.clear();
                                              _homeController.subCats.clear();
                                              _homeController.lastPage.value =
                                                  false;
                                              _homeController.pageNumber.value =
                                                  1;
                                              _homeController.category.value =
                                                  CategoryData();
                                              _homeController.catAllData.value =
                                                  SingleCategory();
                                              // controller.dataFilter.value =
                                              //     FilterFromCatModel();
                                              _homeController
                                                  .getCategoryProducts();
                                              _homeController
                                                  .getCategoryFilterData();
                                              if (_homeController
                                                      .dataFilterCat
                                                      .value
                                                      .filterDataFromCat !=
                                                  null) {
                                                _homeController
                                                    .dataFilterCat
                                                    .value
                                                    .filterDataFromCat!
                                                    .filterType!
                                                    .forEach((element) {
                                                  if (element.filterTypeId ==
                                                          'brand' ||
                                                      element.filterTypeId ==
                                                          'cat') {
                                                    print(element.filterTypeId);
                                                    element.filterTypeValue!
                                                        .clear();
                                                  }
                                                });
                                              }
                                              _homeController
                                                  .filterRating.value = 0.0;
                                              Get.to(() => ProductsByCategory(
                                                    categoryId: category.id!,
                                                  ));
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                gradient: selectColor(index),
                                                shape: BoxShape.circle,
                                              ),
                                              child: category.icon != null
                                                  ? Icon(
                                                      FaCustomIcon
                                                          .getFontAwesomeIcon(
                                                              category.icon!),
                                                      color: Colors.white,
                                                    )
                                                  : Icon(
                                                      Icons.list_alt_outlined,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5.0,
                                              ),
                                              child: Text(
                                                category.name!,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style:
                                                    AppStyles.appFont.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  mainAxisExtent: 80,
                                ),
                                itemCount: 8,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: LoadingSkeleton(
                                        height: 80,
                                        width: 40,
                                        colors: [
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.2),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        // ** NEW USER ZONE
                        Obx(() {
                          if (_homeController.isHomePageLoading.value) {
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  clipBehavior: Clip.antiAlias,
                                  child: Container(
                                    height: 80,
                                    alignment: Alignment.center,
                                    color: AppStyles.pinkColor,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: Image.asset(
                                            'assets/images/icon_gift_alt.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'New Users Zone!'.tr,
                                              style: AppStyles.kFontWhite14w5
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              '',
                                              maxLines: 1,
                                              style: AppStyles.kFontWhite14w5
                                                  .copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 35,
                                          width: 35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                            color: AppStyles.pinkColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  child: Container(
                                    height: 150,
                                    padding: EdgeInsets.all(4),
                                    color: AppStyles.lightBlueColorAlt,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: List.generate(2, (index) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 4,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          LoadingSkeleton(
                                                            height: 70,
                                                            width: 80,
                                                            colors: [
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.1),
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.2),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          LoadingSkeleton(
                                                            height: 20,
                                                            width: 80,
                                                            colors: [
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.1),
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.2),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: Container(
                                            width: Get.width * 0.35,
                                            decoration: BoxDecoration(
                                              color: AppStyles.pinkColor,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Discount'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: AppStyles
                                                      .kFontWhite14w5
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        NewUserZonePage());
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 30,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffFFD600),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    25))),
                                                    child: Text(
                                                      'Shop Now'.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyles.appFont
                                                          .copyWith(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            );
                          } else {
                            if (_homeController
                                .homePageModel.value.newUserZone ==
                                null ||
                                (_homeController.homePageModel.value.newUserZone
                                    ?.allProducts?.isEmpty ??
                                    false)){return SizedBox();} else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => NewUserZonePage());
                                    },
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      clipBehavior: Clip.antiAlias,
                                      child: Container(
                                        height: 80,
                                        alignment: Alignment.center,
                                        color: AppStyles.pinkColor,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: Image.asset(
                                                'assets/images/icon_gift_alt.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'New Users Zone!'.tr,
                                                  style: AppStyles
                                                      .kFontWhite14w5
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                Text(
                                                  '${_homeController.homePageModel.value.newUserZone!.title ?? ""}',
                                                  maxLines: 1,
                                                  style: AppStyles
                                                      .kFontWhite14w5
                                                      .copyWith(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Container(
                                              height: 35,
                                              width: 35,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 14,
                                                color: AppStyles.pinkColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    child: Container(
                                      height: 150,
                                      padding: EdgeInsets.all(4),
                                      color: AppStyles.lightBlueColorAlt,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: List.generate(
                                                  _homeController
                                                      .homePageModel
                                                      .value
                                                      .newUserZone!
                                                      .allProducts!
                                                      .length, (index) {
                                                return Expanded(
                                                  child: GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () async {
                                                      final ProductDetailsController
                                                          productDetailsController =
                                                          Get.put(
                                                              ProductDetailsController());
                                                      await productDetailsController
                                                          .getProductDetails2(
                                                              _homeController
                                                                  .homePageModel
                                                                  .value
                                                                  .newUserZone!
                                                                  .allProducts![
                                                                      index]
                                                                  .product!
                                                                  .id);
                                                      Get.to(() => ProductDetails(
                                                          productID:
                                                              _homeController
                                                                  .homePageModel
                                                                  .value
                                                                  .newUserZone!
                                                                  .allProducts![
                                                                      index]
                                                                  .product!
                                                                  .id));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 4,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    FancyShimmerImage(
                                                                  imageUrl:
                                                                      '${AppConfig.assetPath}/${_homeController.homePageModel.value.newUserZone!.allProducts![index].product!.product!.thumbnailImageSource}',
                                                                  boxFit: BoxFit
                                                                      .contain,
                                                                  errorWidget:
                                                                      FancyShimmerImage(
                                                                    imageUrl:
                                                                        "${AppConfig.assetPath}/backend/img/default.png",
                                                                    boxFit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Wrap(
                                                                  crossAxisAlignment:
                                                                      WrapCrossAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      currencyController.calculatePrice(_homeController.homePageModel.value.newUserZone!.allProducts![index].product!)! + currencyController.appCurrency.value,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: AppStyles
                                                                          .kFontPink15w5
                                                                          .copyWith(
                                                                              fontSize: 12),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Text(
                                                                      currencyController.calculateMainPrice(_homeController.homePageModel.value.newUserZone!.allProducts![index].product!),
                                                                      style: AppStyles
                                                                          .kFontGrey12w5
                                                                          .copyWith(
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                Get.to(() => NewUserZonePage());
                                              },
                                              child: Container(
                                                width: Get.width * 0.35,
                                                decoration: BoxDecoration(
                                                  color: AppStyles.pinkColor,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${_homeController.homePageModel.value.newUserZone!.coupon!.discount}% ' +
                                                          'OFF'.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyles
                                                          .kFontWhite14w5
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${_homeController.homePageModel.value.newUserZone!.coupon!.title}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyles.appFont
                                                          .copyWith(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            NewUserZonePage());
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 30,
                                                        width: 80,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffFFD600),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            25))),
                                                        child: Text(
                                                          'Shop Now'.tr,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: AppStyles
                                                              .appFont
                                                              .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            }
                          }
                        }),
                        // ** FLASH SALE
                        Obx(() {
                          if (_homeController.isHomePageLoading.value) {
                            return SizedBox();
                          } else {
                            if (_homeController.hasDeal.value) {
                              if(_homeController.homePageModel.value.flashDeal?.allProducts?.isEmpty ?? true) {
                                return SizedBox();
                              }
                              return ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  HomeTitlesWidget(
                                    title: '${_homeController.dealsText.value}',
                                    btnOnTap: () async {
                                      _homeController.flashProductData.clear();
                                      _homeController.flashPageNumber.value = 1;
                                      _homeController.lastFlashDealPage.value =
                                          false;
                                      await _homeController.getFlashDealsData();
                                      Get.to(() => FlashDealView());
                                    },
                                    dealDuration:
                                        _homeController.dealDuration.value,
                                    showDeal: true,
                                  ),
                                  Container(
                                    height: 160,
                                    child: ListView.separated(
                                        itemCount: _homeController.homePageModel
                                            .value.flashDeal!.allProducts!.length,
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width: 5,
                                          );
                                        },
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, flashIndex) {
                                          FlashDealAllProduct flashDeal =
                                              _homeController
                                                  .homePageModel
                                                  .value
                                                  .flashDeal!
                                                  .allProducts![flashIndex];
                                          return InkWell(
                                            onTap: () {
                                              Get.to(() => ProductDetails(
                                                    productID:
                                                        flashDeal.product!.id,
                                                  ));
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: Container(
                                                width: 105,
                                                color: Colors.white,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        child: Container(
                                                          height: 90,
                                                          child: Stack(
                                                            fit:
                                                                StackFit.expand,
                                                            children: [
                                                              FancyShimmerImage(
                                                                imageUrl:
                                                                    "${AppConfig.assetPath}/${flashDeal.product!.product!.thumbnailImageSource}",
                                                                boxFit: BoxFit
                                                                    .contain,
                                                                errorWidget:
                                                                    FancyShimmerImage(
                                                                  imageUrl:
                                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                                  boxFit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                              flashDeal.product!
                                                                          .productType ==
                                                                      ProductType
                                                                          .GIFT_CARD
                                                                  ? Positioned(
                                                                      top: 0,
                                                                      right: 0,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child: flashDeal.product!.giftCardEndDate!.compareTo(DateTime.now()) >
                                                                                0
                                                                            ? Container(
                                                                                padding: EdgeInsets.all(4),
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(
                                                                                  color: AppStyles.pinkColor,
                                                                                ),
                                                                                child: Text(
                                                                                  flashDeal.product!.discountType == "0" || flashDeal.product!.discountType == 0 ? '-${flashDeal.product!.discount.toString()}% ' : '${(flashDeal.product!.discount! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value} ',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: AppStyles.appFont.copyWith(
                                                                                    color: Colors.white,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : SizedBox.shrink(),
                                                                      ),
                                                                    )
                                                                  : Positioned(
                                                                      top: 0,
                                                                      right: 0,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child: flashDeal.product!.hasDeal !=
                                                                                null
                                                                            ? flashDeal.product!.hasDeal!.discount! > 0
                                                                                ? Container(
                                                                                    padding: EdgeInsets.all(4),
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(
                                                                                      color: AppStyles.pinkColor,
                                                                                    ),
                                                                                    child: Text(
                                                                                      flashDeal.product!.hasDeal!.discountType == 0 ? '${flashDeal.product!.hasDeal!.discount.toString()}% ' : '${(flashDeal.product!.hasDeal!.discount! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value} ',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: AppStyles.appFont.copyWith(
                                                                                        color: Colors.white,
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : Container()
                                                                            : flashDeal.product!.discountStartDate != null && currencyController.endDate.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch
                                                                                ? Container()
                                                                                : flashDeal.product!.discount! > 0
                                                                                    ? Container(
                                                                                        padding: EdgeInsets.all(4),
                                                                                        alignment: Alignment.center,
                                                                                        decoration: BoxDecoration(
                                                                                          color: AppStyles.pinkColor,
                                                                                        ),
                                                                                        child: Text(
                                                                                          flashDeal.product!.discountType == "0" ? '-${flashDeal.product!.discount.toString()}% ' : '${(flashDeal.product!.discount! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value} ',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: AppStyles.appFont.copyWith(
                                                                                            color: Colors.white,
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight.w500,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    : Container(),
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      height: 18,
                                                      child: Stack(
                                                        fit: StackFit.loose,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        children: [
                                                          Container(
                                                            width: double
                                                                .maxFinite,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4),
                                                            child: flashDeal
                                                                        .product!
                                                                        .totalSale !=
                                                                    null
                                                                ? Text(
                                                                    ' ${flashDeal.product!.totalSale} ' +
                                                                        'Sold'
                                                                            .tr,
                                                                    style: flashDeal.product!.totalSale! >
                                                                            80
                                                                        ? AppStyles
                                                                            .appFont
                                                                            .copyWith(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white,
                                                                          )
                                                                        : AppStyles
                                                                            .appFont
                                                                            .copyWith(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                  )
                                                                : Text(
                                                                    ' ${flashDeal.product!.totalSale} ' +
                                                                        'Sold'
                                                                            .tr,
                                                                    style: AppStyles
                                                                        .appFont
                                                                        .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 6),
                                                      child: Wrap(
                                                        children: [
                                                          Text(
                                                            '${currencyController.calculatePrice(flashDeal.product!)}${currencyController.appCurrency.value}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: AppStyles
                                                                .appFont
                                                                .copyWith(
                                                              fontSize: 12,
                                                              color: AppStyles
                                                                  .pinkColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          flashDeal.product!
                                                                      .hasDeal !=
                                                                  null
                                                              ? flashDeal
                                                                          .product!
                                                                          .hasDeal!
                                                                          .discount! >
                                                                      0
                                                                  ? Text(
                                                                      currencyController
                                                                          .calculateMainPrice(
                                                                              flashDeal.product!),
                                                                      style: AppStyles
                                                                          .appFont
                                                                          .copyWith(
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
                                                                        color: AppStyles
                                                                            .greyColorDark,
                                                                      ),
                                                                    )
                                                                  : Container()
                                                              : Text(
                                                                  currencyController
                                                                      .calculateMainPrice(
                                                                          flashDeal
                                                                              .product!),
                                                                  style: AppStyles
                                                                      .kFontGrey12w5
                                                                      .copyWith(
                                                                          decoration:
                                                                              TextDecoration.lineThrough),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }
                        }),

                        //** BRANDS

                        Obx(() {
                          if (_homeController.isHomePageLoading.value) {
                            return ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                HomeTitlesWidget(
                                  title: 'Brands'.tr,
                                  btnOnTap: () {
                                    Get.to(() => AllBrandsPage());
                                  },
                                  showDeal: false,
                                ),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    color: AppStyles.lightBlueColorAlt,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        child: GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            mainAxisSpacing: 10.0,
                                            crossAxisSpacing: 10.0,
                                            mainAxisExtent: 90,
                                          ),
                                          itemCount: 8,
                                          itemBuilder: (context, index) {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: LoadingSkeleton(
                                                width: 50,
                                                height: 40,
                                                colors: [
                                                  Colors.black.withOpacity(0.1),
                                                  Colors.black.withOpacity(0.2),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                HomeTitlesWidget(
                                  title: 'Brands'.tr,
                                  btnOnTap: () {
                                    Get.to(() => AllBrandsPage());
                                  },
                                  showDeal: false,
                                ),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    color: AppStyles.lightBlueColorAlt,
                                    child: Container(
                                      height:
                                          _homeController.chunkedBrands.length >
                                                  4
                                              ? 230
                                              : 130,
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        child: Swiper.children(
                                          children: _homeController
                                              .chunkedBrands
                                              .chunked(8)
                                              .map((e) {
                                            return GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                mainAxisSpacing: 10.0,
                                                crossAxisSpacing: 10.0,
                                                mainAxisExtent: 90,
                                              ),
                                              itemBuilder: (context, index) {
                                                CategoryBrand brand = e[index];
                                                return InkWell(
                                                  onTap: () {
                                                    _homeController.brandId
                                                        .value = brand.id!;
                                                    _homeController
                                                        .allBrandProducts
                                                        .clear();
                                                    _homeController
                                                        .subCatsInBrands
                                                        .clear();
                                                    _homeController
                                                        .lastBrandPage
                                                        .value = false;
                                                    _homeController
                                                        .brandPageNumber
                                                        .value = 1;
                                                    _homeController
                                                        .getBrandProducts();
                                                    _homeController
                                                        .getBrandFilterData();

                                                    if (_homeController
                                                            .dataFilterCat
                                                            .value
                                                            .filterDataFromCat !=
                                                        null) {
                                                      _homeController
                                                          .dataFilterCat
                                                          .value
                                                          .filterDataFromCat!
                                                          .filterType!
                                                          .forEach((element) {
                                                        if (element.filterTypeId ==
                                                                'brand' ||
                                                            element.filterTypeId ==
                                                                'cat') {
                                                          print(element
                                                              .filterTypeId);
                                                          element
                                                              .filterTypeValue!
                                                              .clear();
                                                        }
                                                      });
                                                    }
                                                    Get.to(
                                                        () => ProductsByBrands(
                                                              brandId: brand.id!,
                                                            ));
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: brand.logo !=
                                                                      null
                                                                  ? Container(
                                                                      child:
                                                                          FancyShimmerImage(
                                                                        imageUrl:
                                                                            AppConfig.assetPath + '/' + brand.logo!,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        errorWidget:
                                                                            FancyShimmerImage(
                                                                          imageUrl:
                                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                                          boxFit:
                                                                              BoxFit.contain,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      child: Icon(
                                                                          Icons
                                                                              .list_alt)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                vertical: brand
                                                                            .name!
                                                                            .length <
                                                                        10
                                                                    ? 1.0
                                                                    : 0.0,
                                                                horizontal: 4),
                                                            child: Text(
                                                              brand.name!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: AppStyles
                                                                  .appFont
                                                                  .copyWith(
                                                                fontSize: 12,
                                                                color: AppStyles
                                                                    .blackColor,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: e.length,
                                            );
                                          }).toList(),
                                          loop: false,
                                          pagination: SwiperPagination(
                                              margin: EdgeInsets.zero,
                                              builder: SwiperCustomPagination(
                                                  builder:
                                                      (BuildContext context,
                                                          SwiperPluginConfig
                                                              config) {
                                                return Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child:
                                                      RectSwiperPaginationBuilder(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    activeColor: Colors.pink,
                                                    size: Size(5.0, 5.0),
                                                    activeSize: Size(20.0, 5.0),
                                                  ).build(context, config),
                                                );
                                              })),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }),

                        ///** TOP PICKS
                        Obx(() {
                          if (_homeController.isHomePageLoading.value) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  child: Container(
                                    child: LoadingSkeleton(
                                      height: 150,
                                      width: Get.width,
                                      colors: [
                                        Colors.black.withOpacity(0.1),
                                        Colors.black.withOpacity(0.2),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                HomeTitlesWidget(
                                  title: 'Top Picks'.tr,
                                  btnOnTap: () {
                                    Get.to(() => AllTopPickProducts());
                                  },
                                  showDeal: false,
                                ),
                                Container(
                                  height: 220,
                                  child: ListView.separated(
                                      itemCount: _homeController
                                          .homePageModel.value.topPicks!
                                          .take(8)
                                          .length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          width: 10,
                                        );
                                      },
                                      itemBuilder: (context, topPickIndex) {
                                        ProductModel prod = _homeController
                                            .homePageModel
                                            .value
                                            .topPicks![topPickIndex];

                                        return HorizontalProductWidget(
                                          productModel: prod,
                                        );
                                      }),
                                ),
                              ],
                            );
                          }
                        }),
                      ],
                    ),
                  ),

                  //** RECOMMENDED

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
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      indicatorBuilder: BuildIndicatorBuilder(
                        source: source,
                        isSliver: true,
                        name: 'Recommended Products'.tr,
                      ).buildIndicator,
                      extendedListDelegate:
                          SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder:
                          (BuildContext c, ProductModel prod, int index) {
                        return GridViewProductWidget(
                          productModel: prod,
                        );
                      },
                      sourceList: source!,
                    ),
                    key: const Key('homePageLoadMoreKey'),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
