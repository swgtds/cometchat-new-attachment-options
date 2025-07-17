import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';


class MessagesScreen extends StatefulWidget {
  final User? user;
  final Group? group;

  const MessagesScreen({Key? key, this.user, this.group}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Helper method to send a custom message
  void sendCustomMessage() {
    // Determine receiver details
    String? receiverUid;
    String receiverType;

    if (widget.user != null) {
      receiverUid = widget.user!.uid;
      receiverType = CometChatReceiverType.user;
    } else if (widget.group != null) {
      receiverUid = widget.group!.guid;
      receiverType = CometChatReceiverType.group;
    } else {
      debugPrint("No receiver found");
      return;
    }

    // Custom data (example: location)
    Map<String, String> customData = {
      "latitude": "19.0760",
      "longitude": "72.8777",
    };

    // Create the custom message
    CustomMessage customMessage = CustomMessage(
      receiverUid: receiverUid,
      type: CometChatMessageType.custom,
      customData: customData,
      receiverType: receiverType,
      subType: "LOCATION",
    );

    customMessage.conversationText = "Shared a location!";

    // Send the custom message
    CometChat.sendCustomMessage(
      customMessage,
      onSuccess: (CustomMessage message) {
        debugPrint("Custom Message Sent Successfully: $message");
      },
      onError: (CometChatException e) {
        debugPrint("Custom message sending failed with exception: ${e.message}");
      },
    );
  }

  @override
Widget build(BuildContext context) {
  if (widget.user == null && widget.group == null) {
    return const Scaffold(
      body: Center(child: Text("❌ Error: No user or group provided.")),
    );
  }

  return Scaffold(
    appBar: CometChatMessageHeader(user: widget.user, group: widget.group),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: CometChatMessageList(
              user: widget.user,
              group: widget.group,
            ),
          ),
          CometChatMessageComposer(
            user: widget.user,
            group: widget.group,
            attachmentOptions: (context, user, group, id) {
              return <CometChatMessageComposerAction>[
                CometChatMessageComposerAction(
                  id: "Custom Option 1",
                  title: "Send Location",
                  icon: Icon(Icons.location_on),
                  onItemClick: (ctx, u, g) {
                    sendCustomMessage();
                  },
                ),
              ];
            },
          ),
        ],
      ),
    ),
  );
}

}
