import "dart:io";

void main() {
  print("do 3x+1");

  List<Threex> all = [];
  for (int i = 1; i <= 10; i++) {
    all.add(Threex(i));
  }

  int i = 1;
  for (Threex th in all) {
    print("$i");
    print(th.theSequence);
    i++;
  }
}

class Threex {
  final List<int> theSequence;
  final int starting;
  int max;
  late int size;

  Threex(this.starting)
      : theSequence = crank(starting),
        max = maximum(crank(starting))
       
  { size = theSequence.length; }

  static List<int> crank(int n) {
    List<int> theSeq = [n];
    while (n != 1) {
      if (n % 2 == 0) {
        n = n ~/ 2;
      } else {
        n = n * 3 + 1;
      }
      theSeq.add(n);
    }
    return theSeq;
  }
}

// finds max of positive integer list.
int maximum(List<int> theList) {
  int max = 0;
  for (int x in theList) {
    max = x > max ? x : max;
  }
  return max;
}
