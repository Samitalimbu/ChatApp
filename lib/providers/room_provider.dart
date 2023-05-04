import 'package:firebase/constants/firebase_instances.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomStream =
    StreamProvider.autoDispose((ref) => FirebaseInstances.fireChat.rooms());
final messagesStream = StreamProvider.autoDispose.family(
    (ref, types.Room room) => FirebaseInstances.fireChat.messages(room));

final roomProvider = Provider((ref) => RoomProvider());

class RoomProvider {
  Future<types.Room?> roomCreate(types.User user) async {
    try {
      final response = await FirebaseInstances.fireChat.createRoom(user);
      return response;
    } catch (err) {
      return null;
    }
  }
}
