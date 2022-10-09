------------------------------------------------
  To Run The Modular Forms LP-Limitations Code
------------------------------------------------

The current code is built to run in a Linux file system with the following configuration.
The directory with the code should contain the following files:
  getBases.magma
  loadAndSolveLP.sage
  testPositivity.magma
  fullRun2.sage   OR   fullRun.sage

This directory should also contain the following subdirectories:
  Bases/
  OptimalForms/Approx/
  OptimalForms/Exact/

The computer also needs access to a working build of both Sage and Magma. The code has been tested most recently with Magma V2.23-3 and SageMath version 7.5.1.

There are two main ways to run the code. 

fullRun2.sage is designed for large computations, when one wants the flexibility to find bounds coming from a wide range of levels and first non-zero positions. At the top of the file, it defines a list of levels, a list of weights, and a choice of solver. At the top of the first loop, it chooses a precision based on the level, and at the top of the second loop, it chooses a range of first non-zero positions to test based on the dimension of the space of modular forms of a given level and weight. These were chosen heuristically. To run the code with a desired set of options, select the range of levels, weights and make any desired changes to prec (= precision) and fnzs (= first non-zero positions). After adjusting the code, open the sage terminal and run the command:

  load("fullRun2.sage")

fullRun.sage is designed for more interactive exploratory computations. It requires no changes to the file to set parameters. Instead, to use it, open a sage terminal, set values for the variables:
  
  level
  weight
  prec    (= precision)
  fnz     (= the first non-zero value)
  solver  (= the LP Solver Sage should use, e.g. "GLPK" for approximate computation or "ppl" for exact computation)

Then, run the command:
  
  load("fullRun.sage")

---------------------------------------------------------
  Keep the following in mind when selecting parameters:
---------------------------------------------------------

level: The current iteration of the code assumes that if n^2 divides the level, then (Z/nZ)* has exponent 2. In other words, n must be a factor of 24. Hence any level must be a factor of 24^2*S, where S is square-free. 
    This restriction comes from the assumption that all characters of (Z/nZ)* are real-valued. In priniciple, it may be possible to extend this further by taking real parts of the q-expansion of modular forms. This should be straightforward when (Z/nZ)* has exponenent 4, since Q(i)^+ = Q. Typically, however, the totally real subfield of the rationals adjoin kth roots of unity is larger than Q, so a considerable restructuring of the code would be needed to achieve what we anticipate to be marginal gains.

weight: The weight must be even and at least 4. Assuming that a double precision solver like "GLPK" is used to derive approximate solutions to the LP, the weight should be no larger than about 16 to avoid precision and roll-over issues in the LP solver.
    These difficulties appear to be fundamental to the method. In practice, because the coefficients in the q-expansion of Eisenstein series in weight k grow as n^(k-1), while the coefficients of cusp forms grows as n^(k/2), at a precision of 500 and weight of 20, the difference in the sizes of some coefficients are on the order of 2^80, while other coefficients are comparable in magnitude. This presents a particular challenge for LP solvers. It may be possible to gain additional precision by using a quad-precision LP solver or by modifying the LP to treat much smaller coefficients as 0 and hoping that feasible solutions to the altered problem are feasible for the original. We have not explored these options.

prec (the precision): Choices for precision are somewhat arbitrary, but it is clear that to get the needed positivity, one must generally take precision considerably larger than the dimension of the space of modular forms of weight k and level N.
    Someone with more technical capacity/familiarity with LP solvers than the code's author might find it useful to run the code several times starting with low precision and incrementally increasing the precision until the forms are provably positive, using the previous computation's "almost feasible solution" to "hot start" the higher precision computation. 

fnz (the first non-zero value): This should be between 1 and the dimension of the space of modular forms of weight k and level N to have any hope of a feasible solution. Based on examples, it appears that the best solutions typically fall between about a quarter and a half of this dimension, where the problem is not as badly over- or under-constrained.

solver: This should be a string defining the name of the LP solver linked to Sage (see SageMath documentation on LP solvers for options). At present, the code only recognizes "ppl" as an exact LP solver. It makes no distinction in output between different choices of approximate LP solvers. It has only been tested with the "GLPK" solver.

-----------
  Outputs
-----------

