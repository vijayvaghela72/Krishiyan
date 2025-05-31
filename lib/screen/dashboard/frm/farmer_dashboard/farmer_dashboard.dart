import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:krishiyan/screen/dashboard/frm/frm.dart';
import '../../../../mvc/model/farmer_dashboard_model.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/mvc/controller/farmer_dashboard_controller.dart';
import 'package:krishiyan/screen/dashboard/frm/widget/crop_cultivation.dart';
import 'package:krishiyan/screen/dashboard/frm/widget/farmer_edit_profile.dart';
import 'package:krishiyan/screen/dashboard/frm/widget/edit_crop_cultivation.dart';

firstTabData(BuildContext context, Function update) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  buildTranslate("searchBy")!,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'poppins-regular'),
                ),
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      //To remove first '0'
                      FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                      //To remove first '94' or your country code
                      FilteringTextInputFormatter.deny(RegExp(r'^94+')),
                    ],
                    decoration: InputDecoration(
                      // alignLabelWithHint: true,
                      counterText: '',
                      // This hides the "1/10" counter label
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFd3d3d3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: buildTranslate('mobileNumberOrCrop'),
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please, fill this field.' : null,
                    controller: frmProvider!.searchByNaneController,
                    onChanged: (value) {
                      frmProvider!.searchText = value;
                      update();
                      if (frmProvider!.searchText.isNotEmpty) {
                        frmProvider!.futureFarmerProfiles =
                            FarmerDashboardController
                                .fetchSearchFarmerDashboard(
                                    context, frmProvider!.searchText);
                        update();
                      } else {
                        frmProvider!.futureFarmerProfiles =
                            FarmerDashboardController.fetchFarmerDashboard(
                                context,
                                frmProvider!.villageName,
                                frmProvider!.typeName);
                        update();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              buildTranslate("allFarmers")!,
              softWrap: true,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontFamily: 'poppins-semibold'),
            ),
            const Spacer(),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: const MyDrawer(),
                  ),
                );
              },
              child: Image.asset(
                'assets/images/filter.png',
              ),
            ),
          ],
        ),
      ),
      FutureBuilder<List<FarmerDetails>>(
        future: frmProvider!.futureFarmerProfiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('errror : ${snapshot.error}');
            print('Done chhe');
            return Center(child: Text(buildTranslate("noDataAvailable")!));
          } else if (snapshot.hasData) {
            List<FarmerDetails> farmers = snapshot.data!;

            return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final dealerNo = farmers[index].farmerDetails.dealerNumber;
                final Name = farmers[index].farmerDetails.name;
                final Address = farmers[index].farmerDetails.village;
                frmProvider!.WhatsappNumberData =
                    farmers[index].farmerDetails.whatsappNumber;
                final GeoLocationOwnedFarm =
                    farmers[index].farmerDetails.geoLocationOwnedFarm;
                final TotalOwnedFarm =
                    farmers[index].farmerDetails.totalOwnedFarm.toString();
                final TotalLeaseFarm =
                    farmers[index].farmerDetails.totalLeaseFarm.toString();
                final GeoLocationLeaseFarm =
                    farmers[index].farmerDetails.geoLocationLeaseFarm;
                final Pincode = farmers[index].farmerDetails.pincode;
                final State = farmers[index].farmerDetails.state;
                final Village = farmers[index].farmerDetails.village;
                final District = farmers[index].farmerDetails.district;
                final BankName = farmers[index].farmerDetails.bankName;
                final AccountName = farmers[index].farmerDetails.accountName;
                final AccountNumber =
                    farmers[index].farmerDetails.accountNumber;
                final IfscCode = farmers[index].farmerDetails.ifscCode;
                final PanNumber = farmers[index].farmerDetails.pan;
                final AadhaarNumber =
                    farmers[index].farmerDetails.aadhaarNumber;
                final TypeOfCultivationPractice =
                    farmers[index].farmerDetails.typeOfCultivationPractice;

                final cropDetails = farmers[index].cropCultivationDetails;
                return Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFe7e7e7),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 15, left: 15),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/profile_image.png"),
                                        fit: BoxFit.cover)),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Name,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Color(0xFF808080),
                                          fontSize: 15,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    Text(
                                      Address,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Color(0xFF959595),
                                          fontSize: 11,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    Text(
                                      frmProvider!.WhatsappNumberData,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Color(0xFF959595),
                                          fontSize: 11,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  if (frmProvider!.showCropDataVisible ==
                                      index) {
                                    frmProvider!.showCropDataVisible =
                                        null; // Deselect if tapped again
                                  } else {
                                    frmProvider!.showCropDataVisible =
                                        index; // Select the item
                                  }
                                  update();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      buildTranslate("showCropData")!,
                                      softWrap: true,
                                      style: const TextStyle(
                                        color: Color(0XFF008000),
                                        fontSize: 15,
                                        fontFamily: 'poppins-semibold',
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0XFF008000),
                                      ),
                                    ),
                                    Image.asset(
                                        'assets/images/dropdown_arrow.png'),
                                  ],
                                ),
                              )),
                              const VerticalDivider(width: 1),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () async {
                                    print("Name : $Name");
                                    print(
                                        "WhatsappNumber : ${frmProvider!.WhatsappNumberData}");
                                    print("dealerNo : $dealerNo");
                                    // Navigate to ScreenB and wait for result
                                    final result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FarmerEditProfilePage(
                                          dealerNumber: dealerNo,
                                          name: Name,
                                          whatsappNumber:
                                              frmProvider!.WhatsappNumberData,
                                          address: Address,
                                          geoLocationOwnedFarm:
                                              GeoLocationOwnedFarm,
                                          totalOwnedFarm: TotalOwnedFarm,
                                          totalLeaseFarm: TotalLeaseFarm,
                                          geoLocationLeaseFarm:
                                              GeoLocationLeaseFarm,
                                          pincode: Pincode,
                                          state: State,
                                          district: District,
                                          village: Village,
                                          bankName: BankName,
                                          accountName: AccountName,
                                          accountNumber: AccountNumber,
                                          ifscCode: IfscCode,
                                          panNumber: PanNumber,
                                          aadhaarNumber: AadhaarNumber,
                                          typeOfCultivationPractice:
                                              TypeOfCultivationPractice,
                                        ),
                                      ),
                                    );
                                    // When ScreenB is popped, update data with result
                                    if (result != null) {
                                      frmProvider!.futureFarmerProfiles =
                                          FarmerDashboardController
                                              .fetchFarmerDashboard(
                                                  context,
                                                  frmProvider!.villageName,
                                                  frmProvider!.typeName);
                                      update();
                                    }
                                  },
                                  child: Text(
                                    buildTranslate("editProfile")!,
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Color(0XFF008000),
                                      fontSize: 15,
                                      fontFamily: 'poppins-semibold',
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0XFF008000),
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        frmProvider!.showCropDataVisible == index
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: Text(
                                  buildTranslate("cropCultivations")!,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'poppins-semibold',
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 10),
                        frmProvider!.showCropDataVisible == index
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, cropIndex) {
                                  if (cropDetails is List<CropDetails>) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: cropDetails.map(
                                        (crop) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5,
                                              left: 20,
                                              right: 20,
                                              bottom: 12,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          "${crop.crops}",
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF666666),
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'poppins-semibold',
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          crop.typeOfCultivationPractice,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF666666),
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'poppins-semibold',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditCropCultivationPage(
                                                              WhatsappNumber:
                                                                  frmProvider!
                                                                      .WhatsappNumberData,
                                                              selectedCrop:
                                                                  crop.crops,
                                                              id: crop.id,
                                                              variety:
                                                                  crop.variety,
                                                              date: crop
                                                                  .dateOfSowing,
                                                              geoLocation: crop
                                                                  .geolocation,
                                                              cultivationType: crop
                                                                  .typeOfCultivationPractice,
                                                              areaInArce: crop
                                                                  .areaInAcres
                                                                  .toString(),
                                                              geoLinkArea: crop
                                                                  .geoLinkAreaOnMap,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        buildTranslate(
                                                            "editCropData")!,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0XFF008000),
                                                          fontSize: 11,
                                                          fontFamily:
                                                              'poppins-semibold',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    );
                                  } else {
                                    return Text(
                                      cropDetails,
                                      softWrap: true,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontFamily: "poppins-semibold",
                                      ),
                                    );
                                  }
                                })
                            : Container(),
                        frmProvider!.showCropDataVisible == index
                            ? SizedBox(height: 5)
                            : Container(),
                        frmProvider!.showCropDataVisible == index
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  left: 10,
                                  right: 10,
                                  bottom: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color(0XFF3FC041),
                                              border: Border.all(
                                                  color:
                                                      const Color(0XFF3FC041),
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(18)),
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            buildTranslate("showMoreCrops")!,
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'poppins-regular'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CropCultivationPage(
                                                  WhatsappNumber: frmProvider!
                                                      .WhatsappNumberData,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color(0XFF3FC041),
                                                border: Border.all(
                                                    color:
                                                        const Color(0XFF3FC041),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(18)),
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              buildTranslate(
                                                  "addNewCultivations")!,
                                              softWrap: true,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontFamily: 'poppins-regular',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                buildTranslate("noDataAvailable")!,
              ),
            );
          }
        },
      ),
      const SizedBox(
        height: 30,
      ),
    ],
  );
}
