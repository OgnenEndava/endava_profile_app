import 'package:endava_profile_app/common/constants/palette.dart';
import 'package:flutter/material.dart';

class DraggableProgress extends StatefulWidget {
  List<String> levels = List();
  Function(String selectedLevel) _onLevelSelected;

  DraggableProgress(this.levels, this._onLevelSelected);

  @override
  _DraggableProgressState createState() => _DraggableProgressState(levels, _onLevelSelected);
}

class _DraggableProgressState extends State<DraggableProgress> {
  final List<String> _levels;
  List<double> _levelsXcoords = List();
  Function(String selectedLevel) _onLevelSelected;
  final _startingPoint = 0.0;
  static final _levelStartingPoint = 32.0;
  double _distanceBetweenLevels;
  final _levelWidth = 8.0;
  static final _draggablePointerWidth = 64.0;
  static final _draggablePointerHeight = 18.0;
  static final _barHeight = 8.0;
  static final _barMargin = (_draggablePointerHeight - _barHeight) / 2;
  double _dragDx = _levelStartingPoint - _draggablePointerWidth / 2;
  double _endingPoint;

  _DraggableProgressState(this._levels, this._onLevelSelected);

  @override
  Widget build(BuildContext context) {
    if (_endingPoint == null) {
      _endingPoint = 250;
    }
    if (_distanceBetweenLevels == null || _levelsXcoords == null || _levelsXcoords.isEmpty) {
      if (_levels.length == 2) {
        _levelsXcoords = [_levelStartingPoint, _endingPoint - _levelStartingPoint];
      } else {
        _distanceBetweenLevels = (_endingPoint - _levelStartingPoint * 2) / (_levels.length - 1);
        var currentLevelXcoord = _levelStartingPoint;
        for (int i = 0; i < _levels.length - 1; i++) {
          _levelsXcoords.add(currentLevelXcoord);
          currentLevelXcoord += _distanceBetweenLevels;
        }
        _levelsXcoords.add(_endingPoint - _levelStartingPoint);
      }
    }
    return _mainWidget();
  }

  int _getClosestLevelIndex() {
    final draggableWidgetCenterPosition = _dragDx + _draggablePointerWidth / 2;
    List<double> distancesBetweenLevelsAndDraggableWidget = _levelsXcoords.map((xCoord) {
      return (xCoord - draggableWidgetCenterPosition).abs();
    }).toList();
    final sortedDistances = new List();
    sortedDistances.addAll(distancesBetweenLevelsAndDraggableWidget);
    sortedDistances.sort();
    return distancesBetweenLevelsAndDraggableWidget.indexOf(sortedDistances[0]);
  }

  void _onPointMoved(double dxPosition) {
    final pointerHalf = _draggablePointerWidth / 2;
    var dx = dxPosition;
    if (dx < pointerHalf) {
      dx = _startingPoint;
    } else if (dx > _endingPoint - pointerHalf) {
      dx = _endingPoint - _draggablePointerWidth;
    } else {
      dx = dxPosition - pointerHalf;
    }
    setState(() {
      _dragDx = dx;
    });
  }

  Widget _mainWidget() {
    return Container(
      width: _endingPoint,
      child: GestureDetector(
        onTapDown: (tapInfo) {
          _onPointMoved(tapInfo.localPosition.dx);
        },
        onTapUp: (_) {
          _onLevelSelected(getKnowledgeLevel());
          setState(() {
            _dragDx = _levelsXcoords[_getClosestLevelIndex()] - _draggablePointerWidth / 2;
          });
        },
        onHorizontalDragUpdate: (dragInfo) {
          _onPointMoved(dragInfo.localPosition.dx);
        },
        onHorizontalDragEnd: (_) {
          _onLevelSelected(getKnowledgeLevel());
          setState(() {
            _dragDx = _levelsXcoords[_getClosestLevelIndex()] - _draggablePointerWidth / 2;
          });
        },
        child: Stack(
          children: <Widget>[
            _bar(),
            _getLevels(),
            _draggablePointer(),
          ],
        ),
      ),
    );
  }

  Widget _bar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Palette.cinnabar, borderRadius: BorderRadius.circular(15.0)),
            margin: EdgeInsets.fromLTRB(0, _barMargin, 0, _barMargin),
            height: _barHeight,
          ),
        )
      ],
    );
  }

  Widget _draggablePointer() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_draggablePointerHeight)),
      margin: EdgeInsets.only(left: _dragDx),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 12, width: 2, color: Palette.whiteSmoke),
            SizedBox(width: 2),
            Container(height: 12, width: 2, color: Palette.whiteSmoke),
            SizedBox(width: 2),
            Container(height: 12, width: 2, color: Palette.whiteSmoke)
          ],
        ),
        height: _draggablePointerHeight,
        width: _draggablePointerWidth,
      ),
    );
  }

  Widget _getLevels() {
    List<Widget> levelsDrawn = List();
    for (int i = 0; i < _levelsXcoords.length; i++) {
      levelsDrawn.add(Container(
        decoration: BoxDecoration(color: Palette.tomato, borderRadius: BorderRadius.circular(20.0)),
        margin: EdgeInsets.fromLTRB(_levelsXcoords[i] - (_levelWidth / 2), _barMargin, 0, _barMargin),
        height: _barHeight,
        width: _levelWidth,
      ));
    }
    return Stack(children: levelsDrawn);
  }

  String getKnowledgeLevel() {
    return _levels[_getClosestLevelIndex()];
  }
}
