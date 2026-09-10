import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/club_models.dart';

final localClubsProvider =
    StateNotifierProvider<LocalClubsNotifier, LocalClubsState>((ref) {
  return LocalClubsNotifier();
});

class LocalClubsNotifier extends StateNotifier<LocalClubsState> {
  LocalClubsNotifier() : super(_buildInitialState());

  static LocalClubsState _buildInitialState() {
    final clubs = [
      LocalGeoClub(
        id: 'club_koramangala',
        name: 'Koramangala Morning Sadhana Circle',
        regionalName: 'कोरमंगला प्रभात साधना मंडल',
        landmarkArea: 'Koramangala 4th Block',
        city: 'Bengaluru',
        latitude: 12.9352,
        longitude: 77.6245,
        distanceFromUserKm: 0.8,
        primaryActivity: ClubActivityType.shatpawaliAndWalk,
        activeMembersCount: 142,
        weeklyCollectiveSteps: 6420000,
        isUserJoined: true,
        nextMeetup: ClubMeetupEvent(
          id: 'meetup_1',
          clubId: 'club_koramangala',
          title: 'Sunday Sunrise 100-Step Shatpawali & Pranayama',
          regionalTitle: 'रविवार सूर्योदय शतपावली व प्राणायाम मिलन',
          venueName: 'Iblur Park & Lake Track, Bengaluru',
          scheduledAt: DateTime.now().add(const Duration(days: 2, hours: 9)),
          rsvpCount: 28,
          isUserRsvpd: true,
          organizerName: 'Capt. Rajesh Nair',
        ),
      ),
      LocalGeoClub(
        id: 'club_indiranagar',
        name: 'Indiranagar 100-Ft Calisthenics Guild',
        regionalName: 'इंदिरानगर देसी शक्ति मंडल',
        landmarkArea: 'Indiranagar 100-Ft Road',
        city: 'Bengaluru',
        latitude: 12.9719,
        longitude: 77.6412,
        distanceFromUserKm: 2.6,
        primaryActivity: ClubActivityType.desiCalisthenics,
        activeMembersCount: 88,
        weeklyCollectiveSteps: 4120000,
        isUserJoined: false,
        nextMeetup: ClubMeetupEvent(
          id: 'meetup_2',
          clubId: 'club_indiranagar',
          title: 'Desi Baithak & Bodyweight Overload Workshop',
          regionalTitle: 'देसी बैठक व शक्ति कार्यशाला',
          venueName: 'Defense Colony Park, Indiranagar',
          scheduledAt: DateTime.now().add(const Duration(days: 3, hours: 10)),
          rsvpCount: 19,
          isUserRsvpd: false,
          organizerName: 'Coach Vikram Rajput',
        ),
      ),
      LocalGeoClub(
        id: 'club_cubbon',
        name: 'Cubbon Park Weekend Runners & Walkers',
        regionalName: 'कब्बन पार्क सप्ताहांत धावक संघ',
        landmarkArea: 'Cubbon Park Central',
        city: 'Bengaluru',
        latitude: 12.9763,
        longitude: 77.5929,
        distanceFromUserKm: 4.8,
        primaryActivity: ClubActivityType.runningAndCardio,
        activeMembersCount: 310,
        weeklyCollectiveSteps: 14800000,
        isUserJoined: true,
        nextMeetup: ClubMeetupEvent(
          id: 'meetup_3',
          clubId: 'club_cubbon',
          title: '5km Green Canopy Trail Walk & Run',
          regionalTitle: '५ किमी हरित पथ यात्रा',
          venueName: 'Bamboo Grove Entrance, Cubbon Park',
          scheduledAt: DateTime.now().add(const Duration(days: 2, hours: 8)),
          rsvpCount: 64,
          isUserRsvpd: true,
          organizerName: 'Dr. Suresh Rao',
        ),
      ),
      const LocalGeoClub(
        id: 'club_hsr',
        name: 'HSR Layout Sector 2 Yoga & Shatpawali',
        regionalName: 'एचएसआर लेआउट योग व शतपावली',
        landmarkArea: 'HSR Sector 2 Park',
        city: 'Bengaluru',
        latitude: 12.9116,
        longitude: 77.6474,
        distanceFromUserKm: 3.9,
        primaryActivity: ClubActivityType.yogaPranayama,
        activeMembersCount: 96,
        weeklyCollectiveSteps: 4890000,
        isUserJoined: false,
      ),
    ];

    return LocalClubsState(
      selectedRadiusKm: 5.0,
      userCurrentLocationLabel: 'Koramangala, Bengaluru (Tier 1)',
      allClubs: clubs,
    );
  }

  void updateRadius(double radiusKm) {
    state = state.copyWith(selectedRadiusKm: radiusKm);
  }

  void toggleJoinClub(String clubId) {
    final updated = state.allClubs.map((c) {
      if (c.id == clubId) {
        final currentlyJoined = c.isUserJoined;
        return c.copyWith(
          isUserJoined: !currentlyJoined,
          activeMembersCount: currentlyJoined
              ? c.activeMembersCount - 1
              : c.activeMembersCount + 1,
        );
      }
      return c;
    }).toList();

    state = state.copyWith(allClubs: updated);
  }

  void toggleMeetupRsvp(String clubId, String meetupId) {
    final updated = state.allClubs.map((c) {
      if (c.id == clubId &&
          c.nextMeetup != null &&
          c.nextMeetup!.id == meetupId) {
        final meetup = c.nextMeetup!;
        final currentRsvp = meetup.isUserRsvpd;
        final updatedMeetup = meetup.copyWith(
          isUserRsvpd: !currentRsvp,
          rsvpCount: currentRsvp ? meetup.rsvpCount - 1 : meetup.rsvpCount + 1,
        );
        return c.copyWith(nextMeetup: updatedMeetup);
      }
      return c;
    }).toList();

    state = state.copyWith(allClubs: updated);
  }
}