For every choice of Level, Weight, and Precision, both fullRun2.sage and fullRun.sage produce the following outputs:
In the Bases folder:
  L[level]W[weight]P[prec].txt
  L[level]W[weight]P[prec]Dual.txt

If the LP Solver returns a feasible solution, they produce:
In the OptimalForms/[Approx or Exact] folder, depending on solver:
  L[level]W[weight]P[prec]Z[fnz]Coords.txt
  L[level]W[weight]P[prec]Z[fnz].txt
  L[level]W[weight]P[prec]Z[fnz]Dual.txt
  L[level]W[weight]P[prec]Z[fnz]RootDist.txt

To verify positivity, a necessary value for prec is computed and additional bases are stored in the Bases folder:
  L[level]W[weight]P[prec]New.txt
  L[level]W[weight]P[prec]NewCuspExpansions.txt

The intended behaviors are as follows:
  Bases/L[level]W[weight]P[prec].txt contains q-expansions to precision prec of an ordered basis for the space of modular forms of weight k and level N, which is the concatenation of a basis for the subspace of cuspidal modular forms (first) with a basis of Eisenstein series (second).
  
  Bases/L[level]W[weight]P[prec]Dual.txt contains another ordered basis for the space of modular forms of weight k and level N, where the ith entry of Bases/L[level]W[weight]P[prec]Dual.txt is the image of the ith entry of Bases/L[level]W[weight]P[prec].txt under the full Atkin-Lehner operator in weight k and level N. This is calculated on the Cuspidal part using the 
  
  Bases/L[level]W[weight]P[prec]New.txt contains yet another ordered basis for the space of modular forms of weight k and level N. Again, it is the concatenation of a basis for the subspace of cuspidal modular forms (first) with a basis of Eisenstein series (second). This basis is chosen so that each entry is either a (new) eigenform or an oldform arising from some eigenform of lower level. 

  Bases/L[level]W[weight]P[prec]NewCuspExpansions.txt contains data that keeps track of how each (cuspidal) element of Bases/L[level]W[weight]P[prec]New.txt arose as a new or oldform. (Recall that there are multiple oldforms corresponding to a new form of lower level.) This file distinguishes between these different ways, by keeping track of how the q-expansions of each form are transformed. For each oldform, the form with the same q-expansion appears first, followed by the expanded forms (which are also rescaled so the Weil-Deligne bounds on coefficient growth still apply.

  OptimalForms/[Approx or Exact]/L[level]W[weight]P[prec]Z[fnz]Coords.txt contains the coordinates of a candidate modular form of weight k and level N (and its Atkin-Lehner dual) in terms of the bases Bases/L[level]W[weight]P[prec].txt and Bases/L[level]W[weight]P[prec]Dual.txt.

  OptimalForms/[Approx or Exact]/L[level]W[weight]P[prec]Z[fnz].txt contains the q-expansion of the candidate modular form of weight k and level N specified by OptimalForms/[Approx or Exact]/L[level]W[weight]P[prec]Z[fnz]Coords.txt.

  OptimalForms/[Approx or Exact]/L[level]W[weight]P[prec]Z[fnz]Dual.txt contains the q-expansion of the dual candidate modular form of weight k and level N specified by OptimalForms/[Approx or Exact]/L[level]W[weight]P[prec]Z[fnz]Coords.txt. It is dual under the full level N Atkin-Lehner operator to the form defined in OptimalForms/[Approx or Exact]/L[level]W[weight]P[prec]Z[fnz].txt 

  OptimalForms/[Approx or Exact]/L[level]W[weight]P[prec]Z[fnz]RootDist.txt
contains an rounded value for the square root of the ... version of the lower bound to the LP-method for upper-bounding sphere packing. 

-------------------------------------------------------------
  Key Details/Computational Tools Used in Correctness Proof
-------------------------------------------------------------

We use black-box computations in two steps: 
  1. Producing a basis of modular forms of weight k and level N (which is subdivided as a basis of Eisenstein series and normalized cuspidal eigenforms.
  2. Computing the image of the Atkin-Lehner involution on elements of a basis.
  Aside from these steps, the main computations are linear algebra (used to rewrite forms in terms of this basis so that the Atkin-Lehner involution can be computed more generally, and also for bounding terms in the positivity computation, as described in the paper.) Ultimately, the LP-solver portion of the computation does not appear in the actual proof, since it essentially provides a modular form certificate, which is then separately verified.

We discuss 2 first, since it comes up early in our computation, and the computation is somewhat simpler using built-in functions. Essentially, the claim here is that the dual form is actually the dual form.

Repressing some technical details (typecasting, etc) to produce the basis of the cuspidal subspace the getBases.magma file crucially relies on the functions:
    M := ModularForms(level,weight);
    C := CuspidalSubspace(M);
    B := Basis(C,prec);
 and to produce the basis of the Eisenstein subspace uses:
    ESeries := EisensteinSeries(M);
    E := [qExpansion(e, prec): e in ESeries];
To produce the dual basis for cuspidal elements, we use:
    A := AtkinLehnerOperator(C,level);
which computes the operator as a matrix in terms of the basis above, and use this matrix and the q-expansions of the basis to compute the dual basis.
To produce the dual basis for Eisenstein elements, we use:
    [AtkinLehnerOperator(level,e): e in ESeries];

At the time of writing the code, we were unable to find any code that would handle both cases in one shot, hence the somewhat piecemeal approach. 

Step 1 is used when checking that a form has all non-negative coefficients. We briefly summarize the approach here - full details can be found in our paper. The key observations are:
  1. The explicit formulas for Eisenstein series can be used to give quite tight bounds on the sizes of the coefficients of the q-expansion of any modular form in the Eisenstein subspace. Typically, the coefficient a_n is either 0 or of order n^{k-1}, where the leading term can be explicitly determined in terms of the coordinates of the modular form in terms of the basis given by Eisenstein series.
  2. The Deligne-Weil bounds (or similar lower-tech bounds) give explicit upper bounds of order n^{k/2} for the magnitude of the coefficients of normalized, new, cuspidal eigenforms. Of course, these can be used to give explicit bounds for old eigenforms, and then any cuspidal form, in terms of its coordinates with respect to a basis of eigenforms.
  3. n^{k-1} >> n^{k/2}, so as long our bounds suffice to check that the Eisenstein part is always positive, checking positivity of a modular form reduces to checking that the first N coefficients of the q-expansions of the modular form are postive, where N is some explicitly computable value. In practice, the size of N is not very large, so this step is never limiting factor on our computation.

For the Eisenstein series bound, we take advantage of the fact that Magma's Eisenstein series remember the formula that defines them. Sufficient data to reconstruct the formula can be accessed via:
    EisensteinData(ESeries[e])
For the CuspForm bound, we use the functions:
    C := CuspForms(d, weight);
    newforms := Newforms(C);
and take q-expansions via:
    qExpansion
We explicitly compute q-expansions of the old forms from new forms of lower level.


-----------------------------
  Design Decisions & Issues
-----------------------------

Q. Why use both Sage and Magma?

A. At the time of writing, Magma was the only computer algebra software we could find which could compute the Atkin-Lehner operator on a cuspidal modular form. However, there is limited if any support for solving LPs. Sage has an excellent interface with both many LP-solvers and with Magma, and so provided a natural bridge with as little scripting as possible.


Q. Why can't you handle levels with square factors (except for factors of 24^2)? 

A. Outside of these levels, the nebentype is not always totally real, which has the effect that there are modular forms with irrational coefficients, even if we restrict to the real part of the q-expansions. This adds a number of computational challenges (particular certifying that things that look zero are zero and that forms have all positive coefficients), which are certainly not insurmountable. However, since we run up against computational barriers while solving the linear program even without this added complexity, the possibility of small marginal gains didn't seem to justify the effort.


Q. Why can't you use forms of weight 2?
  
A. It isn't clear that the machinery works for forms of weight 2, for a couple of reasons.
  1. Any proof of a Poisson summation analogue would be far more complicated in weight 2, since 
     a. The functional equation of the modular form has an extra term in this case, which I would expect to show up in any analogue.
     b. Convergence issues in weight 2 are much more subtle. Each occassion where sums are switched would need to be handled much more carefully. 
  2. The Atkin-Lehner operator is not implemented for forms of weight 2 (to my knowledge), and implementing would be a substatial task beyond the bounds of this project.































 



