import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:outage_app/Utils/common_widgets/Routes/routes.dart';
import 'package:outage_app/Utils/common_widgets/Routes/routes_name.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/bloc_multi_provider.dart';
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/Utils/common_widgets/res/secrets.dart';
import 'package:outage_app/Utils/common_widgets/res/singleton.dart';
import 'package:uuid/uuid.dart';

import 'Utils/common_widgets/res/UserContext.dart';

class RootApp extends StatefulWidget {
  final Client client;

  const RootApp({required this.client});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Singleton.instanceInit()?.context = context;
    AppConfig.instanceInit()!.setClient(client: widget.client);
    return multiBlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: EnvironmentConfig.of(context)!.primaryTheme,
          hintColor: EnvironmentConfig.of(context)!.primaryTheme,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: EnvironmentConfig.of(context)!.primaryTheme,
          ),
        ),
        // home: GoogleMapSearchPlacesApi(),
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}

class GoogleMapSearchPlacesApi extends StatefulWidget {
  const GoogleMapSearchPlacesApi({Key? key}) : super(key: key);

  @override
  _GoogleMapSearchPlacesApiState createState() =>
      _GoogleMapSearchPlacesApiState();
}

class _GoogleMapSearchPlacesApiState extends State<GoogleMapSearchPlacesApi> {
  final _controller = TextEditingController();
  var uuid = const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    const String PLACES_API_KEY = Secrets.API_KEY;

    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      if (kDebugMode) {
        print('mydata');
        print(data);
      }
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Search places Api')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search your location here",
                focusColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: const Icon(Icons.map),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {},
                  child: ListTile(
                    title: Text(_placeList[index]["description"]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
