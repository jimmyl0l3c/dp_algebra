import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';

void main() {
  var s1 = Scalar(value: 5.toFraction());
  var s2 = Scalar(value: 6.toFraction());
  var s3 = Multiply(left: s1, right: s2);
  print(s3.toTeX());
  print(s3.simplify().toTeX());

  var v1 = Vector(
    items: [
      Multiply(
        left: Scalar(value: 2.toFraction()),
        right: Scalar(value: 3.toFraction()),
      ),
      Multiply(
        left: Scalar(value: 7.toFraction()),
        right: Scalar(value: 4.toFraction()),
      ),
    ],
  );
  var v2 = Vector(
    items: [Scalar(value: 3.toFraction()), Scalar(value: 4.toFraction())],
  );
  print(v1.toTeX());
  print(v1.simplify().toTeX());
  print(v1.simplify().simplify().toTeX());
  print(v1.simplify().simplify().simplify().toTeX());
  print("\n");

  var multiply1 = Multiply(left: s1, right: v1);
  print(multiply1.toTeX());
  print(multiply1.simplify().toTeX());
  print(multiply1.simplify().simplify().toTeX());
  print(multiply1.simplify().simplify().simplify().toTeX());
  print(multiply1.simplify().simplify().simplify().simplify().toTeX());
  print(
      multiply1.simplify().simplify().simplify().simplify().simplify().toTeX());
  print(multiply1.simplify().toTeX());
  print("\n");

  var m1 = Matrix(rows: [
    [Scalar(value: 2.toFraction()), Scalar(value: 3.toFraction())],
    [Scalar(value: 4.toFraction()), Scalar(value: 5.toFraction())],
  ]);
  print(m1.toTeX());
  var multiply2 = Multiply(left: s1, right: m1);
  print(multiply2.toTeX());
  print(multiply2.simplify().toTeX());
  print(multiply2.simplify().simplify().toTeX());
  print(multiply2.simplify().simplify().simplify().toTeX());
  print(multiply2.simplify().simplify().simplify().simplify().toTeX());
  print(
      multiply2.simplify().simplify().simplify().simplify().simplify().toTeX());
  print(multiply2.simplify().toTeX());
  print("\n");

  var m2 = Matrix(rows: [
    [Scalar(value: 6.toFraction()), Scalar(value: 7.toFraction())],
    [Scalar(value: 9.toFraction()), Scalar(value: 8.toFraction())],
  ]);
  var multiply3 = Multiply(left: m1, right: m2);
  print(multiply3.toTeX());
  print(multiply3.simplify().toTeX());
  print(multiply3.simplify().simplify().toTeX());
  print(multiply3.simplify().simplify().simplify().toTeX());
  print(multiply3.simplify().simplify().simplify().simplify().toTeX());
  print(
      multiply3.simplify().simplify().simplify().simplify().simplify().toTeX());
  print(multiply3
      .simplify()
      .simplify()
      .simplify()
      .simplify()
      .simplify()
      .simplify()
      .toTeX());
  print(multiply3
      .simplify()
      .simplify()
      .simplify()
      .simplify()
      .simplify()
      .simplify()
      .simplify()
      .toTeX());

  var m3 = Matrix(rows: [
    [Scalar(value: 6.toFraction()), Scalar(value: 7.toFraction())],
    [Scalar(value: 9.toFraction()), Scalar(value: 8.toFraction())],
    [Scalar(value: 1.toFraction()), Scalar(value: 2.toFraction())],
    [Scalar(value: 3.toFraction()), Scalar(value: 5.toFraction())],
  ]);
  print(m3.toTeX());
  var exchange = ExchangeRows(matrix: m3, row1: 1, row2: 3);
  print(exchange.toTeX());
  print(exchange.simplify().toTeX());
  print(exchange.simplify().toTeX());

  var addRow2Row = AddRowToRowNTimes(
    matrix: m3,
    origin: 2,
    target: 0,
    n: Scalar(value: Fraction(-2)),
  );
  print(addRow2Row.simplify().toTeX());
  print(addRow2Row.simplify().simplify().toTeX());
  print(addRow2Row.simplify().simplify().simplify().toTeX());

  var multiplyRow = MultiplyRowByN(
    matrix: m3,
    n: Scalar(value: Fraction(-3)),
    row: 1,
  );
  print(multiplyRow.simplify().toTeX());
  print(multiplyRow.simplify().simplify().toTeX());

  var divide = Divide(
    numerator: Multiply(left: Scalar(value: Fraction(-1)), right: s1),
    denominator: s2,
  );
  print(divide.toTeX());
  print(divide.simplify().toTeX());
  print(divide.simplify().simplify().toTeX());

  print("\n");
  var triangular = Triangular(matrix: m3);
  print(triangular.toTeX());
  printNSimplifications(triangular, 54);

  var m4 = Matrix(rows: [
    [
      Scalar(value: 0.toFraction()),
      Scalar(value: 7.toFraction()),
      Scalar(value: 3.toFraction())
    ],
    [
      Scalar(value: 3.toFraction()),
      Scalar(value: 8.toFraction()),
      Scalar(value: 2.toFraction())
    ],
    [
      Scalar(value: 1.toFraction()),
      Scalar(value: 8.toFraction()),
      Scalar(value: 13.toFraction())
    ],
  ]);

  print("\n");
  var triangularDet = TriangularDet(det: m4);
  print(triangularDet.toTeX());
  printNSimplifications(triangularDet, 40);

  print("\n");
  var det = Determinant(det: m4);
  printNSimplifications(det, 40);

  print("\n");
  var transpose = Transpose(matrix: m3);
  print(transpose.toTeX());
  print(transpose.simplify().toTeX());

  print("\n");
  // var inverse = Inverse(exp: m4);
  // printNSimplifications(inverse, 114, addNewLine: true);

  // var reduced = Reduce(exp: m3);
  // printNSimplifications(reduced, 70, addNewLine: true);
  // print(simplifyNTimes(reduced, 70).toTeX());

  // var rank = Rank(matrix: m3);
  // printNSimplifications(rank, 60);

  // var eqM = Matrix(rows: [
  //   [Scalar(value: 1.toFraction()), Scalar(value: 2.toFraction())],
  //   [Scalar(value: 4.toFraction()), Scalar(value: 5.toFraction())]
  // ]);
  // var vY = Vector(items: [
  //   Scalar(value: 3.toFraction()),
  //   Scalar(value: 6.toFraction()),
  // ]);
  // var eqSolution = SolveWithInverse(matrix: eqM, vectorY: vY);
  // print(eqSolution.toTeX());
  // printNSimplifications(eqSolution, 50);
  var basis = FindBasis(
      matrix: Matrix.fromVectors([
    Vector(items: [
      Scalar(value: Fraction(1)),
      Scalar(value: Fraction(2)),
      Scalar(value: Fraction(3)),
    ]),
    Vector(items: [
      Scalar(value: Fraction(4)),
      Scalar(value: Fraction(5)),
      Scalar(value: Fraction(6)),
    ]),
    Vector(items: [
      Scalar(value: Fraction(7)),
      Scalar(value: Fraction(3)),
      Scalar(value: Fraction(2)),
    ]),
  ]));
  printNSimplifications(basis, 85);

  // print("\n");
  // var generalEq = GaussianElimination(
  //   matrix: Matrix.fromVectors([
  //     Vector(items: [
  //       Scalar(value: Fraction(1)),
  //       Scalar(value: Fraction(2)),
  //       Scalar(value: Fraction(3)),
  //       Scalar(value: Fraction(4)),
  //     ]),
  //     Vector(items: [
  //       Scalar(value: Fraction(0)),
  //       Scalar(value: Fraction(1)),
  //       Scalar(value: Fraction(7)),
  //       Scalar(value: Fraction(3)),
  //     ]),
  //   ]),
  // );
  // printNSimplifications(generalEq, 85);
  //
  // print("\n");
  // var independent = AreVectorsLinearlyIndependent(vectors: [
  //   Vector(items: [
  //     Scalar(value: Fraction(1)),
  //     Scalar(value: Fraction(2)),
  //     Scalar(value: Fraction(3)),
  //     Scalar(value: Fraction(4)),
  //   ]),
  //   Vector(items: [
  //     Scalar(value: Fraction(0)),
  //     Scalar(value: Fraction(1)),
  //     Scalar(value: Fraction(7)),
  //     Scalar(value: Fraction(3)),
  //   ]),
  // ]);
  // printNSimplifications(independent, 60);
  //
  // var cramer = SolveWithCramer(
  //   matrix: Matrix.fromVectors([
  //     Vector(items: [
  //       Scalar(value: Fraction(1)),
  //       Scalar(value: Fraction(2)),
  //     ]),
  //     Vector(items: [
  //       Scalar(value: Fraction(4)),
  //       Scalar(value: Fraction(5)),
  //     ]),
  //   ]),
  //   vectorY: Vector(items: [
  //     Scalar(value: Fraction(3)),
  //     Scalar(value: Fraction(6)),
  //   ]),
  // );
  // printNSimplifications(cramer, 20);
}

void printNSimplifications(Expression expression, int n,
    {bool addNewLine = false}) {
  for (var i = 0; i < n; i++) {
    print(simplifyNTimes(expression, i).toTeX());
    if (addNewLine) {
      print("");
    }
  }
}

Expression simplifyNTimes(Expression expression, int n) {
  Expression exp = expression;
  for (var i = 0; i < n; i++) {
    exp = exp.simplify();
  }
  return exp;
}
