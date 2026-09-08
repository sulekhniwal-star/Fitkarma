import 'package:flutter/foundation.dart';

/// Activity discipline focus of the local club
enum ClubActivityType {
  shatpawaliAndWalk(
    label: 'Shatpawali & Morning Strolls',
    regionalLabel: 'शतपावली व प्रातः भ्रमण',
    iconName: 'directions_walk',
    colorCode: 0xFF00E676,
  ),
  runningAndCardio(
    label: 'Running & VO2 Max Strides',
    regionalLabel: 'दौड़ व हृदय सहनशक्ति',
    iconName: 'directions_run',
    colorCode: 0xFF00B0FF,
  ),
  desiCalisthenics(
    label: 'Desi Baithak & Calisthenics',
    regionalLabel: 'देसी बैठक व व्यायाम',
    iconName: 'fitness_center',
    colorCode: 0xFFFFD700,
  ),
  yogaPranayama(
    label: 'Park Yoga & Surya Namaskar',
    regionalLabel: 'उद्यान योग व सूर्य नमस्कार',
    iconName: 'self_improvement',
    colorCode: 0xFFFF9100,
  );

  final String label;
  final String regionalLabel;
  final String iconName;
  final int colorCode;

  const ClubActivityType({
    required this.label,
    required this.regionalLabel,
    required this.iconName,
    required this.colorCode,
  });
}

/// Scheduled offline physical meetup organized by a local club
@immutable
class ClubMeetupEvent {
  final String id;
  final String clubId;
  final String title;
  final String regionalTitle;
  final String venueName; // e.g. "Cubbon Park Bamboo Grove, Bengaluru"
  final DateTime scheduledAt;
  final int rsvpCount;
  final bool isUserRsvpd;
  final String organizerName;

  const ClubMeetupEvent({
    required this.id,
    required this.clubId,
    required this.title,
    required this.regionalTitle,
    required this.venueName,
    required this.scheduledAt,
    required this.rsvpCount,
    required this.isUserRsvpd,
    required this.organizerName,
  });

  ClubMeetupEvent copyWith({
    bool? isUserRsvpd,
    int? rsvpCount,
  }) {
    return ClubMeetupEvent(
      id: id,
      clubId: clubId,
      title: title,
      regionalTitle: regionalTitle,
      venueName: venueName,
      scheduledAt: scheduledAt,
      rsvpCount: rsvpCount ?? this.rsvpCount,
      isUserRsvpd: isUserRsvpd ?? this.isUserRsvpd,
      organizerName: organizerName,
    );
  }
}

/// Geolocation Local Club (Kshetra Mandala)
@immutable
class LocalGeoClub {
  final String id;
  final String name;
  final String regionalName;
  final String landmarkArea; // e.g. "Koramangala 4th Block"
  final String city; // "Bengaluru"
  final double latitude;
  final double longitude;
  final double distanceFromUserKm;
  final ClubActivityType primaryActivity;
  final int activeMembersCount;
  final int weeklyCollectiveSteps;
  final bool isUserJoined;
  final ClubMeetupEvent? nextMeetup;

  const LocalGeoClub({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.landmarkArea,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.distanceFromUserKm,
    required this.primaryActivity,
    required this.activeMembersCount,
    required this.weeklyCollectiveSteps,
    required this.isUserJoined,
    this.nextMeetup,
  });

  LocalGeoClub copyWith({
    bool? isUserJoined,
    int? activeMembersCount,
    ClubMeetupEvent? nextMeetup,
  }) {
    return LocalGeoClub(
      id: id,
      name: name,
      regionalName: regionalName,
      landmarkArea: landmarkArea,
      city: city,
      latitude: latitude,
      longitude: longitude,
      distanceFromUserKm: distanceFromUserKm,
      primaryActivity: primaryActivity,
      activeMembersCount: activeMembersCount ?? this.activeMembersCount,
      weeklyCollectiveSteps: weeklyCollectiveSteps,
      isUserJoined: isUserJoined ?? this.isUserJoined,
      nextMeetup: nextMeetup ?? this.nextMeetup,
    );
  }
}

/// State for Local Clubs Screen
@immutable
class LocalClubsState {
  final double selectedRadiusKm;
  final String userCurrentLocationLabel;
  final List<LocalGeoClub> allClubs;

  const LocalClubsState({
    required this.selectedRadiusKm,
    required this.userCurrentLocationLabel,
    required this.allClubs,
  });

  LocalClubsState copyWith({
    double? selectedRadiusKm,
    String? userCurrentLocationLabel,
    List<LocalGeoClub>? allClubs,
  }) {
    return LocalClubsState(
      selectedRadiusKm: selectedRadiusKm ?? this.selectedRadiusKm,
      userCurrentLocationLabel: userCurrentLocationLabel ?? this.userCurrentLocationLabel,
      allClubs: allClubs ?? this.allClubs,
    );
  }
}
