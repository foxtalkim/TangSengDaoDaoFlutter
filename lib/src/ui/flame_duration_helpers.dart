/// iOS slider 0-6 step 离散值 mapping (WKFlameSettingView.m:144-173).
/// progress -> second: 0=0, 1-3=10/20/30, 4=60, 5=120, 6=180.
int flameProgressToSecond(int progress) {
  if (progress > 0 && progress <= 3) return progress * 10;
  if (progress == 4) return 60;
  if (progress == 5) return 120;
  if (progress >= 6) return 180;
  return 0;
}

int flameSecondToProgress(int second) {
  if (second > 0 && second < 60) return second ~/ 10;
  if (second == 60) return 4;
  if (second > 60 && second <= 120) return 5;
  if (second > 120) return 6;
  return 0;
}
