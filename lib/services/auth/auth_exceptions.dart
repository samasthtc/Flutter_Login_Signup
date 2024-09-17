// register exceptions
// class MissingNameAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class MissingPasswordAuthException implements Exception {}

// email verification exceptions
class InvalidEmailAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

// user not logged in exception
class UserNotLoggedInAuthException implements Exception {}

// invalid credentials exception
class InvalidCredentialsAuthException implements Exception {}
