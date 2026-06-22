library;

import 'dart:async';

import 'package:flutter/widgets.dart';

enum CameraPosition { front, back }

enum VideoViewFit { cover, contain }

class VideoParametersPresets {
  static const h720_169 = Object();
  static const h360_169 = Object();
  static const h180_169 = Object();
}

class CameraCaptureOptions {
  const CameraCaptureOptions({this.params, this.cameraPosition = CameraPosition.front});

  final Object? params;
  final CameraPosition cameraPosition;
}

class VideoEncoding {
  const VideoEncoding({this.maxBitrate, this.maxFramerate});

  final int? maxBitrate;
  final int? maxFramerate;
}

class VideoPublishOptions {
  const VideoPublishOptions({this.videoEncoding, this.videoSimulcastLayers = const []});

  final VideoEncoding? videoEncoding;
  final List<Object> videoSimulcastLayers;
}

class RoomOptions {
  const RoomOptions({
    this.adaptiveStream = false,
    this.dynacast = false,
    this.defaultCameraCaptureOptions,
    this.defaultVideoPublishOptions,
  });

  final bool adaptiveStream;
  final bool dynacast;
  final CameraCaptureOptions? defaultCameraCaptureOptions;
  final VideoPublishOptions? defaultVideoPublishOptions;
}

class Room {
  Room({this.roomOptions});

  final RoomOptions? roomOptions;
  final LocalParticipant? localParticipant = LocalParticipant();
  final Map<String, Participant> remoteParticipants = {};

  Future<void> connect(String url, String token) async {}

  Future<void> disconnect() async {}

  EventsListener<RoomEvent> createListener() => EventsListener<RoomEvent>();
}

class EventsListener<T> {
  EventsListener<T> on<E extends T>(void Function(E event) callback) => this;

  Future<void> dispose() async {}
}

class RoomEvent {}

class TrackSubscribedEvent extends RoomEvent {}

class TrackUnsubscribedEvent extends RoomEvent {}

class LocalTrackPublishedEvent extends RoomEvent {}

class LocalTrackUnpublishedEvent extends RoomEvent {}

class ParticipantConnectedEvent extends RoomEvent {}

class ParticipantDisconnectedEvent extends RoomEvent {}

class TrackMutedEvent extends RoomEvent {}

class TrackUnmutedEvent extends RoomEvent {}

class ActiveSpeakersChangedEvent extends RoomEvent {
  ActiveSpeakersChangedEvent({this.speakers = const []});

  final List<Participant> speakers;
}

class RoomReconnectingEvent extends RoomEvent {}

class RoomReconnectedEvent extends RoomEvent {}

class Participant {
  Participant({this.identity = ''});

  final String identity;
  final List<TrackPublication> audioTrackPublications = [];
  final List<TrackPublication> videoTrackPublications = [];
}

class LocalParticipant extends Participant {
  Future<void> setMicrophoneEnabled(bool enabled) async {}

  Future<void> setCameraEnabled(bool enabled) async {}
}

class Track {}

class VideoTrack extends Track {}

class LocalVideoTrack extends VideoTrack {
  CameraCaptureOptions currentOptions = const CameraCaptureOptions();

  Future<void> setCameraPosition(CameraPosition position) async {
    currentOptions = CameraCaptureOptions(cameraPosition: position);
  }
}

class TrackPublication {
  TrackPublication({this.track, this.muted = false});

  final Track? track;
  final bool muted;
}

class MediaDevice {
  const MediaDevice({this.deviceId = '', this.label = '', this.kind = ''});

  final String deviceId;
  final String label;
  final String kind;
}

class Hardware {
  Hardware._();

  static final instance = Hardware._();

  final StreamController<List<MediaDevice>> onDeviceChange =
      StreamController<List<MediaDevice>>.broadcast();

  Future<void> setSpeakerphoneOn(bool enabled) async {}

  Future<List<MediaDevice>> audioOutputs() async => const [];
}

class VideoTrackRenderer extends StatelessWidget {
  const VideoTrackRenderer(this.track, {super.key, this.fit});

  final VideoTrack track;
  final VideoViewFit? fit;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
