import 'dart:isolate';
import 'dart:convert';
import 'package:http/http.dart' as http;

// This function runs in a separate isolate and fetches data from a given URL
void fetchDataIsolate(SendPort sendPort) async {
  // Define the URL to fetch data from
  final uri = Uri.parse('http://10.0.2.2:3000/api/data');

  // Fetch data from the URL
  final response = await http.get(uri);

  // Check if the request was successful
  if (response.statusCode == 200) {
    // Decode the JSON response and send it back to the main isolate
    final data = jsonDecode(response.body);
    sendPort.send(data);
  } else {
    // If the request was not successful, send null back to the main isolate
    sendPort.send(null);
  }
}

// This function spawns a new isolate and waits for the result
Future<dynamic> fetchData() async {
  // Create a new receive port for the new isolate to send data to
  final receivePort = ReceivePort();

  // Spawn a new isolate and pass the receive port's send port to it
  await Isolate.spawn(fetchDataIsolate, receivePort.sendPort);

  // Wait for the first message from the new isolate and return it
  return receivePort.first;
}