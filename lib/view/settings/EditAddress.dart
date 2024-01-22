import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/model/NewModel/CityList.dart';
import 'package:amazcart/model/NewModel/CountryList.dart';
import 'package:amazcart/model/CustomerAddress.dart';
import 'package:amazcart/model/StateList.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/settings/widget/location_dropdown_tile.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../AppConfig/app_config.dart';

class EditAddress extends StatefulWidget {
  final Address address;

  EditAddress(this.address);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final AddressController addressController = Get.put(AddressController());
  bool defaultBilling = false;
  bool defaultShipping = false;

  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController postalCodeCtrl = TextEditingController();

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  // Future<CountryList> allCountry;
  String? selectedCountryName;
  int? selectedCountryId;

  // Future<StateList> allStates;
  String? selectedStateName;
  int? selectedStateId;

  // Future<CityList> allCities;
  String? selectedCityName;
  int? selectedCityId;

  @override
  void initState() {
    fullNameCtrl.text = widget.address.name ?? '';
    emailCtrl.text = widget.address.email ?? '';
    addressCtrl.text = widget.address.address ?? '';
    phoneCtrl.text = widget.address.phone ?? '';
    postalCodeCtrl.text = widget.address.postalCode ?? '';
    if (widget.address.isShippingDefault == 1) {
      defaultShipping = true;
    }
    if (widget.address.isBillingDefault == 1) {
      defaultBilling = true;
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Future<CountryList> getCountries() async {
    try {
      Uri myAddressUrl = Uri.parse(URLs.COUNTRY);
      var response = await http.get(
        myAddressUrl,
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return CountryList.fromJson(jsonString['countries']);
      } else {
        Get.snackbar(
          'Error'.tr,
          jsonString['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return CountryList();
      }
    } finally {}
  }

  Future<StateList> getStates(countryId) async {
    try {
      Uri myAddressUrl = Uri.parse(URLs.stateByCountry(countryId));
      var response = await http.get(
        myAddressUrl,
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return StateList.fromJson(jsonString['states']);
      } else {
        Get.snackbar(
          'Error'.tr,
          jsonString['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return StateList();
      }
    } finally {}
  }

  Future<CityList> getCities(stateId) async {
    try {
      Uri myAddressUrl = Uri.parse(URLs.cityByState(stateId));
      var response = await http.get(
        myAddressUrl,
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] == 'success') {
        return CityList.fromJson(jsonString['cities']);
      } else {
        return CityList();
      }
    } finally {}
  }

  CountryList? allCountryNew;
  StateList? allStatesNew;
  CityList? allCitiesNew;
  bool loadingAllCountries = true;
  bool loadingAllStates = true;
  bool loadingAllCities = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildDropDown();
  }

  _buildDropDown() async {
    allCountryNew = await getCountries();
    allCountryNew?.countries?.forEach((element) {
      if (element.id.toString() == widget.address.country) {
        selectedCountryName = element.name;
        selectedCountryId = element.id;
      }
    });

    setState(() {
      loadingAllCountries = false;
    });

    allStatesNew = await getStates(selectedCountryId);

    allStatesNew?.states?.forEach((stateElement) {
      if (stateElement.id.toString() == widget.address.state) {
        selectedStateName = stateElement.name;
        selectedStateId = stateElement.id;
      }
    });
    setState(() {
      loadingAllStates = false;
    });

    allCitiesNew = await getCities(selectedStateId);
    if (allCitiesNew != null) {
      setState(() {
        loadingAllCities = false;
      });
      allCitiesNew?.cities?.forEach((cityElement) {
        if (cityElement.id.toString() == widget.address.city) {
          selectedCityName = cityElement.name;
          selectedCityId = cityElement.id;
        }
      });
    }

    setState(() {
      loadingAllCities = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Edit Address'.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: fullNameCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Full Name'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Full Name'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please Type Full name'.tr;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Email'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Email'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please Type Email address'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),

                if (!loadingAllCountries)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Country'.tr,
                        style: AppStyles.kFontBlack14w5,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // getCountryDropDown(allCountryNew.countries),
                      LocationDropDownTile(
                        title: selectedCountryName ?? '',
                        image: allCountryNew
                            ?.countries?[allCountryNew?.countries?.indexWhere(
                                  (element) =>
                                      element.name == selectedCountryName,
                                ) ??
                                0]
                            .flag,
                        onTap: () {
                          Get.bottomSheet(
                            ListView.builder(
                              itemCount: allCountryNew?.countries?.length ?? 0,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                var value = allCountryNew?.countries?[index];
                                return ListTile(
                                  onTap: () {
                                    _selectCountry(
                                      countryCode: value?.id ?? 0,
                                      countryName: value?.name ?? '',
                                    );
                                    Get.back();
                                  },
                                  title: Text(value?.name ?? ''),
                                  leading: value?.flag == null
                                      ? const Icon(Icons.flag)
                                      : Image.network(
                                          '${AppConfig.assetPath}/${value?.flag}',
                                          width: 20,
                                          errorBuilder:
                                              (context, object, stackTrace) {
                                            return const Icon(Icons.flag);
                                          },
                                        ),
                                );
                              },
                            ),
                            backgroundColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Text(
                      //   'Select State'.tr,
                      //   style: AppStyles.kFontBlack14w5,
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // if (!loadingAllCountries &&
                      //     !loadingAllStates &&
                      //     allStatesNew != null &&
                      //     allStatesNew.states != null &&
                      //     allStatesNew.states.isNotEmpty)
                      //   getStatesDropDown(allStatesNew.states),
                      // if (loadingAllStates)
                      //   const Center(child: CupertinoActivityIndicator()),
                    ],
                  ),
                if (loadingAllCountries)
                  const Center(child: CupertinoActivityIndicator()),
                if (!loadingAllStates)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select State'.tr,
                        style: AppStyles.kFontBlack14w5,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // getCountryDropDown(allCountryNew.countries),

                      LocationDropDownTile(
                        title: selectedStateName ?? '',
                        onTap: () {
                          Get.bottomSheet(
                            ListView.builder(
                              itemCount: allStatesNew?.states?.length ?? 0,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                var value = allStatesNew?.states?[index];
                                return ListTile(
                                  onTap: () {
                                    _selectState(
                                      stateId: value?.id ?? 0,
                                      stateName: value?.name ?? '',
                                    );
                                    Get.back();
                                  },
                                  title: Text(value?.name ?? ''),
                                );
                              },
                            ),
                            backgroundColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Text(
                      //   'Select State'.tr,
                      //   style: AppStyles.kFontBlack14w5,
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // if (!loadingAllCountries &&
                      //     !loadingAllStates &&
                      //     allStatesNew != null &&
                      //     allStatesNew.states != null &&
                      //     allStatesNew.states.isNotEmpty)
                      //   getStatesDropDown(allStatesNew.states),
                      // if (loadingAllStates)
                      //   const Center(child: CupertinoActivityIndicator()),
                    ],
                  ),
                if (loadingAllStates)
                  const Center(child: CupertinoActivityIndicator()),
                if (!loadingAllCities && allCitiesNew?.cities != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select City'.tr,
                        style: AppStyles.kFontBlack14w5,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // getCountryDropDown(allCountryNew.countries),

                      LocationDropDownTile(
                        title: selectedCityName ?? '',
                        onTap: () {
                          Get.bottomSheet(
                            ListView.builder(
                              itemCount: allCitiesNew?.cities?.length ?? 0,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                var value = allCitiesNew?.cities?[index];
                                return ListTile(
                                  onTap: () {
                                    _selectCity(
                                      cityCode: value?.id ?? 0,
                                      cityName: value?.name ?? '',
                                    );
                                    Get.back();
                                  },
                                  title: Text(value?.name ?? ''),
                                );
                              },
                            ),
                            backgroundColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Text(
                      //   'Select State'.tr,
                      //   style: AppStyles.kFontBlack14w5,
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // if (!loadingAllCountries &&
                      //     !loadingAllStates &&
                      //     allStatesNew != null &&
                      //     allStatesNew.states != null &&
                      //     allStatesNew.states.isNotEmpty)
                      //   getStatesDropDown(allStatesNew.states),
                      // if (loadingAllStates)
                      //   const Center(child: CupertinoActivityIndicator()),
                    ],
                  ),
                if (loadingAllCities)
                  const Center(child: CupertinoActivityIndicator()),

                ///
                TextFormField(
                  controller: addressCtrl,
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Address'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Address'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please Type Address'.tr;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: postalCodeCtrl,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Postal/Zip Code'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Postal/Zip Code'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please Type Postal/Zip code'.tr;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Phone Number'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Phone Number'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please Type Phone number'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () async {
                print('delete');
                await deleteAddress().then((value) async {
                  if (value) {
                    SnackBars()
                        .snackBarSuccess('Address deleted successfully'.tr);
                    await addressController.getAllAddress().then((value) {
                      Future.delayed(const Duration(seconds: 4), () {
                        Get.back();
                      });
                    });
                  }
                });
              },
              child: Container(
                height: 20,
                child: Text(
                  'Delete this Address'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.pinkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ButtonWidget(
              buttonText: 'Save Change'.tr,
              onTap: () async {
                if (_formKey.currentState?.validate() ?? true) {
                  await editAddress().then((value) async {
                    if (value) {
                      SnackBars()
                          .snackBarSuccess('Address updated successfully'.tr);
                      await addressController.getAllAddress().then((value) {
                        Future.delayed(const Duration(seconds: 4), () {
                          Get.back();
                        });
                      });
                    }
                  });
                }
              },
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<bool> editAddress() async {
    String token = await userToken.read(tokenKey);
    Uri addressUrl = Uri.parse(URLs.editAddress(widget.address.id));
    print(addressUrl);
    Map data = {
      "name": fullNameCtrl.text,
      "email": emailCtrl.text,
      "address": addressCtrl.text,
      "phone": phoneCtrl.text,
      "city": selectedCityId,
      "state": selectedStateId,
      "country": selectedCountryId,
      "postal_code": postalCodeCtrl.text
    };
    var body = json.encode(data);
    print(body);
    var response = await http.post(addressUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 202) {
      return true;
    } else {
      if (response.statusCode == 401) {
        SnackBars()
            .snackBarWarning('Invalid Access token. Please re-login.'.tr);
        return false;
      } else {
        SnackBars().snackBarError(jsonString['message']);
        return false;
      }
    }
  }

  Future<bool> deleteAddress() async {
    String token = await userToken.read(tokenKey);
    Uri addressUrl = Uri.parse(URLs.DELETE_ADDRESS);
    print(addressUrl);
    Map data = {
      "id": widget.address.id,
    };
    var body = json.encode(data);
    var response = await http.post(addressUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 202) {
      return true;
    } else {
      if (response.statusCode == 401) {
        SnackBars()
            .snackBarWarning('Invalid Access token. Please re-login.'.tr);
        return false;
      } else {
        SnackBars().snackBarError(jsonString['message']);
        return false;
      }
    }
  }

  void _selectCountry({
    required int countryCode,
    required String countryName,
  }) async {
    setState(() {
      selectedCountryName = countryName;
      selectedCountryId = countryCode;
      loadingAllStates = true;
      loadingAllCities = true;
    });

    allStatesNew = await getStates(selectedCountryId);

    if (allStatesNew?.states != null) {
      selectedStateName = allStatesNew?.states?[0].name;
      selectedStateId = allStatesNew?.states?[0].id;
    }

    setState(() {
      loadingAllStates = false;
    });

    selectedCityName = '';
    allCitiesNew = await getCities(selectedStateId);
    setState(() {
      loadingAllCities = false;
    });
    if (allCitiesNew?.cities != null && allCitiesNew!.cities != null) {
      selectedCityName = allCitiesNew!.cities?[0].name;
      selectedCityId = allCitiesNew!.cities?[0].id;
    }
  }

  void _selectState({
    required int stateId,
    required String stateName,
  }) async {
    setState(() {
      selectedStateId = stateId;
      selectedStateName = stateName;
      loadingAllCities = true;
    });

    selectedCityName = '';
    allCitiesNew = await getCities(selectedStateId);
    setState(() {
      loadingAllCities = false;
    });
    if (allCitiesNew?.cities != null && allCitiesNew!.cities != null) {
      selectedCityName = allCitiesNew?.cities?[0].name;
      selectedCityId = allCitiesNew?.cities?[0].id;
    }
  }

  void _selectCity({required int cityCode, required String cityName}) {
    selectedCityName = cityName;
    selectedCityId = cityCode;

    setState(() {
      loadingAllCities = false;
    });
  }
}
