import 'package:country_picker/country_picker.dart';

/// App Name
const APP_NAME = "SocialV";

/// App Icon src
const APP_ICON = "assets/demo/app_icon.png";

/// Splash screen image src
// const SPLASH_SCREEN_IMAGE = 'assets/demo/images/splash_image.png';
const SPLASH_SCREEN_IMAGE = 'assets/images/splash_image.png';
/// OneSignal Notification App Id
const ONESIGNAL_APP_ID = 'c509290f-2190-4764-86fb-b3cc8a247bc5';


const WEB_SOCKET_URL = "wss://realtime-cloud.bpbettermessages.com/socket.io/?EIO=4&transport=websocket";

/// NOTE: Do not add slash (/) or (https://) or (http://) at the end of your domain.
const WEB_SOCKET_DOMAIN = "https://intoonedweekly.com";

/// Todo: Remove Base URL
/// NOTE: Do not add slash (/) at the end of your domain.
const DOMAIN_URL = 'https://intoonedweekly.com';

const BASE_URL = '$DOMAIN_URL/wp-json/';

/// AppStore Url
// const IOS_APP_LINK = 'https://apps.apple.com/us/app/socialv/id1641646237';

const IOS_APP_LINK = '#';
/// Terms and Conditions URL
const TERMS_AND_CONDITIONS_URL = '$DOMAIN_URL/terms-condition/';



const PRIVACY_POLICY_URL = '$DOMAIN_URL/privacy-policy-2/';

/// Support URL
const SUPPORT_URL = '$DOMAIN_URL/support';
/// Privacy Policy URL
// const PRIVACY_POLICY_URL = '$DOMAIN_URL/privacy-policy-2/';

// /// Support URL
// const SUPPORT_URL = 'https://iqonic.desky.support';

/// AdMod Id
// Android
const mAdMobAppId = '';
const mAdMobBannerId = '';




// const mTestAdMobBannerId = 'ca-app-pub-3940256099942544/6300934111';

// /// Woo Commerce keys

// // live
// const CONSUMER_KEY = 'ck_c05d1cba27844a5ca0af8a27e460fbce4c811bf0';
// const CONSUMER_SECRET = 'cs_ac64eb5cb649397944a5943a399cbcb67898bcf4';

// iOS
const mAdMobAppIdIOS = '';
const mAdMobBannerIdIOS = '';

const mTestAdMobBannerId = 'ca-app-pub-3940256099942544/6300978111';

/// Woo Commerce keys

// live
const CONSUMER_KEY = '';
const CONSUMER_SECRET = '';

Country defaultCountry() {
  return Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 91,
    geographic: true,
    level: 1,
    name: 'US',
    example: '9123456789',
    displayName: 'Us (IN) [+91]',
    displayNameNoCountryCode: 'Us (IN)',
    e164Key: '91-IN-0',
    fullExampleWithPlusSign: '+919123456789',
  );
}






// const mTestAdMobBannerId = 'ca-app-pub-3940256099942544/6300934111';

// /// Woo Commerce keys

// // live
// const CONSUMER_KEY = 'ck_c05d1cba27844a5ca0af8a27e460fbce4c811bf0';
// const CONSUMER_SECRET = 'cs_ac64eb5cb649397944a5943a399cbcb67898bcf4';

