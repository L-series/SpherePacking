# Set level, weight, prec, fnz, and solver
# before loading this code.
magma.load("getBases.magma")

outputFileName = "ApproxSummaryResults2.txt"
file = open(outputFileName, "a")
file.write("[level, weight, prec, fnzs, solver, results]\n")
file.close()
levels = [24, 48, 96, 192, 384]
#weights = [6,8,10] + range(14,100,2)
weights = [6]
solver = 'GLPK' 
# Main options for solver are currently GLPK and ppl. ppl uses exact rational linear programming. 
for level in levels:
  prec = 100 * floor(level/24) + 400
  for weight in weights:
    print("Starting Level " + str(level) + " Weight " + str(weight) + '\n')
    maxfnz = floor(dimension_modular_forms(Gamma0(level), weight)/2)
    fnzs = [floor(maxfnz/4)..maxfnz]
    load("loadAndSolveLP.sage")
    magma.function_call('getBasisAndDualBasis',[level,weight,prec]);
    for fnz in fnzs:
      try:
        result = getOptimumAtFirstNonZeroPositions(level, weight, prec, [fnz], solver)
        file = open(outputFileName, "a")
        file.write(str([level, weight, prec, fnz, solver, result]))
        file.write('\n')
        file.close()
      except:
        file = open(outputFileName, "a")
        file.write(str([level, weight, prec, fnz, solver, "Exception Raised"]))
        file.write('\n')
        file.close()
        print [level, weight, prec, fnz, solver, "Exception Raised"]
    file = open(outputFileName, "a")
    file.write('\n')
    file.close()
    if solver == 'ppl':
      magma.load("testPositivity.magma")
      print magma.function_call('FullPositivityCheckOriginalAndDual',[level,weight,prec,fnz],nvals=3)

