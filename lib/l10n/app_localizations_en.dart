// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  // --- Auth ---
  @override String get login => 'Sign In';
  @override String get email => 'Email';
  @override String get password => 'Password';
  @override String get reppassword => 'Repeat Password';
  @override String get register => 'Register';
  @override String get next => 'Next';
  @override String get restorePassword => 'Restore password';
  @override String get signInButton => 'Sign in';
  @override String get createAccount => 'Create account';
  @override String get authError => 'Authentication error!';
  @override String get featureInDevelopment => 'In development';
  @override String get passwordHint => 'Create a password (at least 8 characters)';
  @override String get passwordsMismatch => "Passwords don't match!";
  @override String get alreadyHaveAccount => 'Already have an account? Sign in';

  // --- Create user ---
  @override String get enterYourNickname => 'Enter your username';
  @override String get nickname => 'Username';
  @override String get birthDateOptional => 'Date of birth (optional)';
  @override String get notSpecified => 'Not specified';
  @override String get userNotAuthorized => 'User not authorized';
  @override String get pleaseEnterNickname => 'Please enter your username';

  // --- Profile ---
  @override String get profile => 'Profile';
  @override String get settings => 'Settings';
  @override String get language => 'Language';
  @override String get signOut => 'Sign out';
  @override String get birthDate => 'Date of birth';

  // --- Home ---
  @override String get home => 'Home';
  @override String get greeting => 'Good day, ';
  @override String get myWishes => 'My wishes';
  @override String get fulfilled => 'Fulfilled';
  @override String get bookedByMe => 'Booked by me';
  @override String get myWishlists => 'My wishlists';
  @override String get loading => 'Loading...';
  @override String get errorServer => 'Server error';

  // --- Wishlist ---
  @override String get publicRoom => 'Public room';
  @override String get publicRoomDesc => 'Visible to all users';
  @override String get newWishlist => 'New wishlist';
  @override String get wishlistName => 'Name';
  @override String get eventDate => 'Event date';
  @override String get add => 'Add';
  @override String get enterWishlistName => 'Enter wishlist name';
  @override String get enterEventDate => 'Enter event date';

  // --- Navigation ---
  @override String get navHome => 'Home';
  @override String get navFriends => 'Friends';
  @override String get navProfile => 'Profile';

  // --- Friends ---
  @override String get friends => 'Friends';
  @override String get friendsWishlists => "Your friends' wishlists";
  @override String get findFriend => 'Find a friend';
  @override String get friendRequests => 'Friend requests';
  @override String get myFriends => 'My friends';
  @override String get today => 'Today!';
  @override String get tomorrow => 'Tomorrow';
  @override String inNDays(int n) => 'In $n days';
  @override String get viewAndBook => 'View and book';
  @override String get feedEmpty => 'Nothing here yet';
  @override String get addFriendsToSeeFeed => 'Add friends to see their wishlists';
  @override String get findFriends => 'Find friends';
  @override String get search => 'Search';
  @override String get enterUsername => 'Enter username...';
  @override String get requestSent => 'Request sent';
  @override String get nobodyFound => 'Nobody found';
  @override String get tryAnotherName => 'Try another name';
  @override String get startSearch => 'Start searching';
  @override String get enterUsernameAbove => 'Enter username above';
  @override String get incoming => 'Incoming';
  @override String get outgoing => 'Outgoing';
  @override String get responseSent => 'Response sent';
  @override String get requestCancelled => 'Request cancelled';
  @override String get noIncomingRequests => 'No incoming requests';
  @override String get noOutgoingRequests => 'No outgoing requests';
  @override String get pending => 'Pending';
  @override String get emptyHere => 'Nothing here yet';
  @override String friendRooms(String name) => "$name's rooms";
  @override String get success => 'Success';
  @override String get operationError => 'Error';
}
