import 'dart:async';
import 'dart:convert';

import 'package:endava_profile_app/modules/education/models/progressable_achievement.dart';
import 'package:endava_profile_app/modules/education/models/textual_achievement.dart';
import 'package:endava_profile_app/modules/education/models/achievements.dart';

class AchievementsChangesController {
  /*Data changed*/
  StreamController<TextualAchievement> qualificationsController = StreamController<TextualAchievement>();
  StreamController<TextualAchievement> certificatesController = StreamController<TextualAchievement>();
  StreamController<ProgressableAchievement> langaugesController = StreamController<ProgressableAchievement>();

  TextualAchievement currentQualifications;
  TextualAchievement currentCertificates;
  ProgressableAchievement currentLanguages;

  Sink<TextualAchievement> get qualificationsSink => qualificationsController.sink;
  Sink<TextualAchievement> get certificatesSink => certificatesController.sink;
  Sink<ProgressableAchievement> get langaugesSink => langaugesController.sink;

  AchievementsChangesController() {
    qualificationsController.stream.listen((qualification) {
      currentQualifications = qualification;
      print("Current qualification ${currentQualifications.toJson()}");
    });

    certificatesController.stream.listen((certificates) {
      currentCertificates = certificates;
      print("Current qualification ${currentCertificates.toJson()}");
    });

    langaugesController.stream.listen((languages) {
      currentLanguages = languages;
      print("Current languages ${jsonEncode(currentLanguages)}");
    });
  }

  Achievements getCurrentAchievements() {
    return Achievements(
      qualifications: currentQualifications,
      certificates: currentCertificates,
      languages: currentLanguages,
    );
  }

  dispose() {
    qualificationsController.close();
    certificatesController.close();
    langaugesController.close();
  }

  void setInitialAchievements(Achievements achievements) {
    currentQualifications = achievements.qualifications;
    currentCertificates = achievements.certificates;
    currentLanguages = achievements.languages;
  }
}
