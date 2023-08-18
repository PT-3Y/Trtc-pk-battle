import 'package:nb_utils/nb_utils.dart';

import '../models/messages/emoji.dart';

List<Emojis> emojiList = [];

void getChatEmojiList() {
  emojiList.addAll(
    [
      Emojis.fromJson({
        "id": "+1",
        "name": "Thumbs Up",
        "keywords": ["+1", "thumbsup", "yes", "awesome", "good", "agree", "accept", "cool", "hand", "like"],
        "skins": [
          {"unified": "1f44d", "native": "👍", "x": 12, "y": 50},
        ],
        "version": 1
      }),
      Emojis.fromJson(
        {
          "id": "ok_hand",
          "name": "Ok Hand",
          "keywords": ["fingers", "limbs", "perfect", "okay"],
          "skins": [
            {"unified": "1f44c", "native": "👌", "x": 12, "y": 44}
          ],
          "version": 1
        },
      ),
      Emojis.fromJson(
        {
          "id": "heart_eyes",
          "name": "Smiling Face with Heart-Eyes",
          "keywords": ["love", "like", "affection", "valentines", "infatuation", "crush"],
          "skins": [
            {"unified": "1f60d", "native": "😍", "x": 32, "y": 33}
          ],
          "version": 1
        },
      ),
      Emojis.fromJson(
        {
          "id": "astonished",
          "name": "Astonished Face",
          "keywords": ["xox", "surprised", "poisoned"],
          "skins": [
            {"unified": "1f632", "native": "😲", "x": 33, "y": 10}
          ],
          "version": 1
        },
      ),
      Emojis.fromJson(
        {
          "id": "star",
          "name": "Star",
          "keywords": ["night", "yellow"],
          "skins": [
            {"unified": "2b50", "native": "⭐", "x": 59, "y": 24}
          ],
          "version": 1
        },
      ),
      Emojis.fromJson(
        {
          "id": "thinking_face",
          "name": "Thinking Face",
          "keywords": ["hmmm", "consider"],
          "skins": [
            {"unified": "1f914", "native": "🤔", "x": 39, "y": 1}
          ],
          "version": 1
        },
      ),
    ],
  );
}
