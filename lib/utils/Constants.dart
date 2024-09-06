String localLang = "en";
int selectedIndex = 1;

const String prefKeyUserModel = 'prefUserModel';
const String isLogin = 'isLogin';
const String name = 'name';
const String email = 'email';
const String contactNumber = 'contactNumber';
const String id = 'id';
const String dealerNumber = '1';
const String farmerName = 'farmerName';
const String typeOfOrganization = 'typeOfOrganization';
const String dateOfOrganization = 'dateOfOrganization';
const String typeOfOrg = 'typeOfOrg';
const String token = 'token';

const String prefKeyToken = 'prefToken';
const String baseUrl = "https://d1dv04h56lh39n.cloudfront.net/";

const String LOGIN = "${baseUrl}api/sign-in";
const String SIGNUP = "${baseUrl}api/fpo";

const String FARMER_NAME = "${baseUrl}api/appFarmer/names/";

const String CROP_LIST = "${baseUrl}api/crop";
// const String FARMER_DASHBOARD = "${baseUrl}api/appFarmer";
const String FARMER_DASHBOARD = "https://krishiyanback.vercel.app/api/appFarmer/data";

const String FRM_PROFILE_DETAILS = "https://krishiyanback.vercel.app/api/fpoOrganization/contact/";
const String FRM_UPDATE_PROFILE_DETAILS = "https://krishiyanback.vercel.app/api/fpoOrganization/contact/";

const String PROFILE_DETAILS = "${baseUrl}api/fpoOrganization/";
const String UPDATE_PROFILE_DETAILS = "${baseUrl}api/fpoOrganization";

const String OTHER_DETAILS = "${baseUrl}api/otherDetails/";
const String UPDATE_OTHER_DETAILS = "${baseUrl}api/otherDetails";

const String BANK_DETAILS = "${baseUrl}api/bankDetails/";
const String UPDATE_BANK_DETAILS = "${baseUrl}api/bankDetails";

const String ADDRESS_DETAILS = "${baseUrl}api/address/";
const String UPDATE_ADDRESS_DETAILS = "${baseUrl}api/address";

const String RESET_PASSWORD = "${baseUrl}api/app/reset-password";

const String PincodeToState = "api/farmer/address";
const bool DEVELOPER_MODE = true;

const String NEWS_LIST = "https://krishiyanback.vercel.app/api/all/news";

const String ENQUIRY_LIST = "${baseUrl}api/commodities";
const String ENQUIRY_LIST_BY_ID = "${baseUrl}api/commodities/";

const String BUY_COMMODITY = "${baseUrl}api/commodity";
const String SELL_COMMODITY = "${baseUrl}api/commodity";

const String VILLAGES_NAMES = "${baseUrl}api/appFarmer/villages/1";
const String CROPS_NAMES = "${baseUrl}api/crops";

const String FARMER_REGISTRATION = "${baseUrl}api/appFarmer/register";
const String FARMER_GROUP_REGISTRATION = "${baseUrl}api/sign-in";

const String CROP_CULTIVATION_REGISTR = "${baseUrl}api/appFarmer/crop/register";

// const String GET_FARMER_BY_VILLAGE_FILTER = "${baseUrl}api/appFarmer/data/1";
// const String SEARCH_NUMBER_INSIGHT = "${baseUrl}api/appFarmer/farmer/search?";