def getFilename(level, weight, prec, prefix, suffix):
  filename = prefix
  filename += "L" + str(level) + "W" + str(weight) + "P" + str(prec)
  filename += suffix
  return filename

def getFilenameZ(level, weight, prec, fnz, prefix, suffix):
  filename = prefix
  filename += "L" + str(level) + "W" + str(weight) + "P" + str(prec) + "Z" + str(fnz)
  filename += suffix
  return filename

def getBasisFromFile(filename):
  content = ""
  with open(filename, 'r') as file:
    for line in file:
      content += line.rstrip()
  contentList = content.replace(" ","").replace("],","")[2:-2].split("[")
  return [ [ Rationals()(term) for term in line.split(',') ] for line in contentList]

def getMxFromBasisList(basis):
  return matrix(basis).transpose()

# Takes matrices with coefficients as column vectors
def initLPFromBases(lp, var, basis, basisDual):
  # Jump through hoops because
  # Multiplying single row matrices with MILP variables is buggy.
  lp.set_objective(lp.sum([basisDual[0,j] * var[j] for j in range(basisDual.ncols())]))
  lp.add_constraint(lp.sum([basis[0,j] * var[j] for j in range(basis.ncols())]) == 1)
  lp.add_constraint(basis[1:basis.nrows()] * var >= 0)
  lp.add_constraint(basisDual * var >= 0)

def addEqZeroConstraint(lp, var, basis, index):
  lp.add_constraint(lp.sum([basis[index,j] * var[j] for j in range(basis.ncols())]) == 0)

def addEqZeroConstraints(lp, var, basis, list):
  if len(list) == 0:
    return
  elif len(list) == 1:
    # Jump through hoops because
    # Multiplying single row matrices with MILP variables is buggy.
    addEqZeroConstraint(lp,var,basis,list[0])
  else:
    lp.add_constraint(basis[list] * var == 0)

def writeSeqToFile(filename, seq):
  file = open(filename, "w")
  file.write(str(seq).replace(",",",\n"))
  file.close()

def writeValToFile(filename, val):
  file = open(filename, "w")
  file.write(str(val))
  file.close()

def writeColMxToFile(filename, col):
  seq = [ col[j,0] for j in range(col.nrows()) ]
  writeSeqToFile(filename, seq)

# Takes matrix and sequence
def getForm(basisMx, coords):
  col = basisMx * matrix(coords).transpose()
  return [ col[j,0] for j in range(col.nrows()) ]

def getRootDistanceFromOpt(opt, level, weight, fnz):
  return (opt^(1/weight) * 2 * fnz/level^(1/2));


def getPrefixBySolver(solver):
  if solver == 'ppl':
    return "OptimalForms/Exact/"
  return "OptimalForms/Approx/"

# Want to rewrite this using exact_rational or maybe nearby_rational for performance reasons.
# Plus will need to rework the LP-initialization here. If setting up to do multiple things, it might be helpful to work in the opposite order now, curiously enough. Maybe add that functionality in later...
def getOptimumAtFirstNonZeroPositions(level, weight, prec, fnzs, mySolver):
  filename = getFilename(level, weight, prec, "Bases/", ".txt")
  filenameDual = getFilename(level, weight, prec, "Bases/", "Dual.txt")
  basis = getBasisFromFile(filename)
  basisDual = getBasisFromFile(filenameDual)
  basisMx = getMxFromBasisList(basis)
  basisMxDual = getMxFromBasisList(basisDual)
  p = MixedIntegerLinearProgram(maximization=True, solver=mySolver)
  x = p.new_variable(real=True, nonnegative=False)
  initLPFromBases(p, x, basisMx, basisMxDual)
  fnzsSorted = [1] + sorted(list(set(fnzs)))
  rootDists = []
  prefix = getPrefixBySolver(mySolver)
  for j in [1..(len(fnzsSorted) -1)]:
    fnz = fnzsSorted[j]
    addEqZeroConstraints(p, x, basisMx, [fnzsSorted[j-1]..(fnz-1)])
    optVal = p.solve()
    rootDist = RealField(100)(getRootDistanceFromOpt(optVal, level, weight, fnz))
    rootDists += [rootDist]
    filename = getFilenameZ(level, weight, prec, fnz, prefix, "RootDist.txt")
    writeValToFile(filename, rootDist)
    optCoords = p.get_values(x)
    optCoords = optCoords.values()    #Is this behaviour guaranteed?
    filename = getFilenameZ(level, weight, prec, fnz, prefix, "Coords.txt")
    writeSeqToFile(filename, optCoords)
    optForm = getForm(basisMx, optCoords)
    optFormDual = getForm(basisMxDual, optCoords)
    filename = getFilenameZ(level, weight, prec, fnz, prefix, ".txt")
    filenameDual = getFilenameZ(level, weight, prec, fnz, prefix, "Dual.txt")
    writeSeqToFile(filename, optForm)
    writeSeqToFile(filenameDual, optFormDual)
  return rootDists

def writeTheLP(level, weight, prec, fnz, mySolver):
  filename = getFilename(level, weight, prec, "Bases/", ".txt")
  filenameDual = getFilename(level, weight, prec, "Bases/", "Dual.txt")
  basis = getBasisFromFile(filename)
  basisDual = getBasisFromFile(filenameDual)
  basisMx = getMxFromBasisList(basis)
  basisMxDual = getMxFromBasisList(basisDual)
  p = MixedIntegerLinearProgram(maximization=True, solver=mySolver)
  x = p.new_variable(real=True, nonnegative=False)
  initLPFromBases(p, x, basisMx, basisMxDual)
  addEqZeroConstraints(p, x, basisMx, [1..(fnz-1)])
  filename = "LPblah.txt"
  p.write_lp(filename)
  return 1







  

