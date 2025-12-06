
void main() {
  startApp();
}

void startApp() {

}

class Wish {
  WishResolver? assignee;
}

class WishResolver {

}

List<Wish> wishes = [];
void createWish(Wish wish) {
  wishes.add(wish);
}

void assignWish(Wish wish, WishResolver resolver) {
  wish.assignee = resolver;
}