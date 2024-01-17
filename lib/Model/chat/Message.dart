/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:notiboy/utils/chat/extensions.dart';

import 'enumaration.dart';

class Message {
  /// Used for accessing widget's render box.
  final GlobalKey key;

  /// Provides actual message it will be text or image/audio file path.
  final String message;

  /// Provides message created date time.
  final String createdAt;

  /// Provides id of sender of message.
  final String sendBy;
  final String receiver;

  /// Provides message type.
  final MessageType messageType;

  /// Status of the message.
  final ValueNotifier<MessageStatus> _status;
  final ValueNotifier<bool> _timeIsVisible;
  final ValueNotifier<String> _id;

  /// Provides max duration for recorded voice message.
  Duration? voiceMessageDuration;

  Message({
    required this.message,
    required this.createdAt,
    required this.sendBy,
    required this.receiver,
    this.messageType = MessageType.text,
    this.voiceMessageDuration,
    MessageStatus status = MessageStatus.submitted,
    String id = '',
    bool timeIsVisible = false,
  })  : key = GlobalKey(),
        _id = ValueNotifier(id),
        _status = ValueNotifier(status),
        _timeIsVisible = ValueNotifier(false),
        assert(
          (messageType.isVoice
              ? ((defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android))
              : true),
          "Voice messages are only supported with android and ios platform",
        );

  /// curret messageStatus
  MessageStatus get status => _status.value;

  String get id => _id.value;

  /// For [MessageStatus] ValueNotfier which is used to for rebuilds
  /// when state changes.
  /// Using ValueNotfier to avoid usage of setState((){}) in order
  /// rerender messages with new receipts.
  ValueNotifier<MessageStatus> get statusNotifier => _status;

  ValueNotifier<bool> get timeIsVisible => _timeIsVisible;

  /// This setter can be used to update message receipts, after which the configured
  /// builders will be updated.
  set setStatus(MessageStatus messageStatus) {
    _status.value = messageStatus;
  }

  set setid(String messageStatus) {
    _id.value = messageStatus;
  }

  set setTimeIsVisible(bool timeIsVisible) {
    _timeIsVisible.value = timeIsVisible;
  }

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      id: json["id"],
      message: json["message"],
      createdAt: json["createdAt"],
      sendBy: json["sendBy"],
      receiver: json["receiver"],
      messageType: json["message_type"],
      timeIsVisible: json["timeIsVisible"],
      voiceMessageDuration: json["voice_message_duration"],
      status: json['status']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'createdAt': createdAt,
        'sendBy': sendBy,
        'message_type': messageType,
        'timeIsVisible': timeIsVisible,
        'voice_message_duration': voiceMessageDuration,
        'status': status.name
      };
}
