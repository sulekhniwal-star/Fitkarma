import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/community_models.dart';

class CommunitiesState {
  final CommunityCategory? selectedCategory;
  final bool showJoinedOnly;
  final List<AccountabilityCommunity> allCommunities;

  const CommunitiesState({
    this.selectedCategory,
    required this.showJoinedOnly,
    required this.allCommunities,
  });

  CommunitiesState copyWith({
    CommunityCategory? selectedCategory,
    bool? clearCategory,
    bool? showJoinedOnly,
    List<AccountabilityCommunity>? allCommunities,
  }) {
    return CommunitiesState(
      selectedCategory: clearCategory == true ? null : selectedCategory ?? this.selectedCategory,
      showJoinedOnly: showJoinedOnly ?? this.showJoinedOnly,
      allCommunities: allCommunities ?? this.allCommunities,
    );
  }
}

final communitiesProvider =
    StateNotifierProvider<CommunitiesNotifier, CommunitiesState>((ref) {
  return CommunitiesNotifier();
});

class CommunitiesNotifier extends StateNotifier<CommunitiesState> {
  CommunitiesNotifier() : super(_buildInitialState());

  static CommunitiesState _buildInitialState() {
    const drSharma = CommunityMentor(
      id: 'mentor_dr_sharma',
      name: 'Dr. Vaidya Ramesh Sharma',
      regionalName: 'डॉ. वैद्य रमेश शर्मा',
      title: 'Senior Ayurvedic Physician & Metabolic Specialist (BAMS)',
      avatarUrl: '',
      rating: 4.9,
      verifiedAnswersCount: 342,
    );

    const coachVikram = CommunityMentor(
      id: 'mentor_coach_vikram',
      name: 'Vikram Rajput, CSCS',
      regionalName: 'विक्रम राजपूत',
      title: 'Head Strength & Biomechanics Coach',
      avatarUrl: '',
      rating: 4.95,
      verifiedAnswersCount: 480,
    );

    final initialCommunities = [
      AccountabilityCommunity(
        id: 'comm_shatpawali',
        name: '100-Step Shatpawali Sadhana Circle',
        regionalName: 'शतपावली साधना मंडल (१०,०००+ साधक)',
        category: CommunityCategory.dailyMovement,
        manifesto: 'We honor post-meal digestion through conscious, mindful Shatpawali strolls.',
        regionalManifesto: 'हम भोजनोपरांत शतपावली द्वारा पाचन अग्नि व स्वास्थ्य की रक्षा करते हैं।',
        activeMembersCount: 4250,
        communityPulseScore: 94.2,
        totalCollectiveKarma: 84500,
        isUserJoined: true,
        leadMentor: drSharma,
        activeThreads: [
          CommunityDiscussionThread(
            id: 'thread_1',
            communityId: 'comm_shatpawali',
            authorName: 'Aditi Rao',
            authorKarmaTier: 'Vanguard',
            title: 'Is 100 steps sufficient after a heavy Dal-Bhat dinner?',
            regionalTitle: 'क्या भारी भोजन के बाद १०० कदम पर्याप्त हैं?',
            body: 'I usually do 500-1000 gentle steps. Should pace be slow or moderate?',
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
            repliesCount: 14,
            upvotesCount: 42,
            hasVerifiedMentorReply: true,
            topAnswerSnippet: 'Dr. Sharma: 100 gentle steps (Shatpawali) is the minimum Vedic baseline. 10-15 mins of slow unhurried strolling enhances gastric emptying by 28%.',
          ),
        ],
        knowledgeVault: const [
          CommunityKnowledgeResource(
            id: 'res_1',
            title: 'Ayurvedic Meal Sequencing & Post-Meal Protocol',
            regionalTitle: 'भोजनोपरांत शतपावली व आहार नियम',
            durationOrPages: '6 min read',
            resourceType: 'Protocol Guide',
            karmaToUnlock: 0,
            isUnlocked: true,
          ),
        ],
      ),
      AccountabilityCommunity(
        id: 'comm_glucose',
        name: 'Insulin Sensitivity & Pre-Diabetes Reversal',
        regionalName: 'मधुमेह मुक्ति व इंसुलिन संवेदनशीलता मंडल',
        category: CommunityCategory.cardiometabolic,
        manifesto: 'Reversing cardiometabolic risk and flattening postprandial glucose spikes naturally.',
        regionalManifesto: 'आहार, शतपावली व शक्ति संवर्धन से ग्लूकोज स्तर को संतुलित करना।',
        activeMembersCount: 2890,
        communityPulseScore: 89.5,
        totalCollectiveKarma: 62000,
        isUserJoined: true,
        leadMentor: drSharma,
        activeThreads: [
          CommunityDiscussionThread(
            id: 'thread_2',
            communityId: 'comm_glucose',
            authorName: 'Sanjay Gupta',
            authorKarmaTier: 'Pacesetter',
            title: 'My estimated HbA1c dropped from 5.9 to 5.4 in 8 weeks!',
            regionalTitle: 'मेरा HbA1c स्तर ५.९ से ५.४ पर आया!',
            body: 'Combining Sattu/Paneer protein breakfast with post-dinner walking did wonders.',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
            repliesCount: 28,
            upvotesCount: 88,
            hasVerifiedMentorReply: true,
            topAnswerSnippet: 'Coach Vikram: Consistent muscle contraction acts as an insulin-independent glucose sink. Outstanding work!',
          ),
        ],
        knowledgeVault: const [
          CommunityKnowledgeResource(
            id: 'res_2',
            title: 'Low-Glycemic South Asian Meal Plate Blueprint',
            regionalTitle: 'कम ग्लाइसेमिक भारतीय भोजन थाली मार्गदर्शिका',
            durationOrPages: '12 pages',
            resourceType: 'Meal Template',
            karmaToUnlock: 50,
            isUnlocked: true,
          ),
        ],
      ),
      const AccountabilityCommunity(
        id: 'comm_strength',
        name: 'Desi Strength & Calisthenics Guild',
        regionalName: 'देसी शक्ति व व्यायाम मंडल',
        category: CommunityCategory.desiStrength,
        manifesto: 'Forging explosive relative strength with Baithak, Dands, and Barbell fundamentals.',
        regionalManifesto: 'देसी दंड, बैठक व बारबेल व्यायाम द्वारा अभेद्य शक्ति का निर्माण।',
        activeMembersCount: 3410,
        communityPulseScore: 91.8,
        totalCollectiveKarma: 78000,
        isUserJoined: false,
        leadMentor: coachVikram,
        activeThreads: [],
        knowledgeVault: [
          CommunityKnowledgeResource(
            id: 'res_3',
            title: 'Mastering the Traditional Desi Baithak Mechanics',
            regionalTitle: 'पारंपरिक देसी बैठक तकनीक व सुरक्षा',
            durationOrPages: '8 min video',
            resourceType: 'Video Flow',
            karmaToUnlock: 100,
            isUnlocked: false,
          ),
        ],
      ),
    ];

    return CommunitiesState(
      showJoinedOnly: false,
      allCommunities: initialCommunities,
    );
  }

  void selectCategory(CommunityCategory? category) {
    if (state.selectedCategory == category) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
  }

  void toggleJoinedOnly(bool value) {
    state = state.copyWith(showJoinedOnly: value);
  }

  void toggleJoinCommunity(String communityId) {
    final updated = state.allCommunities.map((c) {
      if (c.id == communityId) {
        final currentlyJoined = c.isUserJoined;
        return c.copyWith(
          isUserJoined: !currentlyJoined,
          activeMembersCount: currentlyJoined ? c.activeMembersCount - 1 : c.activeMembersCount + 1,
        );
      }
      return c;
    }).toList();

    state = state.copyWith(allCommunities: updated);
  }
}
