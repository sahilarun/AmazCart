import 'dart:convert';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/model/NewModel/CityList.dart';
import 'package:amazcart/model/NewModel/CountryList.dart';
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

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  bool _isLoading = false;

  final AddressController addressController = Get.put(AddressController());

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

  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController postalCodeCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<CountryList> getCountries() async {
    try {
      Uri myAddressUrl = Uri.parse(URLs.COUNTRY);
      debugPrint('My Country Address URL : $myAddressUrl');
      var response = await http.get(
        myAddressUrl,
      );
      var jsonString = jsonDecode(response.body);
      debugPrint("Country List: ${jsonString['countries']}");
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
      debugPrint('My State Address URL : $myAddressUrl');
      var response = await http.get(
        myAddressUrl,
      );
      var jsonString = jsonDecode(response.body);
      debugPrint("STATE List: ${jsonString['states']}");
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
      debugPrint('My City Address URL : $myAddressUrl');
      var response = await http.get(
        myAddressUrl,
      );
      var jsonString = jsonDecode(response.body);
      debugPrint("CITIES List: ${jsonString['cities']}");
      if (jsonString['message'] == 'success') {
        return CityList.fromJson(jsonString['cities']);
      } else {
        return CityList();
      }
    } finally {}
  }

  @override
  void initState() {
    _buildDropDown();

    super.initState();
  }

  CountryList? allCountryNew;
  StateList? allStatesNew;
  CityList? allCitiesNew;
  bool loadingAllCountries = true;
  bool loadingAllStates = true;
  bool loadingAllCities = true;

  _buildDropDown() async {
    try {
      allCountryNew = await getCountries();

      if (allCountryNew!.countries != null) {
        selectedCountryName = allCountryNew!.countries?[0].name;
        selectedCountryId = allCountryNew!.countries?[0].id;
      }

      setState(() {
        loadingAllCountries = false;
      });

      allStatesNew = await getStates(selectedCountryId);

      if (allStatesNew!.states != null) {
        selectedStateName = allStatesNew!.states?[0].name;
        selectedStateId = allStatesNew!.states?[0].id;
      }
      setState(() {
        loadingAllStates = false;
      });

      allCitiesNew = await getCities(selectedStateId); //
      if (allCountryNew!.countries != null) {
        selectedCityName = allCitiesNew!.cities?[0].name;
        selectedCityId = allCitiesNew!.cities?[0].id;
      }
      setState(() {
        loadingAllCities = false;
      });
    } catch (e, t) {
      debugPrint('come to here ---> some error!!!! 004');
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Add Address'.tr,
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
                const SizedBox(
                  height: 10,
                ),
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
                      color: AppStyles.blackColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value?.isEmpty??true) {
                      return 'Please Type Full Name'.tr;
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
                  height: 20,
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
                        title: selectedCountryName??'',
                        image: allCountryNew!.countries?[allCountryNew!.countries?.indexWhere(
                                (element) =>
                                    element.name == selectedCountryName) ?? 0]
                            .flag ?? '',
                        onTap: () {
                          Get.bottomSheet(
                            ListView.builder(
                              itemCount: allCountryNew!.countries?.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                var value = allCountryNew!.countries?[index];
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
                        title: selectedStateName??'',
                        onTap: () {
                          Get.bottomSheet(
                            ListView.builder(
                              itemCount: allStatesNew!.states?.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                var value = allStatesNew!.states?[index];
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
                if (!loadingAllCities && allCitiesNew!.cities != null)
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
                        title: selectedCityName??'',
                        onTap: () {
                          Get.bottomSheet(
                            ListView.builder(
                              itemCount: allCitiesNew!.cities?.length ?? 0,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                var value = allCitiesNew!.cities?[index];
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
                  height: 10,
                ),
                !_isLoading
                    ? ButtonWidget(
                        buttonText: 'Save Address'.tr,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await addAddress().then((value) async {
                              if (value) {
                                SnackBars().snackBarSuccess(
                                    'Address added successfully'.tr);
                                await addressController
                                    .getAllAddress()
                                    .then((value) {
                                  Future.delayed(const Duration(seconds: 4),
                                      () {
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
                      )
                    : const SizedBox(
                        height: 60,
                        child: CupertinoActivityIndicator(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> addAddress() async {
    setState(() {
      _isLoading = true;
    });
    String token = await userToken.read(tokenKey);
    Uri addressUrl = Uri.parse(URLs.ADD_ADDRESS);
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
    var response = await http.post(addressUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 201) {
      setState(() {
        _isLoading = false;
      });
      return true;
    } else {
      setState(() {
        _isLoading = false;
      });
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

    if (allStatesNew!.states != null) {
      selectedStateName = allStatesNew!.states?[0].name;
      selectedStateId = allStatesNew!.states?[0].id;
    }

    setState(() {
      loadingAllStates = false;
    });

    selectedCityName = '';
    allCitiesNew = await getCities(selectedStateId);
    setState(() {
      loadingAllCities = false;
    });
    if (allCitiesNew!.cities != null && allCitiesNew!.cities!.isNotEmpty) {
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
    if (allCitiesNew?.cities != null && allCitiesNew!.cities!.isNotEmpty) {
      selectedCityName = allCitiesNew!.cities?[0].name;
      selectedCityId = allCitiesNew!.cities?[0].id;
    }
  }

  void _selectCity({
    required int cityCode,
    required String cityName,
  }) {
    selectedCityName = cityName;
    selectedCityId = cityCode;

    setState(() {
      loadingAllCities = false;
    });
  }
}
