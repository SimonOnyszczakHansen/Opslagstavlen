import 'dart:convert';
import 'package:http/http.dart' as http;

// AuthenticationService class handles the authentication requests.
class AuthenticationService {
  // Base URL of the rest api.
  final String _baseUrl = 'http://10.0.2.2:3000/api';

  // Method to perform login. It expects a JSON string as an argument which contains login credentials.
  Future<String?> login(String jsonBody) async {
    // Constructs the full URI for the login endpoint.
    var uri = Uri.parse('$_baseUrl/login');
    try {
      // Sends a POST request to the login endpoint with the JSON body and sets the Content-Type header to application/json.
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );
      // Checks if the HTTP status code is 200 (OK), indicating a successful login.
      if (response.statusCode == 200) {
        // Decodes the response body from JSON to a Dart object.
        final responseData = json.decode(response.body);
        // Returns the JWT token received from the server.
        return responseData['token'];
      } else {
        // If the status code is not 200, logs the failure with the status code.
        print('Login failed with status code: ${response.statusCode}');
        return null; // Returns null to indicate failure.
      }
    } catch (e) {
      // Catches any network errors and logs them.
      print('Network error: $e');
      return null; // Returns null to indicate network error.
    }
  }
}
