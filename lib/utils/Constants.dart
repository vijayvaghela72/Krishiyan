String localLang = "en";
int selectedIndex = 1;

const String prefKeyUserModel = 'prefUserModel';
const String isLogin = 'isLogin';
const String name = 'name';
const String email = 'email';
const String contactNo = 'contactNumber';
const String id = 'id';
// const String dealerNumber = '1';
const String farmerName = 'farmerName';
const String typeOfOrganization = 'typeOfOrganization';
const String dateOfOrganization = 'dateOfOrganization';
const String dateOfIncorporation = 'dateOfIncorporation';
const String typeOfEntity = 'typeOfEntity';
const String typeOfOrg = 'typeOfOrg';
const String token = 'token';

const String prefKeyToken = 'prefToken';
const String baseUrl = "https://krishiyanback.vercel.app/api/";

const String LOGIN = "${baseUrl}app/sign-in";
const String SIGNUP = "${baseUrl}fpo";

const String FARMER_NAME = "${baseUrl}appFarmer/names/";

const String CROP_LIST = "https://d1dv04h56lh39n.cloudfront.net/api/crop";
// const String CROP_LIST = "${baseUrl}crop";
// const String FARMER_DASHBOARD = "${baseUrl}api/appFarmer";
const String FARMER_DASHBOARD = "https://krishiyanback.vercel.app/api/appFarmer/data";

const String FRM_PROFILE_DETAILS = "https://krishiyanback.vercel.app/api/fpoOrganization/contact/";
const String FRM_UPDATE_PROFILE_DETAILS = "https://krishiyanback.vercel.app/api/fpoOrganization/contact/";

const String PROFILE_DETAILS = "https://krishiyanback.vercel.app/api/entity/contact/";
const String UPDATE_PROFILE_DETAILS = "https://krishiyanback.vercel.app/api/entity/contact/";

const String OTHER_DETAILS = "${baseUrl}otherDetails/";
const String UPDATE_OTHER_DETAILS = "${baseUrl}otherDetails";

const String BANK_DETAILS = "${baseUrl}bankDetails/";
const String UPDATE_BANK_DETAILS = "${baseUrl}bankDetails";

const String ADDRESS_DETAILS = "${baseUrl}address/";
const String UPDATE_ADDRESS_DETAILS = "${baseUrl}address";

const String RESET_PASSWORD = "${baseUrl}app/reset-password";

const String PincodeToState = "api/farmer/address";

const String MANDI_PRICE_STATE = "https://krishiyanback.vercel.app/api/mandi/filter";

const bool DEVELOPER_MODE = true;

const String NEWS_LIST = "https://krishiyanback.vercel.app/api/all/news";

const String ENQUIRY_LIST = "${baseUrl}commodities";
const String ENQUIRY_LIST_BY_ID = "${baseUrl}commodities/";

const String BUY_COMMODITY = "${baseUrl}commodity";
const String SELL_COMMODITY = "${baseUrl}commodity";

const String VILLAGES_NAMES = "${baseUrl}appFarmer/villages/";
const String CROPS_NAMES = "${baseUrl}all/crops";

const String FARMER_REGISTRATION = "${baseUrl}appFarmer/register";
const String FARMER_GROUP_REGISTRATION = "${baseUrl}sign-in";

const String CROP_CULTIVATION_REGISTR = "${baseUrl}appFarmer/crop/register";

const String GET_OTP = "https://krishiyanback.vercel.app/api/whatsapp/send-otp/";