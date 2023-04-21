enum CalcOperation {
  gaussianElimination(
    "Řešení rovnice pomocí Gaussovy eliminační metody",
  ),
  isSolvable(
    "Kontrola, zda je soustava řešitelná porovnáním hodností matice soustavy a rozšířené matice soustavy",
  ),
  cramer(
    "Řešení rovnice Cramerovým pravidlem",
  ),
  solveWithInverse(
    "Řešení rovnice pomocí inverzní matice",
  ),
  det(
    "Výpočet determinantu",
  ),
  h(
    "Výpočet hodnosti matice",
  ),
  reduce(
    "Převod matice na redukovaný tvar",
  ),
  triang(
    "Převod matice na trojúhelníkový tvar",
  ),
  linIndependent(
    "Určení, zda jsou vektory lineárně nezávislé",
  ),
  basis(
    "Nalezení báze matice",
  ),
  transformCoords(
    "Převod souřadnic od báze k bázi pomocí matice přechodu",
  ),
  transformMatrix(
    "Výpočet matice přechodu od báze k bázi",
  );

  final String description;

  const CalcOperation(this.description);
}
