/// Karma action types for tracking earning and spending
class KarmaAction {
  // Earning actions
  static const String dailyLogin = 'daily_login';
  static const String completeStepGoal = 'complete_step_goal';
  static const String logAllMeals = 'log_all_meals';
  static const String drink8GlassesWater = 'drink_8_glasses_water';
  static const String completeWorkout = 'complete_workout';
  static const String logWeightWeekly = 'log_weight_weekly';
  static const String streak7Days = 'streak_7_days';
  static const String streak30Days = 'streak_30_days';
  
  // Community actions
  static const String postToFeed = 'post_to_feed';
  static const String get10Likes = 'get_10_likes';
  static const String commentOnPost = 'comment_on_post';
  static const String shareTransformation = 'share_transformation';
  static const String helpInCommunity = 'help_in_community';
  
  // Challenges
  static const String completeWeeklyChallenge = 'complete_weekly_challenge';
  static const String winMonthlyChallenge = 'win_monthly_challenge';
  static const String participateInEvent = 'participate_in_event';
  
  // Special
  static const String referFriend = 'refer_friend';
  static const String referFriendSubscribes = 'refer_friend_subscribes';
  static const String addFoodToDatabase = 'add_food_to_database';
  static const String reportBug = 'report_bug';
  static const String firstWorkout = 'first_workout';
  static const String completeOnboarding = 'complete_onboarding';
  
  // Redeeming (spending)
  static const String unlockAdvancedAnalytics = 'unlock_advanced_analytics';
  static const String unlockMealPlan = 'unlock_meal_plan';
  static const String unlockExpertChat = 'unlock_expert_chat';
  static const String createCustomChallenge = 'create_custom_challenge';
  static const String adFreeMonth = 'ad_free_month';
  static const String allWorkoutVideos = 'all_workout_videos';
  static const String recipeEbook = 'recipe_ebook';
  static const String festivalGuide = 'festival_guide';
  
  // Karma values for each action
  static int getKarmaValue(String action) {
    switch (action) {
      // Earning
      case dailyLogin: return 5;
      case completeStepGoal: return 10;
      case logAllMeals: return 15;
      case drink8GlassesWater: return 5;
      case completeWorkout: return 20;
      case logWeightWeekly: return 10;
      case streak7Days: return 50;
      case streak30Days: return 200;
      
      // Community
      case postToFeed: return 5;
      case get10Likes: return 10;
      case commentOnPost: return 2;
      case shareTransformation: return 50;
      case helpInCommunity: return 15;
      
      // Challenges
      case completeWeeklyChallenge: return 50;
      case winMonthlyChallenge: return 200;
      case participateInEvent: return 25;
      
      // Special
      case referFriend: return 100;
      case referFriendSubscribes: return 300;
      case addFoodToDatabase: return 5;
      case reportBug: return 20;
      case firstWorkout: return 10;
      case completeOnboarding: return 50;
      
      // Redeeming (spending)
      case unlockAdvancedAnalytics: return 100;
      case unlockMealPlan: return 150;
      case unlockExpertChat: return 400;
      case createCustomChallenge: return 100;
      case adFreeMonth: return 200;
      case allWorkoutVideos: return 100;
      case recipeEbook: return 150;
      case festivalGuide: return 50;
      
      default: return 0;
    }
  }
  
  // Check if action is earning (positive) or spending (negative)
  static bool isEarning(String action) {
    final earningActions = [
      dailyLogin, completeStepGoal, logAllMeals, drink8GlassesWater,
      completeWorkout, logWeightWeekly, streak7Days, streak30Days,
      postToFeed, get10Likes, commentOnPost, shareTransformation,
      helpInCommunity, completeWeeklyChallenge, winMonthlyChallenge,
      participateInEvent, referFriend, referFriendSubscribes,
      addFoodToDatabase, reportBug, firstWorkout, completeOnboarding,
    ];
    return earningActions.contains(action);
  }
  
  // Get display name for action
  static String getDisplayName(String action) {
    switch (action) {
      case dailyLogin: return 'Daily Login';
      case completeStepGoal: return 'Step Goal Complete';
      case logAllMeals: return 'All Meals Logged';
      case drink8GlassesWater: return 'Water Goal Hit';
      case completeWorkout: return 'Workout Complete';
      case logWeightWeekly: return 'Weight Logged';
      case streak7Days: return '7-Day Streak Bonus';
      case streak30Days: return '30-Day Streak Bonus';
      case postToFeed: return 'Post to Community';
      case get10Likes: return '10 Likes on Post';
      case commentOnPost: return 'Comment on Post';
      case shareTransformation: return 'Transformation Story';
      case helpInCommunity: return 'Help Community Member';
      case completeWeeklyChallenge: return 'Weekly Challenge Complete';
      case winMonthlyChallenge: return 'Monthly Challenge Winner';
      case participateInEvent: return 'Event Participation';
      case referFriend: return 'Friend Referral';
      case referFriendSubscribes: return 'Friend Subscribed';
      case addFoodToDatabase: return 'Add Food Item';
      case reportBug: return 'Bug Report';
      case firstWorkout: return 'First Workout';
      case completeOnboarding: return 'Onboarding Complete';
      case unlockAdvancedAnalytics: return 'Unlock Advanced Analytics';
      case unlockMealPlan: return 'Unlock Meal Plan';
      case unlockExpertChat: return 'Unlock Expert Chat';
      case createCustomChallenge: return 'Create Custom Challenge';
      case adFreeMonth: return 'Ad-Free Month';
      case allWorkoutVideos: return 'All Workout Videos';
      case recipeEbook: return 'Recipe eBook';
      case festivalGuide: return 'Festival Guide';
      default: return action;
    }
  }
}
