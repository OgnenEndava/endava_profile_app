import 'package:endava_profile_app/modules/education/components/achievement/progressable/progress_skill_card.dart';
import 'package:endava_profile_app/modules/education/models/progressable_achievement.dart';
import 'package:flutter/material.dart';

import '../base_achievement_card_state.dart';

class ProgressAchievementCard extends StatefulWidget {
  final ProgressableAchievement data;
  final Function(ProgressableAchievement) onDataChanged;

  ProgressAchievementCard({@required this.data, @required this.onDataChanged});

  @override
  _ProgressAchievementCardState createState() => _ProgressAchievementCardState();
}

class _ProgressAchievementCardState extends BaseAchievementCardState<ProgressAchievementCard> {
  List<ProgressableItem> items = List();
  bool isAddNewSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.data.items != null && widget.data.items.isNotEmpty) {
      items = widget.data.items;
    }
  }

  @override
  List<Widget> getChildrenContent() {
    return [
      getHeader(widget.data.title),
      getItemsList(items),
      getAddNewItemButton(),
    ];
  }

  @override
  Widget createListItem(BuildContext context, int index) {
    return ProgressSkillCard(
      data: items[index],
      onNewLevelSelected: (updatedProgresseableItem) => onDataChanged(updatedProgresseableItem, "progress changed"),
    );
  }

  @override
  GestureTapCallback onAddNewItemCallback() {
    return () {
      /**TODO
       * Launch Language selector
       * Call onNewItemAdded() with the newly selected language
       */
      onNewItemAdded(ProgressableItem(
          name: "English",
          image:
              "https://library.kissclipart.com/20180928/pvw/kissclipart-british-flag-1820-clipart-union-jack-flag-of-great-517a96d567f42925.png",
          levels: [
            "A1",
            "A2",
            "B1",
            "B2",
            "C1",
            "C2",
          ],
          selectedLevel: 0));
    };
  }

  onNewItemAdded(ProgressableItem newItem) {
    setState(() {
      items.add(newItem);
      onDataChanged(newItem, "New language");
    });
  }

  onDataChanged(ProgressableItem progressableItem, String log) {
    print("TEXTUAL achievement changed - $log ADD to sink");
    var currentItems = List<ProgressableItem>();
    currentItems.addAll(items.where((it) => it.key != progressableItem.key));
    currentItems.add(progressableItem);
    widget.onDataChanged(widget.data.cloneWith(currentItems));
  }
}
