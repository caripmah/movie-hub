import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviehub/constant/const.dart';

class ChatbotService extends StatefulWidget {
  const ChatbotService({super.key});

  @override
  State<ChatbotService> createState() => _ChatbotServiceState();
}

class _ChatbotServiceState extends State<ChatbotService> {
  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "Arif",
  );

  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini AI",
    profileImage:
        "https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/106/2024/03/28/202403271806-maincropped_1711537586-457414092.jpg",
  );

  List<ChatMessage> messages = [];
  bool isLoading = false;

  late Gemini gemini = Gemini.init(apiKey: ApiKey().geminiKey);

  void sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages.insert(0, chatMessage);
      isLoading = true;
    });

    try {
      // variable tampungan dari object chatMessage
      String question = chatMessage.text;
      List<Uint8List>? images = [];

      if (chatMessage.medias?.isNotEmpty == true) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen(
        (event) {
          ChatMessage? lastMessage = messages.firstOrNull;

          if (lastMessage != null && lastMessage.user == geminiUser) {
            lastMessage = messages.removeAt(0);
            String response = event.content?.parts?.fold(
                  "",
                  (previousValue, element) => "$previousValue${element.text}",
                ) ??
                "";

            lastMessage.text += response;

            setState(() {
              messages.insert(0, lastMessage!);
            });
          } else {
            String response = event.content?.parts?.fold(
                  "",
                  (previousValue, element) => "$previousValue${element.text}",
                ) ??
                "";

            ChatMessage message = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response,
            );

            setState(() {
              messages.insert(0, message);
            });
          }
        },
        onDone: () {
          setState(() {
            isLoading = false;
          });
        },
        onError: (error) {
          print(error);
          setState(() {
            isLoading = false;
          });
        },
      );
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sendMediaMessage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: 'Gambar apakah ini?',
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          ),
        ],
      );

      sendMessage(chatMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chatbot Service"),
      ),
      body: Stack(
        children: [
          DashChat(
            currentUser: currentUser,
            onSend: sendMessage,
            messages: messages,
            messageListOptions: MessageListOptions(
              dateSeparatorBuilder: (date) {
                return Text("${date.hour}:${date.minute}");
              },
            ),
            messageOptions: MessageOptions(
              messageTextBuilder: (message, previousMessage, nextMessage) {
                return MarkdownBody(
                  data: message.text,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              },
              messageMediaBuilder: (message, previousMessage, nextMessage) {
                return MarkdownBody(
                  data: message.text,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              },
            ),
            inputOptions: InputOptions(
              alwaysShowSend: false,
              sendOnEnter: true,
              trailing: [
                IconButton(
                  onPressed: _sendMediaMessage,
                  icon: const Icon(
                    Icons.image,
                  ),
                ),
              ],
            ),
            scrollToBottomOptions: ScrollToBottomOptions(
              scrollToBottomBuilder: (scrollController) {
                return const Icon(Icons.upcoming);
              },
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SpinKitCircle(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
