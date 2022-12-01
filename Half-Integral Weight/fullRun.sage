# Set level, weight, prec, fnz, and solver

# before loading this code.
magma.load("getBases.magma")
load("loader.sage")
#magma.function_call('getBasisAndDualBasis',[24,8,500]);
writeTheLP(24, 8,50 ,10, 'GLPK');
#getOptimumAtFirstNonZeroPositions(24, 8, 50, [10], 'GLPK')
#if solver == 'ppl':
#	magma.load("testPositivity.magma")
#	print magma.function_call('FullPositivityCheckOriginalAndDual',[level,weight,prec,fnz],nvals=3)
#
