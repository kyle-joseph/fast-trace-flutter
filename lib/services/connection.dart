import 'package:http/http.dart' as http;

class Connection {
  //http request only used to check if the app can access the internet
  //internet address lookup won't work if mobile data is turned on

  checkConnection() async {
    try {
      var response =
          await http.get('https://jsonplaceholder.typicode.com/posts').timeout(
                Duration(seconds: 30),
              );
      if (response.statusCode == 200) {
        print('connected');
        return true;
      } else {
        print('not connected');
        return false;
      }
    } catch (_) {
      print('not connected');
      return false;
    }
  }
}
