enum CalcOperation {
  gaussianElimination(
    'gaussovaEliminace',
    'Řešení rovnice pomocí Gaussovy eliminační metody',
  ),
  isSolvable(
    'jeŘešitelná',
    'Kontrola, zda je soustava řešitelná porovnáním hodností matice soustavy a rozšířené matice soustavy',
  ),
  cramer(
    'cramer',
    'Řešení rovnice Cramerovým pravidlem',
  ),
  solveWithInverse(
    'řešitPomocíInvezníM',
    'Řešení rovnice pomocí inverzní matice',
  ),
  det(
    'det',
    'Výpočet determinantu',
  ),
  h(
    'h',
    'Výpočet hodnosti matice',
  ),
  reduce(
    'redukce',
    'Převod matice na redukovaný tvar',
  ),
  triang(
    'triang',
    'Převod matice na trojúhelníkový tvar',
  ),
  linIndependent(
    'linNezávislé',
    'Určení, zda jsou vektory lineárně nezávislé',
  ),
  basis(
    'najdiBázi',
    'Nalezení báze matice',
  ),
  transformCoords(
    'transformujSouřadnice',
    'Převod souřadnic od báze k bázi pomocí matice přechodu',
  ),
  transformMatrix(
    'maticePřechodu',
    'Výpočet matice přechodu od báze k bázi',
  );

  final String texName;
  final String description;

  const CalcOperation(this.texName, this.description);
}
