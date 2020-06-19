import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:spacex/drawer.dart';
import 'package:spacex/videoDemo.dart';
import 'package:spacex/web_view_container.dart';
import 'package:video_player/video_player.dart';

class SpaceX extends StatefulWidget {
  SpaceX({
    Key key,
  }) : super(key: key);

  @override
  _SpaceXState createState() => _SpaceXState();
}

VideoPlayerController _controller;
Future<void> _initializeVideoPlayerFuture;

@override
void initState() {
  _controller = VideoPlayerController.network(
      "https://www.spacex.com/media/iss_docking_sim.mp4");
  //_controller = VideoPlayerController.asset("assets/iss_docking_sim.mp4");
  _initializeVideoPlayerFuture = _controller.initialize();
  _controller.setLooping(true);
  _controller.setVolume(1.0);
}

@override
Future<void> dispose() async {}

checkInternet() async {
  print("The statement 'this machine is connected to the Internet' is: ");
  print(await DataConnectionChecker().hasConnection);
  // returns a bool

  // We can also get an enum instead of a bool
  print("Current status: ${await DataConnectionChecker().connectionStatus}");
  // prints either DataConnectionStatus.connected
  // or DataConnectionStatus.disconnected

  // This returns the last results from the last call
  // to either hasConnection or connectionStatus
  print("Last results: ${DataConnectionChecker().lastTryResults}");

  // actively listen for status updates
  var listener = DataConnectionChecker().onStatusChange.listen(
    (status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    },
  );

  return await DataConnectionChecker().connectionStatus;
}

