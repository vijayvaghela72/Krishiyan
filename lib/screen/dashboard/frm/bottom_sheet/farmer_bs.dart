import 'package:flutter/material.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/helper/btm_sheet_helper.dart';
import 'package:krishiyan/localization/app_localizations.dart';

selectFarmer(
  BuildContext context,
  Function setState,
) {
  TextEditingController searchValue = TextEditingController();
  showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                getCommanButtomTitleHeading(
                    buildTranslate("selectFarmer")!, context),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.065,
                    decoration: BoxDecoration(
                        color: Color(0xffefeeee),
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsetsDirectional.only(bottom: 20),
                    child: TextFormField(
                      controller: searchValue,
                      onTap: () {},
                      onChanged: (value) {
                        setStater(() {});
                      },
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                frmProvider!.dropdownItems.isNotEmpty
                    ? Flexible(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: getList(
                                setState,
                                context,
                                searchValue.text.toLowerCase(),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text("No Farmer Found...!"),
                      ),
              ],
            ),
          );
        },
      );
    },
  );
}

getList(
  Function setState,
  BuildContext context,
  String searchValue,
) {
  return frmProvider!.dropdownItems
      .asMap()
      .map(
        (index, element) => MapEntry(
          index,
          frmProvider!.dropdownItems[index].toLowerCase().contains(
                    searchValue,
                  )
              ? InkWell(
                  onTap: () async {
                    frmProvider!.selectedFarmersName =
                        frmProvider!.dropdownItems[index];
                    Navigator.pop(context);
                    setState();
                  },
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "${frmProvider!.dropdownItems[index]}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      )
      .values
      .toList();
}
