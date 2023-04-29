import 'dart:math';

import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';

import '../models/calc/calc_result.dart';
import '../models/input/matrix_model.dart';
import '../models/input/solution_variable.dart';
import '../models/input/vector_model.dart';

class ExerciseUtils {
  static Random random = Random();

  static MatrixModel generateMatrix({int? rows, int? columns}) {
    rows ??= generateSize();
    columns ??= generateSize();

    MatrixModel m = MatrixModel(rows: rows, columns: columns);

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        m[i][j] = generateFraction();
      }
    }

    return m;
  }

  static MatrixModel generateSquareMatrix(int size) =>
      ExerciseUtils.generateMatrix(
        rows: size,
        columns: size,
      );

  static VectorModel generateVector({int? length}) {
    length ??= generateSize();

    VectorModel v = VectorModel(length: length);

    for (var i = 0; i < length; i++) {
      v[i] = generateFraction();
    }

    return v;
  }

  static BigFraction generateFraction() {
    int num = random.nextInt(30) - 15;
    return num.toBigFraction();
  }

  static Scalar generateNonZeroScalar({bool nonOneValue = false}) {
    int num = random.nextInt(21) - 10;
    if (num == 0 || (nonOneValue && num == 1)) {
      num = -1;
    }

    return Scalar(num.toBigFraction());
  }

  static int generateSize({int max = 4, int min = 1}) =>
      random.nextInt(max - min + 1) + min;

  static List<VectorModel> generateBasis({
    int? vectorLength,
    int? basisLength,
  }) {
    basisLength ??= generateSize(min: 2, max: 3);
    vectorLength ??= generateSize(min: basisLength);

    MatrixModel basis = MatrixModel(rows: basisLength, columns: vectorLength);

    for (var r = 0; r < basis.rows; r++) {
      for (var c = 0; c < basis.columns; c++) {
        if (r == c) {
          var fraction = generateFraction();
          basis[r][c] =
              fraction != BigFraction.zero() ? fraction : BigFraction.one();
        } else if (c >= basis.rows) {
          basis[r][c] = generateFraction();
        }
      }
    }

    Expression expB = basis.toMatrix();

    // Exchange rows
    int row1 = random.nextInt(basis.rows);
    int row2 = random.nextInt(basis.rows);

    if (row1 != row2) {
      expB = ExchangeRows(
        matrix: expB,
        row1: row1,
        row2: row2,
      );
    }

    expB = ExchangeRows(
      matrix: basis.toMatrix(),
      row1: 0,
      row2: row2,
    );

    // Shuffle columns
    expB = Transpose(matrix: expB);

    for (var i = 0; i < (basis.columns - 1); i++) {
      row1 = random.nextInt(basis.columns);
      row2 = random.nextInt(basis.columns);
      if (row1 == row2) {
        continue;
      }

      expB = ExchangeRows(matrix: expB, row1: row1, row2: row2);
    }

    expB = Transpose(matrix: expB);

    // Add rows to rows n times
    for (var i = 0; i < basis.rows * 2; i++) {
      row1 = random.nextInt(basis.rows);
      row2 = random.nextInt(basis.rows);

      if (row1 == row2 && row1 < basis.rows - 1) {
        row1++;
      } else if (row1 == row2) {
        row1--;
      }

      var n = random.nextInt(5) * pow(-1, random.nextInt(2)).toInt();

      expB = AddRowToRowNTimes(
        matrix: expB,
        origin: row1,
        target: row2,
        n: Scalar(BigFraction.from(n)),
      );
    }

    // Calculate expressions
    var basisM = CalcResult.calculate(expB).result as Matrix;

    return MatrixModel.fromMatrix(basisM).toVectorModels();
  }

  static Vector vectorFromSolutionMap(
      Map<int, SolutionVariable> inputSolution, int variableCount) {
    List<Expression> solutionVector = [];
    for (var i = 0; i < variableCount; i++) {
      if (inputSolution[i] != null) {
        solutionVector.add(inputSolution[i]!.toExpression(i));
      } else {
        solutionVector.add(Scalar.zero());
      }
    }

    return Vector(items: solutionVector);
  }
}
