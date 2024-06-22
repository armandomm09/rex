import 'dart:convert';
import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chat_app/components/forms/pretty_counter.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/forms/app_text_field.dart';
import 'package:chat_app/components/forms/counter.dart';
import 'package:chat_app/components/forms/form_dropdown.dart';
import 'package:chat_app/models/match_scout.dart';
import 'package:chat_app/services/firebase/scout_service.dart';
import 'package:chat_app/services/firebase/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewMatchScouting extends StatefulWidget {
  const NewMatchScouting({super.key});

  @override
  State<NewMatchScouting> createState() => _NewMatchScoutingState();
}

class _NewMatchScoutingState extends State<NewMatchScouting> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  TextEditingController teamNumberController = TextEditingController();
  TextEditingController matchController = TextEditingController();
  TextEditingController matchTypeController = TextEditingController();
  TextEditingController allianceColorController = TextEditingController();

  TextEditingController preloadedNoteController = TextEditingController();
  TextEditingController initialPositionController = TextEditingController();

  TextEditingController autoLeaveStartingZoneController =
      TextEditingController();
  TextEditingController autoNotesOnSpeaker = TextEditingController();
  TextEditingController autoNoteScoringAccuracyController =
      TextEditingController();
  TextEditingController autoFoulsMadeController = TextEditingController();

  TextEditingController coopertitionBonusController = TextEditingController();
  TextEditingController teleopSpeakerNotesController = TextEditingController();
  TextEditingController teleopAmpNotesController = TextEditingController();
  TextEditingController teleopSpeakerAccuracyController =
      TextEditingController();
  TextEditingController teleopAmpAccuracyController = TextEditingController();
  TextEditingController teleopTimesAmplifiedController =
      TextEditingController();
  TextEditingController teleopSpeakerAmplifiedController =
      TextEditingController();
  TextEditingController tacticalDropController = TextEditingController();

  TextEditingController offenseQualityController = TextEditingController();
  TextEditingController deffenseQualityController = TextEditingController();
  TextEditingController climbingSpeedController = TextEditingController();
  TextEditingController succesfulClimbingController = TextEditingController();
  TextEditingController spotlitController = TextEditingController();

  TextEditingController agilityController = TextEditingController();
  TextEditingController deffenseSkillsController = TextEditingController();
  TextEditingController diedController = TextEditingController();
  TextEditingController recievedACardController = TextEditingController();
  TextEditingController hpSkillsController = TextEditingController();

  TextEditingController autoScoreController = TextEditingController();
  TextEditingController teleopScoreController = TextEditingController();
  TextEditingController finalScoreController = TextEditingController();
  TextEditingController foulsScoreController = TextEditingController();

  TextEditingController autoCommentsController = TextEditingController();
  TextEditingController teleopCommentsController = TextEditingController();
  String backgroundImagePath = "assets/images/dominiSplash2.png";
  String teamTitle = "Search team";
  var postsJson = [];

  Future<String?> getCurrentRegional() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = prefs.getString("currentRegional");
    var currentRegional = string;
    print(currentRegional);
    return currentRegional;
  }

  Future<void> fetchTeam(String teamNumber) async {
    var apiKey =
        "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
    var url = 'https://www.thebluealliance.com/api/v3/team/frc$teamNumber';

    if (teamNumber.isNotEmpty && teamNumber.length <= 4) {
      // ignore: unused_local_variable, prefer_typing_uninitialized_variables
      var postsJson2;
      try {
        print("fetching...");
        final uri = Uri.parse(url);
        final response = await http.get(uri, headers: {
          'X-TBA-Auth-Key': apiKey,
        });

        if (response.statusCode == 200) {
          print("200");
          dynamic data = jsonDecode(response.body);
          postsJson2 = data;
          print(data["nickname"]);
          setState(() {
            teamTitle = data["nickname"];
          });
        } else if (response.statusCode == 404) {
          print("invalid");
          setState(() {
            teamTitle = "Invalid team";
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  bool _isScrollingDown = true;

  ScrollController scrollController = ScrollController();
  loadBackgroundImage() async {
    try {
      await Hive.openBox("userData");
      var imagePathGet = await Hive.box("userData").get(1);
      print(imagePathGet);
    setState(() {
      backgroundImagePath = imagePathGet;
    });
    } catch (e) {
      print(e.toString());
    }
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBackgroundImage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        tooltip: 'Scroll ${_isScrollingDown ? 'Down' : 'Up'}',
        onPressed: () {
          scrollController.animateTo(
            _isScrollingDown
                ? scrollController.position.maxScrollExtent
                : scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          setState(() {
            _isScrollingDown = !_isScrollingDown;
          });
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (child, animation) => RotationTransition(
            turns: animation,
            child: child,
          ),
          child: Icon(
            _isScrollingDown ? Icons.arrow_downward : Icons.arrow_upward,
            color: Theme.of(context).colorScheme.surface,
            key: ValueKey<bool>(_isScrollingDown),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 70,
          //foregroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            teamTitle,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 28,
                fontFamily: "Industry",
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          )),
      body: Container(
        decoration: BoxDecoration(
<<<<<<< HEAD:lib/pages/scout/match_scout.dart
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/chat_background.png'))),
=======
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(backgroundImagePath))
        ),
>>>>>>> main:lib/pages/scout/matchscout/match_scout.dart
        child: AppLiquidPullRefresh(
          backgroundColor: Color.fromARGB(140, 0, 0, 0),
          color: Color.fromARGB(116, 135, 10, 10),
          onRefresh: () async {},
          child: SingleChildScrollView(
            controller: scrollController,
            child: Stack(
              children: [
                Positioned.fill(
                    child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Color.fromARGB(213, 0, 0, 0),
                  ),
                )),
                Center(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            return buildHorizontalLayout();
                          } else {
                            return buildVerticalLayout();
                          }
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildHorizontalLayout() {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "MATCH aNFO",
          fontSize: 10,
          textColor: TextColor.base,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const AppText(
                  text: "Team number",
                  textColor: TextColor.base,
                  fontSize: 20,
                ),
                const SizedBox(
                  height: 0,
                ),
                AppTextField(
                    onChanged: fetchTeam,
                    hintText: "Search team",
                    controller: teamNumberController),
              ],
            ),
            Column(
              children: [
                const AppText(
                  text: "Match number",
                  textColor: TextColor.black,
                  fontSize: 20,
                ),
                const SizedBox(
                  height: 0,
                ),
                AppTextField(
                    hintText: "Search match", controller: matchController),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FormDropdown(
              title: "Match type",
              listOfItems: const ["Qualis", "Practice", "Playoffss"],
              controller: matchController,
            ),
            FormDropdown(
                title: "Color of their alliance",
                listOfItems: const ["Blue", "Red"],
                controller: allianceColorController),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        const AppText(
          text: "PRE-MATCH",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FormDropdown(
              title: "Did they pre-load a note?",
              controller: preloadedNoteController,
            ),
            Tooltip(
              richMessage: WidgetSpan(
                  child: Image.asset(
                "assets/images/intialPositionReference.png",
                height: 150,
              )),
              child: const FormDropdown(title: "Initial position"),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "AUTO",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FormDropdown(
              title: "Do they leave starting zone?",
              controller: autoLeaveStartingZoneController,
            ),
            FormDropdown(
              title: "Note scoring accuracy:",
              listOfItems: const ["Perfect", "Avarage"],
              controller: autoNoteScoringAccuracyController,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormDropdown(
              title: "Did they make fouls?",
              controller: autoFoulsMadeController,
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        AppText(text: "Notes scored in Auto"),
        prettyCounter(
          title: "Notes scored",
          controller: autoNotesOnSpeaker,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "TELEOP",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        FormDropdown(
          title: "Did they make the coopertition bonus?",
          fontSize: 20,
          controller: coopertitionBonusController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "Notes: ",
          fontSize: 40,
          textColor: TextColor.red,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prettyCounter(
              title: "Speaker",
              controller: teleopSpeakerNotesController,
            ),
            const SizedBox(
              width: 20,
            ),
            prettyCounter(
              title: "Amp",
              controller: teleopAmpNotesController,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FormDropdown(
              title: "Speaker scoring accuracy:",
              listOfItems: const ["Perfect", "Avarage"],
              controller: teleopSpeakerAccuracyController,
            ),
            FormDropdown(
              title: "Amp scoring accuracy:",
              listOfItems: const ["Perfect", "Avarage"],
              controller: teleopAmpAccuracyController,
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "AMP",
          fontSize: 40,
          textColor: TextColor.red,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prettyCounter(
              title: "Times amplified",
              controller: teleopTimesAmplifiedController,
            ),
            const SizedBox(
              width: 20,
            ),
            prettyCounter(
              title: "Notes amplified",
              controller: teleopSpeakerAmplifiedController,
            ),
          ],
        ),
        FormDropdown(
          title: "Did they do tactical drop?",
          controller: tacticalDropController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "ENDGAME",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FormDropdown(
              title: "Offense quality?",
              listOfItems: const ["None", "Effective", "Bad"],
              controller: offenseQualityController,
            ),
            FormDropdown(
              title: "Deffense quality?",
              listOfItems: const ["Pinning", "Block", "Zoning"],
              controller: deffenseQualityController,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FormDropdown(
              title: "Climbing speed?",
              listOfItems: const ["Slow", "Fast", "Average"],
              controller: climbingSpeedController,
            ),
            FormDropdown(
              title: "Successful climbing?",
              controller: succesfulClimbingController,
            ),
          ],
        ),
        FormDropdown(
          title: "Spotlit Scored?",
          controller: spotlitController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "POST-MATCH",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FormDropdown(
              title: "Agility?",
              listOfItems: const ["Slow", "Fast", "Average"],
              controller: agilityController,
            ),
            FormDropdown(
              title: "Deffense skills?",
              listOfItems: const ["Good", "Bad", "Excellent"],
              controller: deffenseSkillsController,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FormDropdown(
              title: "Died?",
              controller: diedController,
            ),
            FormDropdown(
              title: "Received a card?",
              controller: recievedACardController,
            ),
          ],
        ),
        FormDropdown(
          title: "HP skills?",
          listOfItems: const ["Aware", "Unaware"],
          controller: hpSkillsController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "FINAL SCORES",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const AppText(
                  text: "Auto:",
                  fontSize: 30,
                  textColor: TextColor.red,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                    hintText: "Auto score", controller: autoScoreController),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Column(
              children: [
                const AppText(
                  text: "Teleop:",
                  fontSize: 30,
                  textColor: TextColor.red,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                    hintText: "Teleop score",
                    controller: teleopScoreController),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const AppText(
                  text: "Final:",
                  fontSize: 30,
                  textColor: TextColor.red,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                    hintText: "Final score", controller: finalScoreController),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Column(
              children: [
                const AppText(
                  text: "Fouls:",
                  fontSize: 30,
                  textColor: TextColor.red,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                    hintText: "Fouls score", controller: foulsScoreController),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const AppText(
          text: "COMMENTS:",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        const AppText(
          text: "Auto:",
          fontSize: 30,
          textColor: TextColor.red,
        ),
        AppTextField(hintText: "Auto", controller: autoCommentsController),
        const AppText(
          text: "Teleop:",
          fontSize: 30,
          textColor: TextColor.red,
        ),
        AppTextField(hintText: "Teleop", controller: teleopCommentsController),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          child: Container(
            //height: 40,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: const AppText(
              text: "Submit",
              fontSize: 40,
            ),
          ),
        ),
      ],
    );
  }

  buildVerticalLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          height: 130,
        ),
        const AppText(
          text: "MATCH INFO",
          fontSize: 40,
          textColor: TextColor.gray,
        ).animate().shake().slide(),
        const SizedBox(
          height: 20,
        ),
        const AppText(
          text: "Team number",
          textColor: TextColor.base,
          fontSize: 20,
        ),
        const SizedBox(
          height: 0,
        ),
        AppTextField(
          onChanged: fetchTeam,
          hintText: "Search team",
          controller: teamNumberController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "Match number",
          textColor: TextColor.base,
          fontSize: 20,
        ),
        const SizedBox(
          height: 0,
        ),
        AppTextField(
          hintText: "Search match",
          controller: matchController,
        ),
        Center(
          child: FormDropdown(
            title: 'Match Type ',
            listOfItems: const ["Qualis", "Practice", "Playoffs"],
            controller: matchTypeController,
          ),
        ),
        FormDropdown(
          title: "Color of their alliance",
          listOfItems: const ["Blue", "Red"],
          controller: allianceColorController,
        ),
        const SizedBox(
          height: 50,
        ),
        const AppText(
          text: "PRE-MATCH",
          fontSize: 40,
          textColor: TextColor.base,
        ),
        FormDropdown(
          title: "Did they pre-load a note?",
          controller: preloadedNoteController,
        ),
        Tooltip(
          richMessage: WidgetSpan(
            child: Image.asset(
              "assets/images/intialPositionReference.png",
              height: 150,
            ),
          ),
          child: FormDropdown(
            title: "Initial position",
            controller: initialPositionController,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "AUTO",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        FormDropdown(
          title: "Do they leave starting zone?",
          controller: autoLeaveStartingZoneController,
        ),
        const SizedBox(
          height: 40,
        ),
        prettyCounter(
          title: "Notes scored",
          controller: autoNotesOnSpeaker,
        ),
        FormDropdown(
          title: "Note scoring accuracy:",
          listOfItems: const ["Perfect", "Average"],
          controller: autoNoteScoringAccuracyController,
        ),
        FormDropdown(
          title: "Did they make fouls?",
          controller: autoFoulsMadeController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "TELEOP",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        FormDropdown(
          title: "Did they make the coopertition bonus?",
          fontSize: 20,
          controller: coopertitionBonusController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "NOTES ON",
          fontSize: 40,
          textColor: TextColor.base,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prettyCounter(
              title: "Speaker",
              controller: teleopSpeakerNotesController,
            ),
            const SizedBox(
              width: 20,
            ),
            prettyCounter(
              title: "Amp",
              controller: teleopAmpNotesController,
            ),
          ],
        ),
        FormDropdown(
          title: "Speaker scoring accuracy:",
          listOfItems: const ["Perfect", "Average"],
          controller: teleopSpeakerAccuracyController,
        ),
        FormDropdown(
          title: "Amp scoring accuracy:",
          listOfItems: const ["Perfect", "Average"],
          controller: teleopAmpAccuracyController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "AMP",
          fontSize: 40,
          textColor: TextColor.red,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prettyCounter(
              title: "Times amplified",
              controller: teleopTimesAmplifiedController,
            ),
            const SizedBox(
              width: 20,
            ),
            prettyCounter(
              title: "Speaker amplified",
              controller: teleopSpeakerAmplifiedController,
            ),
          ],
        ),
        FormDropdown(
          title: "Did they do tactical drop?",
          controller: tacticalDropController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "ENDGAME",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        FormDropdown(
          title: "Offense quality?",
          listOfItems: const ["None", "Effective", "Bad"],
          controller: offenseQualityController,
        ),
        FormDropdown(
          title: "Deffense quality?",
          listOfItems: const ["Pinning", "Block", "Zoning"],
          controller: deffenseQualityController,
        ),
        FormDropdown(
          title: "Climbing speed?",
          listOfItems: const ["Slow", "Fast", "Average"],
          controller: climbingSpeedController,
        ),
        FormDropdown(
          title: "Successful climbing?",
          controller: succesfulClimbingController,
        ),
        FormDropdown(
          title: "Spotlit Scored?",
          controller: spotlitController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "POST-MATCH",
          fontSize: 40,
          textColor: TextColor.gray,
        ),
        FormDropdown(
          title: "Agility?",
          listOfItems: const ["Slow", "Fast", "Average"],
          controller: agilityController,
        ),
        FormDropdown(
          title: "Deffense skills?",
          listOfItems: const ["Good", "Bad", "Excellent"],
          controller: deffenseSkillsController,
        ),
        FormDropdown(
          title: "Died?",
          controller: diedController,
        ),
        FormDropdown(
          title: "Received a card?",
          controller: recievedACardController,
        ),
        FormDropdown(
          title: "HP skills?",
          listOfItems: const ["Aware", "Unaware"],
          controller: hpSkillsController,
        ),
        const SizedBox(
          height: 40,
        ),
        const AppText(
          text: "FINAL SCORES",
          fontSize: 40,
          textColor: TextColor.red,
        ),
        const SizedBox(
          height: 20,
        ),
        const AppText(
          text: "Auto:",
          fontSize: 30,
          textColor: TextColor.base,
        ),
        const SizedBox(
          height: 10,
        ),
        AppTextField(
          hintText: "Auto score",
          controller: autoScoreController,
        ),
        const SizedBox(
          height: 10,
        ),
        const AppText(
          text: "Teleop:",
          fontSize: 30,
          textColor: TextColor.base,
        ),
        const SizedBox(
          height: 10,
        ),
        AppTextField(
          hintText: "Teleop score",
          controller: teleopScoreController,
        ),
        const SizedBox(
          height: 10,
        ),
        const AppText(
          text: "Final:",
          fontSize: 30,
          textColor: TextColor.base,
        ),
        const SizedBox(
          height: 10,
        ),
        AppTextField(
          hintText: "Final score",
          controller: finalScoreController,
        ),
        const SizedBox(
          height: 10,
        ),
        const AppText(
          text: "Fouls:",
          fontSize: 30,
          textColor: TextColor.base,
        ),
        const SizedBox(
          height: 10,
        ),
        AppTextField(
          hintText: "Fouls score",
          controller: foulsScoreController,
        ),
        const SizedBox(
          height: 10,
        ),
        const AppText(
          text: "COMMENTS:",
          fontSize: 40,
          textColor: TextColor.base,
        ),
        const AppText(
          text: "Auto:",
          fontSize: 30,
          textColor: TextColor.base,
        ),
        AppTextField(
          hintText: "Auto",
          controller: autoCommentsController,
        ),
        const AppText(
          text: "Teleop:",
          fontSize: 30,
          textColor: TextColor.base,
        ),
        AppTextField(
          hintText: "Teleop",
          controller: teleopCommentsController,
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async {
            PostState state = await sendMatchScout();
            _showMessage(state);
          },
          child: Container(
            //height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: const AppText(
              text: "Submit",
              fontSize: 40,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            updateQrCode();
          },
          child: Container(
            //height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: const AppText(
              text: "Reload QR",
              fontSize: 25,
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: QrImageView(
            data: qrImageViewData,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
        )
      ],
    ).animate().fade();
  }

  var qrImageViewData = "";

  void updateQrCode() {
    // Call _toCsv() to generate the CSV data
    final csvContent = _toCsv();
    // Update the data property of QrImageView with the new CSV data
    setState(() {
      qrImageViewData = csvContent;
    });
  }

  void  _showMessage(PostState state) {
    final messenger = ScaffoldMessenger.of(context);
    final String title;
    final String message;
    final ContentType contentType;
    if (state == PostState.successful) {
      title = 'Nice!';
      message = "The match was posted";
      contentType = ContentType.success;
    } else if (state == PostState.isDuplicated) {
      title = "U sure?";
      message = "The match is duplicated";
      contentType = ContentType.warning;
    } else {
      title = 'Shoot!!';
      message = "Something went wrong, try again later or save the QR Code";
      contentType = ContentType.failure;
    }
    final snackBar = SnackBar(
        elevation: 0,
        //AppText(text: message, fontSize: 25,),
        content: AwesomeSnackbarContent(
            title: title, message: message, contentType: contentType),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.transparent);
    messenger.showSnackBar(snackBar);
  }

  Future<PostState> sendMatchScout() async {
    var regional = await getCurrentRegional();
    MatchScout matchScout = MatchScout(
        teamNumber: teamNumberController.text,
        teamName: teamTitle,
        match: matchController.text,
        matchType: matchTypeController.text,
        allianceColor: allianceColorController.text,
        preloadedNote: preloadedNoteController.text,
        initialPosition: initialPositionController.text,
        autoLeaveStartingZone: autoLeaveStartingZoneController.text,
        autoNotesOnSpeaker: autoNotesOnSpeaker.text,
        autoNoteScoringAccuracy: autoNoteScoringAccuracyController.text,
        autoFoulsMade: autoFoulsMadeController.text,
        coopertitionBonus: coopertitionBonusController.text,
        teleopSpeakerNotes: teleopSpeakerNotesController.text,
        teleopAmpNotes: teleopAmpNotesController.text,
        teleopSpeakerAccuracy: teleopSpeakerAccuracyController.text,
        teleopAmpAccuracy: teleopAmpAccuracyController.text,
        teleopTimesAmplified: teleopTimesAmplifiedController.text,
        teleopSpeakerAmplified: teleopSpeakerAmplifiedController.text,
        tacticalDrop: tacticalDropController.text,
        offenseQuality: offenseQualityController.text,
        deffenseQuality: deffenseQualityController.text,
        climbingSpeed: climbingSpeedController.text,
        succesfulClimbing: succesfulClimbingController.text,
        spotlit: spotlitController.text,
        agility: agilityController.text,
        deffenseSkills: deffenseSkillsController.text,
        died: diedController.text,
        recievedACard: recievedACardController.text,
        hpSkills: hpSkillsController.text,
        autoScore: autoScoreController.text,
        teleopScore: teleopScoreController.text,
        finalScore: finalScoreController.text,
        foulsScore: foulsScoreController.text,
        autoComments: autoCommentsController.text,
        teleopComments: teleopCommentsController.text);

    PostState state = await ScoutService().sendMatchScout(matchScout, regional);
    return state;
  }

  Map<String, dynamic> _toJson() {
    return {
      'teamNumber': teamNumberController.text,
      'match': matchController.text,
      'matchType': matchTypeController.text,
      'allianceColor': allianceColorController.text,
      'preloadedNote': preloadedNoteController.text,
      'initialPosition': initialPositionController.text,
      'autoLeaveStartingZone': autoLeaveStartingZoneController.text,
      'autoNotesOnSpeaker': autoNotesOnSpeaker.text,
      'autoNoteScoringAccuracy': autoNoteScoringAccuracyController.text,
      'autoFoulsMade': autoFoulsMadeController.text,
      'coopertitionBonus': coopertitionBonusController.text,
      'teleopSpeakerNotes': teleopSpeakerNotesController.text,
      'teleopAmpNotes': teleopAmpNotesController.text,
      'teleopSpeakerAccuracy': teleopSpeakerAccuracyController.text,
      'teleopAmpAccuracy': teleopAmpAccuracyController.text,
      'teleopTimesAmplified': teleopTimesAmplifiedController.text,
      'teleopSpeakerAmplified': teleopSpeakerAmplifiedController.text,
      'tacticalDrop': tacticalDropController.text,
      'offenseQuality': offenseQualityController.text,
      'deffenseQuality': deffenseQualityController.text,
      'climbingSpeed': climbingSpeedController.text,
      'successfulClimbing': succesfulClimbingController.text,
      'spotlit': spotlitController.text,
      'agility': agilityController.text,
      'deffenseSkills': deffenseSkillsController.text,
      'died': diedController.text,
      'receivedACard': recievedACardController.text,
      'hpSkills': hpSkillsController.text,
      'autoScore': autoScoreController.text,
      'teleopScore': teleopScoreController.text,
      'finalScore': finalScoreController.text,
      'foulsScore': foulsScoreController.text,
      'autoComments': autoCommentsController.text,
      'teleopComments': teleopCommentsController.text,
    };
  }

  String _toCsv() {
    // Get the data from _toJson
    final data = _toJson();

    // Create a list to store CSV rows
    final rows = [];

    // Loop through each value in data
    for (var value in data.values) {
      // Escape any commas in the value for proper CSV format
      final escapedValue = value.toString().replaceAll(',', ' ');
      rows.add('"$escapedValue"');
    }

    // Combine rows with line breaks
    final csvContent = rows.join('\n');

    return csvContent;
  }
}
