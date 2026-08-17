// 从 fsrs4anki_scheduler.js (v6.1.1) 提取纯函数，生成 FSRS 移植的 golden 参考值。
// 用法：node tools/fsrs_golden_gen.js
// 只输出确定性的量（difficulty / stability / retrievability），不涉及 fuzz 随机部分。
const w = [0.212, 1.2931, 2.3065, 8.2956, 6.4133, 0.8334, 3.0194, 0.001,
  1.8722, 0.1666, 0.796, 1.4835, 0.0614, 0.2629, 1.6483, 0.6014,
  1.8729, 0.5425, 0.0912, 0.0658, 0.1542];
const requestRetention = 0.9;
const maximumInterval = 36500;
const DECAY = -w[20];
const FACTOR = Math.pow(0.9, 1 / DECAY) - 1;
const ratings = { again: 1, hard: 2, good: 3, easy: 4 };

function constrain_difficulty(difficulty) {
  return Math.min(Math.max(+difficulty.toFixed(2), 1), 10);
}
function forgetting_curve(elapsed_days, stability) {
  return Math.pow(1 + FACTOR * elapsed_days / stability, DECAY);
}
function linear_damping(delta_d, old_d) {
  return delta_d * (10 - old_d) / 9;
}
function mean_reversion(init, current) {
  return w[7] * init + (1 - w[7]) * current;
}
function init_difficulty(rating) {
  return +constrain_difficulty(w[4] - Math.exp(w[5] * (ratings[rating] - 1)) + 1).toFixed(2);
}
function init_stability(rating) {
  return +Math.max(w[ratings[rating] - 1], 0.1).toFixed(2);
}
function next_difficulty(d, rating) {
  const delta_d = -w[6] * (ratings[rating] - 3);
  const next_d = d + linear_damping(delta_d, d);
  return constrain_difficulty(mean_reversion(init_difficulty("easy"), next_d));
}
function next_recall_stability(d, s, r, rating) {
  const hardPenalty = rating === "hard" ? w[15] : 1;
  const easyBonus = rating === "easy" ? w[16] : 1;
  return +(s * (1 + Math.exp(w[8]) *
    (11 - d) *
    Math.pow(s, -w[9]) *
    (Math.exp((1 - r) * w[10]) - 1) *
    hardPenalty *
    easyBonus)).toFixed(2);
}
function next_forget_stability(d, s, r) {
  const sMin = s / Math.exp(w[17] * w[18]);
  return +Math.min(w[11] *
    Math.pow(d, -w[12]) *
    (Math.pow(s + 1, w[13]) - 1) *
    Math.exp((1 - r) * w[14]), sMin).toFixed(2);
}

function newCard() {
  const out = {};
  for (const rating of ["again", "hard", "good", "easy"]) {
    out[rating] = { d: init_difficulty(rating), s: init_stability(rating) };
  }
  return out;
}

function reviewCard(d, s, elapsed) {
  const r = forgetting_curve(elapsed, s);
  const out = { r: +r.toFixed(6) };
  for (const rating of ["again", "hard", "good", "easy"]) {
    const nd = next_difficulty(d, rating);
    const ns = rating === "again"
      ? next_forget_stability(d, s, r)
      : next_recall_stability(d, s, r, rating);
    out[rating] = { d: nd, s: ns };
  }
  return out;
}

console.log(JSON.stringify({
  new: newCard(),
  review_d3s3_e1: reviewCard(3, 3, 1),
  review_d7s30_e10: reviewCard(7, 30, 10),
  review_d2s2_e3: reviewCard(2, 2, 3),
  review_d1s1_e0: reviewCard(1, 1, 0),
}, null, 2));
