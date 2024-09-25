


class TBAEventService {

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
