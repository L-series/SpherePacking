

/*CODE HAS TO BE WRITEN IN THE FORM OF A FUNCTION TO BE CALLED IN SAGEMATH FOR EXAMPLE*/

getBases(level,prec,weight) = {

list_of_spaces = List([]);
list_generators = List([]);
list_dual_generators=List([]);
list_generators_real=List([]);
list_generators_imaginary=List([]);
list_dual_generators_real=List([]);
list_dual_generators_imaginary=List([]);

/*#the command below construct all spaces mf(i) (where i is mod N) using a for loop#*/


for(i=1,level-1,
	if(gcd(i,level)==1,
		mf(i)=mfinit([level,weight,Mod(i,level)])
		)
	);



/*#the command below appends all spaces to the list list_of_spaces#*/

for(i=1,level-1,
	if(gcd(i,level)==1, listput(list_of_spaces,mf(i)))
	);


/*#the command below construct a basis for all spaces*/

for(i=1,level-1,
	if(gcd(i,level)==1, B(i)=mfbasis(mf(i)))
	);

/*#The command below construct all basis elements in the form of a sequence and appends it to list_generators*/

for(i=1,level-1,
	if(gcd(i,level)==1,for(j=1,length(B(i)),listput(list_generators,mf		embed(B(i)[j],mfcoefs(B(i)[j],prec)))))
	);

/*DUAL BASIS*/

for(i=1,level-1,
	if(gcd(i,level)==1,
		for(j=1,length(B(i)),
			listput(list_dual_generators,mfslashexpansion(mf(i),B(i)[				j],[0,-1;level,0],prec,0,&P))
			)
		)
	);



/*#the command below extracts the real and complex coefficients from the sequence of real coefficients*/
for(i=1,length(list_generators),listput(list_generators_real,real(list_generators[i])));
for(i=1,length(list_generators),listput(list_generators_imaginary,imag(list_generators[i])));



/*the command below writes to a text file the forms from all spaces*/

for(i=1,length(list_generators),write("/home/eva/Downloads/codecohen/out.txt",list_generators[i]));

/*#the command below writes to a text file the real part of the forms from all spaces

for(i=1,length(list_generators),write("/home/eva/Downloads/codecohen/out.txt",real(list_generators[i])));

#the command below writes to a text file the complex part of the forms from all spaces

for(i=1,length(list_generators),write("/home/eva/Downloads/codecohen/out.txt",imag(list_generators[i])));



*/


/*Dual basis bagay*/
for(i=1,length(list_dual_generators),listput(list_dual_generators_real,real(list_dual_generators[i])));

for(i=1,length(list_dual_generators),write("/home/eva/Downloads/codecohen/dualfullspace.txt",list_dual_generators_real[i]))

	
}







getdualbasis(level,prec,weight) = {


/*the command below writes to a text file the forms from all spaces*//*
for(i=1,length(list_dual_generators),write("C:/Users/relay/Desktop/PARI_GP/dualfullspace.txt",list_dual_generators[i])))

*/
	
}

transformtomatrix(filename) = {


	
}









