import 'dart:math';

void main() {
  startApp();
}

void startApp() {}

class Wish {
  WishStatus status = WishStatus.wished;
  Wisher? wisher;
  WishResolver? assignee;
  WishCategory? wishCategory;
}

class Wisher {
  String? goodnessLevelSystemId;
  String? bio;
}

class WishCategory {}

class UserWish {
  Wisher? wisher;
}

enum GoodnessLevel {
  veryGood,
  good,
  decent,
  bad,
  coalGuaranteed;
}

enum WishStatus {
  wished,
  granting,
  granted,
  denied;
}

class WishResolver {}

class WishStatistics {
  WishResolver? resolver;
  Map<WishStatus, int> statusCounts = Map.from({
    WishStatus.wished: 0,
    WishStatus.granted: 0,
    WishStatus.denied: 0,
    WishStatus.granting: 0,
  }); 
}

final santa = WishResolver();
final elvesPool = [
  WishResolver(),
  WishResolver(),
  WishResolver(),
  WishResolver(),
];

List<Wish> wishes = [];

List<UserWish> getWishesAsUser(Wisher wisher) {
  return wishes
      .where((wish) => wish.wisher == wisher)
      .map((wish) => UserWish()..wisher = wish.wisher)
      .toList();
}

List<WishStatistics> getStatistics() {
  return [santa, ...elvesPool].map((resolver) {
    var statistics = WishStatistics();
    statistics.resolver = resolver;
    statistics.statusCounts = {
      for (var status in WishStatus.values) ...{
        status: resolver.assignedWishes.where((wish) => wish.status == status).length,
      }
    };
    return statistics;
  }).toList();
}

void notifySantaOfWish(Wish wish) {}

Future<void> validateWishWithSanta(Wish wish) async {
  notifySantaOfWish(wish);
  await Future.delayed(Duration(minutes: 30));
  if (wish.assignee == null) {
    autoAssignWish(wish);
  }
}

void categorizeWish(Wish wish, WishCategory category) {
  wish.wishCategory = category;
}

void createWish(Wish wish) {
  wishes.add(wish);
  autoAssignWish(wish);
}

void assignWish(Wish wish, WishResolver resolver) {
  wish.assignee = resolver;
}

void resolveWish(WishResolver resolver, Wish wish) {
  if (wish.assignee != resolver) return;

  wish.status = WishStatus.granted;
}

void autoAssignWish(Wish wish) {
  var elfWithWishLength = elvesPool.map(
    (elf) => (elf, elf.assignedWishes.length),
  );
  var largestElvWish = elfWithWishLength.fold(0, (a, b) => max(a, b.$2));
  var santaWish = santa.assignedWishes;

  if (largestElvWish * 2 > santaWish.length) {
    assignWish(wish, santa);
    return;
  }
  var elfToAssign = elfWithWishLength.reduce((a, b) {
    if (a.$2 > b.$2) {
      return b;
    }
    return a;
  });

  assignWish(wish, elfToAssign.$1);
}

GoodnessLevel getGoodnessForWisher(Wisher wisher) {
  var id = wisher.goodnessLevelSystemId.hashCode;

  return GoodnessLevel.values[id % GoodnessLevel.values.length];
}

extension on WishResolver {
  List<Wish> get assignedWishes =>
      wishes.where((wish) => wish.assignee == this).toList();
}
