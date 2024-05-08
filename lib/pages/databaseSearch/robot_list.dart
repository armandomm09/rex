import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/components/visualization/post_item.dart';
import 'package:flutter/material.dart';

class RobotListView extends StatelessWidget {
  const RobotListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> users = [];
    postList() {
      for (var i = 0; i < 30; i++) {
        users.add("User number $i");
      }
    }

    postList();

    return Scaffold(
      drawer: const AppDrawer(),
        appBar: AppBar(
            elevation: 50,
            toolbarHeight: 70,
            foregroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              "Other robots",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 28,
                  fontFamily: "Industry",
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            )),
        body: AppLiquidPullRefresh(
          onRefresh: () async {  },
          child: ListView.separated(
              itemBuilder: (context, index) {
                return PostItem(user: users[index]);
              },
              separatorBuilder: (context, index) {
                return const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20,),
                      ],
                    ),
                    SizedBox(height: 30,)
                  ],
                );
              },
              itemCount: users.length),
        ));
  }
}

/*

            */