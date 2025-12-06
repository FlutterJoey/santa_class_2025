import 'dart:math';

void main() {
  startApp();
}

void startApp() {}

class Wish {
  WishResolver? assignee;
}

class WishResolver {}

final santa = WishResolver();
final elvesPool = [
  WishResolver(),
  WishResolver(),
  WishResolver(),
  WishResolver(),
];

List<Wish> wishes = [];
void createWish(Wish wish) {
  wishes.add(wish);
  autoAssignWish(wish);
}

void assignWish(Wish wish, WishResolver resolver) {
  wish.assignee = resolver;
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

extension on WishResolver {
  List<Wish> get assignedWishes =>
      wishes.where((wish) => wish.assignee == this).toList();
}
