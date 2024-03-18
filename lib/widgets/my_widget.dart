import 'package:flutter/material.dart';
import '../isolates/fetch_data_isolate.dart';

// Define a stateful widget that fetches data using an isolate
class _MyWidget extends StatefulWidget {
  @override
  MyWidgetState createState() => MyWidgetState();
}

// Define the state for the widget
class MyWidgetState extends State<_MyWidget> {
  // Declare a variable to store the fetched data
  dynamic _data;

  // Define the initState method to fetch data when the widget is created
  @override
  void initState() {
    super.initState();
    // Call the fetchData function and wait for the result
    fetchData().then((data) {
      // When the data is fetched, update the state of the widget
      setState(() {
        _data = data;
      });
    });
  }

  // Define the build method to display the widget
  @override
  Widget build(BuildContext context) {
    // Check if the data has been fetched
    if (_data == null) {
      // If not, display a circular progress indicator
      return const CircularProgressIndicator();
    } else {
      // If yes, display the fetched data as a text
      return Text('Fetched data: $_data');
    }
  }
}