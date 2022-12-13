alias Crap = Int32 | Array(Crap)

#PAIRS = [
#  {
#    a: [1,1,3,1,1] of Crap,
#    b: [1,1,5,1,1] of Crap,
#  },
#  {
#    a: [[1] of Crap, [2,3,4] of Crap] of Crap,
#    b: [[1] of Crap, 4] of Crap,
#  },
#  {
#    a: [9] of Crap,
#    b: [[8,7,6] of Crap] of Crap,
#  },
#  {
#    a: [[4,4] of Crap,4,4] of Crap,
#    b: [[4,4] of Crap,4,4,4] of Crap,
#  },
#  {
#    a: [7,7,7,7] of Crap,
#    b: [7,7,7] of Crap,
#  },
#  {
#    a: [] of Crap,
#    b: [3] of Crap,
#  },
#  {
#    a: [[[] of Crap] of Crap] of Crap,
#    b: [[] of Crap] of Crap,
#  },
#  {
#    a: [1,[2,[3,[4,[5,6,7].as(Crap)].as(Crap)].as(Crap)],8,9].as(Crap),
#    b: [1,[2,[3,[4,[5,6,0].as(Crap)].as(Crap)].as(Crap)],8,9].as(Crap),
#  }
#]

PAIRS = [
  {
    a: [1,1,3,1,1] of Crap,
    b: [1,1,5,1,1] of Crap,
  },
  {
    a: [[1] of Crap,[2,3,4] of Crap] of Crap,
    b: [[1] of Crap,4] of Crap,
  },
  {
    a: [9] of Crap,
    b: [[8,7,6] of Crap] of Crap,
  },
  {
    a: [[4,4] of Crap,4,4] of Crap,
    b: [[4,4] of Crap,4,4,4] of Crap,
  },
  {
    a: [7,7,7,7] of Crap,
    b: [7,7,7] of Crap,
  },
  {
    a: [] of Crap,
    b: [3] of Crap,
  },
  {
    a: [[[] of Crap] of Crap] of Crap,
    b: [[] of Crap] of Crap,
  },
  {
    a: [1,[2,[3,[4,[5,6,7] of Crap] of Crap] of Crap] of Crap,8,9] of Crap,
    b: [1,[2,[3,[4,[5,6,0] of Crap] of Crap] of Crap] of Crap,8,9] of Crap,
  },
]
