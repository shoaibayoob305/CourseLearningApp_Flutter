import 'package:flutter/material.dart';
import 'package:frontend/app/modules/friends/view/friends_list_view.dart';
import 'package:frontend/app/modules/friends/view/pending_friend_view.dart';
import 'package:frontend/app/modules/friends/view/request_friends_view.dart';
import 'package:get/get.dart';

class NewFriendsTabview extends StatelessWidget {
  const NewFriendsTabview({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios_new),
          ),
          surfaceTintColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Color(0xff233853),
            indicatorWeight: 3.0,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Pending"),
              Tab(text: "Sent"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FriendsListView(),
            PendingFriendView(),
            RequestFriendsView(),
          ],
        ),
      ),
    );
  }
}