class _SpaceXState extends State<SpaceX> {
  final _links = ['https://iss-sim.spacex.com/'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        title: SafeArea(
          minimum: EdgeInsets.all(10),
          child: SizedBox(
            width: 200,
            child: Transform.translate(
              offset: Offset(0.0, 0.0),
              child: SvgPicture.string(
                _svg_dc9cor,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
        ),
        /* actions: <Widget>[
          SafeArea(
            minimum: EdgeInsets.all(10),
            child: SizedBox(
              width: 200,
              child: Transform.translate(
                offset: Offset(0.0, 0.0),
                child: SvgPicture.string(
                  _svg_dc9cor,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
          ),
        ],*/
        backgroundColor: Colors.black,
      ),
      drawer: SpacexDrawer(),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        mini: true,
        backgroundColor: Colors.white,
        onPressed: () {
          Share.share(
              "Try this SpaceX fan app and try CREW DRAGON DOCKING SIMULATOR: https://drive.google.com/file/d/1EeB1dSHG42z-F-KYxAgzvHizW9-7jI8y/view?usp=sharing");
        },
        child: Icon(
          Icons.share,
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color(0xff000000),
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Text(
              'CREW DRAGON DOCKING SIMULATOR',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 15,
          ),

          Text(
            'Crew Dragon is designed to autonomously dock and undock with the International Space Station. However, the crew can take manual control of the spacecraft if necessary.',
            style: TextStyle(
              fontFamily: 'Segoe UI', fontSize: 15, //color: Colors.white,
              color: const Color(0xff707070),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Transform.translate(
            offset: Offset(0, 0),
            child: Column(
              children: <Widget>[
                Column(
                  children: _links.map((link) {
                    return _urlButton(context, link);
                  }).toList(),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Expanded(
            child: VideoDemo(),
          ),
          SizedBox(
            height: 5,
          ),
          //link
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _urlButton(BuildContext context, String url) {
    return Container(
      child: InkWell(
        onTap: () async {
          DataConnectionStatus status = await checkInternet();
          if (status == DataConnectionStatus.connected) {
            _handleURLButtonPress(context, url);
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("No Internet"),
                      content: Text(
                          "Check Your Internet Connection.\nIf problem persist contact developer."),
                    ));
          }
        },
        child: SizedBox(
          width: 156.0,
          height: 0.0,
          child: Text(
            '\nTry Docking Manually like Astronaut',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      width: 253.0,
      height: 85.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.0),
        color: const Color(0xff797979),
        border: Border.all(width: 1.0, color: const Color(0xff707070)),
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}

const String _svg_dc9cor =
    '<svg viewBox="0.0 0.0 351.5 40.8" ><path  d="M 77.29199981689453 15.0939998626709 L 49.24900054931641 15.0939998626709 L 48.20999908447266 15.87100028991699 L 48.20999908447266 40.81800079345703 L 55.97299957275391 40.81800079345703 L 55.97299957275391 31.4630012512207 L 56.7140007019043 30.79900169372559 L 77.29299926757813 30.79900169372559 C 82.48899841308594 30.79900169372559 84.92500305175781 29.4010009765625 84.92500305175781 25.81400108337402 L 84.92500305175781 20.08600044250488 C 84.92400360107422 16.49300003051758 82.48899841308594 15.0939998626709 77.29199981689453 15.0939998626709 M 77.29199981689453 24.3169994354248 C 77.29199981689453 26.00699996948242 76.17399597167969 26.35799980163574 73.73799896240234 26.35799980163574 L 56.79899978637695 26.35799980163574 L 55.97200012207031 25.55399894714355 L 55.97200012207031 20.20999908447266 L 56.7130012512207 19.5319995880127 L 73.73799896240234 19.5319995880127 C 76.17399597167969 19.5319995880127 77.29199981689453 19.87899971008301 77.29199981689453 21.57699966430664 L 77.29199981689453 24.3169994354248 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(5.84, 0.0)" d="M 99.08100128173828 19.8129997253418 L 105.7610015869141 29.60000038146973 L 105.390998840332 30.54800033569336 L 90.61799621582031 30.54800033569336 L 86.84700012207031 35.1870002746582 L 108.8369979858398 35.1870002746582 L 110.3610000610352 36.1150016784668 L 113.7750015258789 40.82400131225586 L 122.6589965820313 40.82400131225586 L 103.1859970092773 14.77499961853027" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(12.03, 0.0)" d="M 187.4179992675781 35.75699996948242 L 187.4179992675781 28.83300018310547 L 188.2169952392578 28.14299964904785 L 203.0789947509766 28.14299964904785 L 203.0789947509766 23.73399925231934 L 179.5240020751953 23.73399925231934 L 179.5240020751953 40.82300186157227 L 214.2700042724609 40.82300186157227 L 214.2700042724609 36.43500137329102 L 188.2519989013672 36.43500137329102" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(191.56, 15.09)" d="M 0 0 L 35.11299896240234 0 L 35.11299896240234 4.848000049591064 L 0 4.848000049591064 L 0 0 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(8.89, 0.0)" d="M 140.3609924316406 19.68499946594238 L 168.6489868164063 19.68499946594238 C 168.2129821777344 16.08799934387207 165.9809875488281 15.09000015258789 160.3189849853516 15.09000015258789 L 140.0599975585938 15.09000015258789 C 133.6709899902344 15.09000015258789 131.6329956054688 16.33699989318848 131.6329956054688 21.17200088500977 L 131.6329956054688 34.73699951171875 C 131.6329956054688 39.57699966430664 133.6709899902344 40.82399749755859 140.0599975585938 40.82399749755859 L 160.3190002441406 40.82399749755859 C 166.0639953613281 40.82399749755859 168.2640075683594 39.74499893188477 168.4140014648438 36.01399612426758 L 140.3610076904297 36.01399612426758 L 139.5290069580078 35.23099517822266 L 139.5290069580078 20.20899963378906" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path  d="M 29.33300018310547 25.11800003051758 L 8.753999710083008 25.11800003051758 L 8.14799976348877 24.45100021362305 L 8.14799976348877 20.04899978637695 L 8.750999450683594 19.58300018310547 L 36.49300003051758 19.58300018310547 L 36.87200164794922 18.6560001373291 C 35.927001953125 16.22500038146973 33.48000335693359 15.09099960327148 28.93600082397461 15.09099960327148 L 9.664999961853027 15.09099960327148 C 3.279999732971191 15.09099960327148 1.23900032043457 16.33799934387207 1.23900032043457 21.17300033569336 L 1.23900032043457 24.01700019836426 C 1.23900032043457 28.85799980163574 3.28000020980835 30.10300064086914 9.664999961853027 30.10300064086914 L 30.19800186157227 30.10300064086914 L 30.84300231933594 30.66900062561035 L 30.84300231933594 35.27099990844727 L 30.31700134277344 35.98899841308594 L 6.829999923706055 35.98899841308594 L 6.829999923706055 35.96699905395508 L 0.6779999732971191 35.96699905395508 C 0.6779999732971191 35.96699905395508 -0.02600002288818359 36.31999969482422 0.0009999871253967285 36.48500061035156 C 0.5259999632835388 39.86700057983398 2.829999923706055 40.82500076293945 8.346000671386719 40.82500076293945 L 29.33300018310547 40.82500076293945 C 35.71699905395508 40.82500076293945 37.81900024414063 39.57799911499023 37.81900024414063 34.73799896240234 L 37.81900024414063 31.19499969482422 C 37.81900024414063 26.36300086975098 35.71699905395508 25.11800003051758 29.33300018310547 25.11800003051758" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(14.37, 0.0)" d="M 236.7250061035156 14.98799991607666 L 225.1740112304688 14.98799991607666 L 224.5470123291016 16.18099975585938 L 237.3750152587891 25.5319995880127 C 239.8050079345703 24.125 242.4490203857422 22.69899940490723 245.3250122070313 21.29199981689453" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(15.94, 0.0)" d="M 247.0749969482422 32.60300064086914 L 258.3500061035156 40.82500076293945 L 270.0419921875 40.82500076293945 L 270.5260009765625 39.73600006103516 L 253.6900024414063 27.41300010681152 C 251.4539947509766 29.05400085449219 249.2449951171875 30.78700065612793 247.0749969482422 32.60300064086914" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(19.89, 0.0)" d="M 235.0059967041016 40.80599975585938 L 224.5549926757813 40.80599975585938 L 223.6719970703125 39.42300033569336 C 230.7779998779297 32.5620002746582 262.5599975585938 3.151000022888184 331.6440124511719 0 C 331.6440124511719 0 273.6579895019531 1.955999970436096 235.0059967041016 40.80599975585938" fill="#a7a9ac" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
