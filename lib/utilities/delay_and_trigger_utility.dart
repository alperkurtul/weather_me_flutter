class DelayAndTriggerUtility {
  int _delayPeriodInMillisecond;
  int _delayTimeSteps;

  int? _remainingDelayPeriodInMillisecond;
  bool _isDelayPeriodStarted = false;

  DelayAndTriggerUtility(this._delayPeriodInMillisecond, this._delayTimeSteps) {
    _remainingDelayPeriodInMillisecond = _delayPeriodInMillisecond;
  }

  void reinitializeRemainingDelayPeriod() {
    _remainingDelayPeriodInMillisecond = _delayPeriodInMillisecond;
  }

  Future<bool> isDelayPeriodEnded() async {
    if (_isDelayPeriodStarted) {
      reinitializeRemainingDelayPeriod();
      return Future.value(false);
    }

    _isDelayPeriodStarted = true;
    while (_remainingDelayPeriodInMillisecond! > 0) {
      await Future.delayed(Duration(milliseconds: _delayTimeSteps));
      _remainingDelayPeriodInMillisecond = _remainingDelayPeriodInMillisecond! - _delayTimeSteps;
    }
    _isDelayPeriodStarted = false;
    reinitializeRemainingDelayPeriod();
    return Future.value(true);
  }

}