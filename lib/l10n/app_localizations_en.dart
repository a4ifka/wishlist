// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get reppassword => 'Repeat password';
  @override
  String get register => 'Register';
  @override
  String get next => 'Next';
  @override
  String get restorePassword => 'Restore password';
  @override
  String get signInButton => 'Sign In';
  @override
  String get createAccount => 'Create Account';
  @override
  String get authError => 'Authentication Error!';
  @override
  String get featureInDevelopment => 'In Development';
  @override
  String get passwordHint => 'Create a password (at least 8 characters)';
  @override
  String get passwordsMismatch => 'Passwords do not match!';
  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get enterYourNickname => 'Enter your nickname';
  @override
  String get nickname => 'Nickname';
  @override
  String get birthDateOptional => 'Birth date (optional)';
  @override
  String get notSpecified => 'Not specified';
  @override
  String get userNotAuthorized => 'User not authorized';
  @override
  String get pleaseEnterNickname => 'Please enter a nickname';

  @override
  String get profile => 'Profile';
  @override
  String get settings => 'Settings';
  @override
  String get language => 'Language';
  @override
  String get signOut => 'Sign Out';
  @override
  String get birthDate => 'Birth date';

  @override
  String get home => 'Home';
  @override
  String get greeting => 'Hello, ';
  @override
  String get myWishes => 'My Wishes';
  @override
  String get fulfilled => 'Fulfilled';
  @override
  String get bookedByMe => 'Booked by me';
  @override
  String get myWishlists => 'My Wishlists';
  @override
  String get loading => 'Loading...';
  @override
  String get errorServer => 'Server Error';

  @override
  String get publicRoom => 'Public Room';
  @override
  String get publicRoomDesc => 'Visible to all users';
  @override
  String get newWishlist => 'New Wishlist';
  @override
  String get wishlistName => 'Name';
  @override
  String get eventDate => 'Event Date';
  @override
  String get add => 'Add';
  @override
  String get enterWishlistName => 'Enter wishlist name';
  @override
  String get enterEventDate => 'Enter event date';

  @override
  String get share => 'Share';
  @override
  String inviteText(String roomName, String url) =>
      'Check out my wishlist "$roomName"!\n$url';
  @override
  String get noWishesYet => 'No wishes yet';
  @override
  String get publicLabel => 'Public';
  @override
  String get privateLabel => 'Private';

  @override
  String get navHome => 'Home';
  @override
  String get navFriends => 'Friends';
  @override
  String get navProfile => 'Profile';

  @override
  String get friends => 'Friends';
  @override
  String get friendsWishlists => 'Your friends\' wishlists';
  @override
  String get findFriend => 'Find a friend';
  @override
  String get friendRequests => 'Friend requests';
  @override
  String get myFriends => 'My friends';
  @override
  String get today => 'Today!';
  @override
  String get tomorrow => 'Tomorrow';
  @override
  String inNDays(int n) => 'In $n days';
  @override
  String get viewAndBook => 'View and book';
  @override
  String get feedEmpty => 'It\'s empty here';
  @override
  String get addFriendsToSeeFeed => 'Add friends to see their wishlists';
  @override
  String get findFriends => 'Find friends';
  @override
  String get search => 'Search';
  @override
  String get enterUsername => 'Enter username...';
  @override
  String get requestSent => 'Request sent';
  @override
  String get nobodyFound => 'Nobody found';
  @override
  String get tryAnotherName => 'Try another name';
  @override
  String get startSearch => 'Start searching';
  @override
  String get enterUsernameAbove => 'Enter a username above';
  @override
  String get incoming => 'Incoming';
  @override
  String get outgoing => 'Outgoing';
  @override
  String get responseSent => 'Response sent';
  @override
  String get requestCancelled => 'Request cancelled';
  @override
  String get noIncomingRequests => 'No incoming requests';
  @override
  String get noOutgoingRequests => 'No outgoing requests';
  @override
  String get pending => 'Pending';
  @override
  String get emptyHere => 'It\'s empty here';
  @override
  String friendRooms(String name) => '$name\'s rooms';
  @override
  String get success => 'Success';
  @override
  String get operationError => 'Error';
  @override
  String get friendsHaventCreatedWishlists => 'Your friends haven\'t created any wishlists yet';
  @override
  String get noWishlistsFromFriends => 'No wishlists yet';
  @override
  String get friendsWithWishlists => 'Friends with wishlists';
  @override
  String get friendsWithoutWishlists => 'Other friends';
  @override
  String get noWishlistsYet => 'No wishlists yet';
}