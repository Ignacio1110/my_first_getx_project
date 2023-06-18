import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final ownUser = const types.User(
  id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  firstName: "Ignacio",
);

List<Map<String, String>> authors = [
  {
    "firstName": "user1",
    "id": "e12452f4-835d-4dbe-ba77-b076e659774d",
    "imageUrl":
        "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
    "lastName": "Zhang"
  },
  {
    "firstName": "user2",
    "id": "e22552f4-835d-4dbe-ba77-b076e659774d",
    "imageUrl":
        "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
    "lastName": "King"
  },
  {
    "firstName": "user3",
    "id": "e32552f4-83sd-4dbe-ba77-b076e659774d",
    "imageUrl":
        "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
    "lastName": "King"
  },
];

List<String> textSample = [
  "你好，範例1",
  "你好，範例2",
  "你好，範例3",
  "你好，範例4",
];

final List<String> messageUUID = [
  "372aab90-c20f-4ee8-91e7-420ce1c2c8a2",
  "39966425-930e-4f5e-8bc5-351f39248505",
  "b2af6ada-ca0f-458e-9977-90c38e47182b",
  "d11114ae-8811-4c9f-8b56-28340d93b7c0",
  "973e17d9-aab8-4ba4-91a8-cdc888d67888",
  "9a117587-1733-4b3b-aa57-d8feef093ce0",
  "95b8c633-198f-47ca-92a6-7945577b1a39",
  "a1ef1a24-412b-46c2-a651-a1887339f897",
  "e761271c-5433-4c31-b751-f44eaae4fccb",
  "68dfb1ef-0eb8-41ab-8d33-82a5ca42c34d",
];

int yesterdayZeroTime() {
  // DateTime dateTime = DateTime.now();
  int zeroAM = DateTime(2022, 6, 18).millisecondsSinceEpoch;
  return zeroAM;
}
