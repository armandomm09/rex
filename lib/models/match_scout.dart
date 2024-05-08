
class MatchScout {

  final String teamNumber;
  final String teamName;
  final String match;
  final String matchType;
  final String allianceColor;

  final String preloadedNote;
  final String initialPosition;

  final String autoLeaveStartingZone;
  final String autoNotesOnSpeaker;
  final String autoNoteScoringAccuracy;
  final String autoFoulsMade;

  final String coopertitionBonus;
  final String teleopSpeakerNotes;
  final String teleopAmpNotes;
  final String teleopSpeakerAccuracy;
  final String teleopAmpAccuracy;
  final String teleopTimesAmplified;
  final String teleopSpeakerAmplified;
  final String tacticalDrop;

  final String offenseQuality;
  final String deffenseQuality;
  final String climbingSpeed;
  final String succesfulClimbing;
  final String spotlit;

  final String agility;
  final String deffenseSkills;
  final String died;
  final String recievedACard;
  final String hpSkills;

  final String autoScore;
  final String teleopScore;
  final String finalScore;
  final String foulsScore;

  final String autoComments;
  final String teleopComments;


  MatchScout({required this.teamNumber, required this.teamName, required this.match, required this.matchType, required this.allianceColor, required this.preloadedNote, required this.initialPosition, required this.autoLeaveStartingZone, required this.autoNotesOnSpeaker, required this.autoNoteScoringAccuracy, required this.autoFoulsMade, required this.coopertitionBonus, required this.teleopSpeakerNotes, required this.teleopAmpNotes, required this.teleopSpeakerAccuracy, required this.teleopAmpAccuracy, required this.teleopTimesAmplified, required this.teleopSpeakerAmplified, required this.tacticalDrop, required this.offenseQuality, required this.deffenseQuality, required this.climbingSpeed, required this.succesfulClimbing, required this.spotlit, required this.agility, required this.deffenseSkills, required this.died, required this.recievedACard, required this.hpSkills, required this.autoScore, required this.teleopScore, required this.finalScore, required this.foulsScore, required this.autoComments, required this.teleopComments});

  Map<String, dynamic> _toJson() {
    return {
      'teamNumber': teamNumber,
      'teamName': teamName,
      'match': match,
      'matchType': matchType,
      'allianceColor': allianceColor,
      'preloadedNote': preloadedNote,
      'initialPosition': initialPosition,
      'autoLeaveStartingZone': autoLeaveStartingZone,
      'autoNotesOnSpeaker': autoNotesOnSpeaker,
      'autoNoteScoringAccuracy': autoNoteScoringAccuracy, 
      'autoFoulsMade': autoFoulsMade,
      'coopertitionBonus': coopertitionBonus,
      'teleopSpeakerNotes': teleopSpeakerNotes,
      'teleopAmpNotes': teleopAmpNotes,
      'teleopSpeakerAccuracy': teleopSpeakerAccuracy,
      'teleopAmpAccuracy': teleopAmpAccuracy,
      'teleopTimesAmplified': teleopTimesAmplified,
      'teleopSpeakerAmplified': teleopSpeakerAmplified,
      'tacticalDrop': tacticalDrop,
      'offenseQuality': offenseQuality,
      'deffenseQuality': deffenseQuality,
      'climbingSpeed': climbingSpeed,
      'successfulClimbing': succesfulClimbing,
      'spotlit': spotlit,
      'agility': agility,
      'deffenseSkills': deffenseSkills,
      'died': died,
      'receivedACard': recievedACard,
      'hpSkills': hpSkills,
      'autoScore': autoScore,
      'teleopScore': teleopScore,
      'finalScore': finalScore,
      'foulsScore': foulsScore,
      'autoComments': autoComments,
      'teleopComments': teleopComments,
    };
  }
}