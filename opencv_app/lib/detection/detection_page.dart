import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:opencv_app/main.dart';
import 'package:opencv_app/results/results_page.dart';
import 'package:opencv_app/detector/aruco_detector_async.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({Key? key}) : super(key: key);

  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> with WidgetsBindingObserver {
  CameraController? _camController;
  late ArucoDetectorAsync _arucoDetector;
  int _camFrameRotation = 0;
  double _camFrameToScreenScale = 0;
  bool _detectionInProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _arucoDetector = ArucoDetectorAsync();
    initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _camController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _arucoDetector.destroy();
    _camController?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    var idx = cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
    if (idx < 0) {
      log("No Back camera found");
      return;
    }

    var desc = cameras[idx];
    _camFrameRotation = Platform.isAndroid ? desc.sensorOrientation : 0;
    _camController = CameraController(
      desc,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.yuv420 : ImageFormatGroup.bgra8888,
    );

    try {
      await _camController!.initialize();
      await _camController!.startImageStream((image) => _processCameraImage(image));
    } catch (e) {
      log("Error initializing camera, error: ${e.toString()}");
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_detectionInProgress || !mounted) {
      return;
    }

    if (_camFrameToScreenScale == 0) {
      var w = (_camFrameRotation == 0 || _camFrameRotation == 180) ? image.width : image.height;
      _camFrameToScreenScale = MediaQuery.of(context).size.width / w;
    }

    _detectionInProgress = true;
    var res = await _arucoDetector.detect(image, _camFrameRotation);
    _detectionInProgress = false;

    if (!mounted || res == null || res.isEmpty || res.length == 1) {
      return;
    }
    _camController!.stopImageStream();
    _camController!.dispose();
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ResultsPage(res)));
  }

  @override
  Widget build(BuildContext context) {
    if (_camController == null) {
      return Container(
        color: Colors.black,
      );
    }

    return Container(
      child: CameraPreview(_camController!),
    );
  }
}
