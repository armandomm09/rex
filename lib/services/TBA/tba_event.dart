


class TBAEventService {

    
  getEventsStream(String year) async {
  var apiKey =
      "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
  var url = "https://www.thebluealliance.com/api/v3/events/$year";

  try {
    final response = await httpp.get(
      Uri.parse(url),
      headers: {'X-TBA-Auth-Key': apiKey},
    );

    if (response.statusCode == 200) {
      allEvents = jsonDecode(response.body) as List<dynamic>;

      // Prioritize Championship events (combine conditions for efficiency)
      final prioritizedEvents = allEvents.where((event) =>
          event['event_type_string'] == "Championship Division" ||
          event['event_type_string'] == "Championship Finals").toList();

      // Add remaining events
      prioritizedEvents.addAll(allEvents.where((event) =>
          event['event_type_string'] != "Championship Division" &&
          event['event_type_string'] != "Championship Finals").toList());

      setState(() {
        allEvents = prioritizedEvents;
        filteredEvents = prioritizedEvents;
      });
   
    } else {
      print("Failed to load events: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching events: $e");
  }
}

    getTeamsStream() async {
    var apiKey =
        "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
    var url = "https://www.thebluealliance.com/api/v3/event/${widget.eventCode}/teams";
    try {
      final response = await httpp.get(
        Uri.parse(url),
        headers: {'X-TBA-Auth-Key': apiKey},
      );

      if (response.statusCode == 200) {
        setState(() {
          allTeams = jsonDecode(response.body);
          filteredTeams = allTeams;
        });
      } else {
        print("Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }
  
  
}
