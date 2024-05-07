import 'package:chat_app/models/match_scout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchScoutSender{
  final String senderId;
  final String senderEmail;
  final MatchScout matchScout;
  final Timestamp timestamp;

  MatchScoutSender({required this.senderId, required this.senderEmail, required this.matchScout, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'timestamp': timestamp,
      'teamNumber': matchScout.teamNumber,
      'teamName': matchScout.teamName,
      'match': matchScout.match,
      'matchType': matchScout.matchType,
      'allianceColor': matchScout.allianceColor,
      'preloadedNote': matchScout.preloadedNote,
      'initialPosition': matchScout.initialPosition,
      'autoLeaveStartingZone': matchScout.autoLeaveStartingZone,
      'autoNotesOnSpeaker': matchScout.autoNotesOnSpeaker,
      'autoNoteScoringAccuracy': matchScout.autoNoteScoringAccuracy,
      'autoFoulsMade': matchScout.autoFoulsMade,
      'coopertitionBonus': matchScout.coopertitionBonus,
      'teleopSpeakerNotes': matchScout.teleopSpeakerNotes,
      'teleopAmpNotes': matchScout.teleopAmpNotes,
      'teleopSpeakerAccuracy': matchScout.teleopSpeakerAccuracy,
      'teleopAmpAccuracy': matchScout.teleopAmpAccuracy,
      'teleopTimesAmplified': matchScout.teleopTimesAmplified,
      'teleopSpeakerAmplified': matchScout.teleopSpeakerAmplified,
      'tacticalDrop': matchScout.tacticalDrop,
      'offenseQuality': matchScout.offenseQuality,
      'deffenseQuality': matchScout.deffenseQuality,
      'climbingSpeed': matchScout.climbingSpeed,
      'successfulClimbing': matchScout.succesfulClimbing,
      'spotlit': matchScout.spotlit,
      'agility': matchScout.agility,
      'deffenseSkills': matchScout.deffenseSkills,
      'died': matchScout.died,
      'receivedACard': matchScout.recievedACard,
      'hpSkills': matchScout.hpSkills,
      'autoScore': matchScout.autoScore,
      'teleopScore': matchScout.teleopScore,
      'finalScore': matchScout.finalScore,
      'foulsScore': matchScout.foulsScore,
      'autoComments': matchScout.autoComments,
      'teleopComments': matchScout.teleopComments,
    };
  }
}