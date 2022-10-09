# Set level, weight, prec, fnz, and solver
# before loading this code.
magma.load("getBases.magma")
load("loadAndSolveLP.sage")
magma.function_call('getBasisAndDualBasis',[level,weight,prec]);
writeTheLP(level, weight, prec, fnz, solver);
#print getOptimumAtFirstNonZeroPositions(level, weight, prec, [fnz], solver)
#if solver == 'ppl':
#  magma.load("testPositivity.magma")
#  print magma.function_call('FullPositivityCheckOriginalAndDual',[level,weight,prec,fnz],nvals=3)
