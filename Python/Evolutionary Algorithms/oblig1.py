from __future__ import division
import random, numpy, math, copy, matplotlib.pyplot as plt
import time
import itertools
import csv
with open("european_cities.csv", "r") as f:
    data = list(csv.reader(f, delimiter=';'))

def exhaustive_search(a):
	print()
	print(a)
	start_time = time.time()
	indexList=[0]
	b=1
	while b<a:
		indexList.append(b)
		b=b+1
		
	shortest=0
	path=[]
	
	optTable=itertools.permutations(indexList, a)
	optTable=list(optTable)
	optTable=optTable[:int(len(optTable)/a)] #_ startpunktet spiller ingen rolle, så kutter av alt unntatt startpunkt 0 for å spare prosesstid
	
	for opt in optTable[1:]:
		sum=0.0
		for o in opt:
			if opt.index(o)==a-1:
				sum=sum+float(data[o+1][opt[0]])
			else:
				sum=sum+float(data[o+1][opt[opt.index(o)+1]])
		if shortest==0 or sum<shortest:
			shortest=sum
			path=[]
			for e in opt:
				path.append(data[0][e])
	
			
	print("TID: %s sekunder" % (time.time() - start_time))
	print(shortest)
	print(path)
	return [path,shortest,(time.time() - start_time)]
	
def hill_climber(sequence,a):
	saveseq=sequence
	start_time = time.time()
	shortest=0
	path=[]
	
	sum1=0.0
	for i in range(0,a-1):
		if i==a-1 :
			sum1=sum1+data[sequence[a]][sequence[0]]
		else:
			sum1=sum1+float(data[sequence[i]+1][sequence[i+1]])
	t=list(range(len(sequence)))
	y=random.choice(t)
	t.remove(y)
	for j in t:
		dics =[y,j]  #_ this is now fancier by trying more index swaps
		swappedSequence=sequence
		swappedSequence[dics[0]]=sequence[dics[1]]
		swappedSequence[dics[1]]=sequence[dics[0]]
		
		sum2=0.0
		for i in range(0,a-1):
			if i==a-1 :
				sum2=sum2+data[swappedSequence[a]][swappedSequence[0]]
			else:
				sum2=sum2+float(data[swappedSequence[i]+1][swappedSequence[i+1]])
		if sum1>sum2:
			sum1=sum2
			sequence=swappedSequence
		else:
			shortest=sum1
	
	for i in sequence:
			path.append(data[0][i])
	if not saveseq.all() == sequence.all():
		s=hill_climber(sequence,a)
		shortest=s[0]
		path=s[1]
	
	return shortest, path,(time.time() - start_time),sequence
	
def childOf(parent):
	#_ we'll mutate a quarter of the genotype
	child=parent
	mut=random.choice(range(len(parent)))
	mutL=[]
	for i in range(math.ceil(len(parent)/4)):
		if (mut+i)==len(parent):
			mut=-i
			mutL.append(parent[mut+i])
		else:
			mutL.append(parent[mut+i])
	mutL=numpy.random.permutation(mutL)		
			
	for i in range(math.ceil(len(parent)/4)):
		if (mut+i)==len(parent):
			mut=-i
			child[mut+i]=mutL[i]
		else:
			child[mut+i]=mutL[i]
			
	return child

#_ make breeding algorithm childOf(parent1,parent2) if there's time
	
def genetic_algorithm(population,generations,a):
	#_would've liked to use the random.seed() for genotypes, but I didn't have time to go through its functionality. I'm not quite comfortable in python yet(I WANT MY SEMICOLONS BACK!).
	start_time = time.time()
	elite=0.0
	elitepath=[]
	elitegeno=[]
	newpopulation=[]
	hallOfFame=[]
	
	#_ set elite, make selection and generate new population
	ranking=[] #_ From high to low fitness
	
	#_ fitness check
	for populant in population:
		pv=0.0
		populant=list(populant)
		for dex in populant:
				if populant.index(dex)==a-1:  
					pv=pv+float(data[dex+1][populant[0]])
				else:
					pv=pv+float(data[dex+1][populant[populant.index(dex)+1]])
		if elite==0.0 or pv<elite:
			elitegeno=populant[:a]
			elite=pv
		taggedPopulant=populant
		taggedPopulant.append(pv)	
		ranking.append(taggedPopulant)	
	ranking=sorted(ranking, key=lambda ranking: ranking[a])
	#_ The one ranked lowest(highest value) will always get a child, as a simple diversity preservation measure. Don't want those local minima.
	#_ The elite will get a child in addition the one it receives from ranking high.
	#_ We keep half(rounded) the highest ranked population, and grant them children. The population will then increase every generation(maybe I'll put in a populant cap later).
	newpopulation.append(elitegeno)
	newpopulation.append(childOf(elitegeno))
	newpopulation.append(childOf(ranking[len(ranking)-1][:a]))
	for high in ranking[:math.ceil(len(ranking)/2)]:
		newpopulation.append(high[:a])
		newpopulation.append(childOf(high[:a]))
	hallOfFame.append(elite)
	if generations!=0:
		mutant=genetic_algorithm(newpopulation,generations-1,a)
		if(mutant[4]<elite):
			elitegeno=mutant[0]
			elite=mutant[4]
		hallOfFame.extend(mutant[3])
	
	
	for i in elitegeno:
			elitepath.append(data[0][i])
	
	return elitegeno, elitepath, (time.time() - start_time), hallOfFame, elite

def hybrid_algorithm(population,generations,a): #_ just add hill climbers not done
	#_would've liked to use the random.seed() for genotypes, but I didn't have time to go through its functionality. I'm not quite comfortable in python yet(I WANT MY SEMICOLONS BACK!).
	start_time = time.time()
	elite=0.0
	elitepath=[]
	elitegeno=[]
	newpopulation=[]
	hallOfFame=[]
	
	#_ set elite, make selection and generate new population
	ranking=[] #_ From high to low fitness
	
	#_ fitness check
	for populant in population:
		pv=0.0
		populant=list(populant)
		for dex in populant:
				if populant.index(dex)==a-1:  
					pv=pv+float(data[dex+1][populant[0]])
				else:
					pv=pv+float(data[dex+1][populant[populant.index(dex)+1]])
		if elite==0.0 or pv<elite:
			
			elitegeno=populant[:a]
			elite=pv
		taggedPopulant=populant
		taggedPopulant.append(pv)	
		ranking.append(taggedPopulant)	
	ranking=sorted(ranking, key=lambda ranking: ranking[a])
	#_ The one ranked lowest(highest value) will always get a child, as a simple diversity preservation measure. Don't want those local minima.
	#_ The elite will get a child in addition the one it receives from ranking high.
	#_ We keep half(rounded) the highest ranked population, and grant them children. The population will then increase every generation(maybe I'll put in a populant cap later).
	
	newpopulation.append(elitegeno)
	newpopulation.append(childOf(elitegeno))
	newpopulation.append(childOf(ranking[len(ranking)-1][:a]))
	for high in ranking[:math.ceil(len(ranking)/2)]:
		newpopulation.append(high[:a])
		newpopulation.append(childOf(high[:a]))
	
	hallOfFame.append(elite)
	if generations!=0:
		mutant=hybrid_algorithm(newpopulation,generations-1,a)
		if(mutant[4]<elite):
			elitegeno=mutant[0]
			elite=mutant[4]
		hallOfFame.extend(mutant[3])
	
	for i in elitegeno:
			elitepath.append(data[0][i])
	
	r=hill_climber(elitegeno,a)
	elite=r[0]
	elitegeno=r[3]
	elitepath=r[1]
	
	return elitegeno, elitepath, (time.time() - start_time), hallOfFame, elite
	
exhaustive_search(4)
exhaustive_search(6)
exhaustive_search(8)
exhaustive_search(10)
#_ exhaustive_search(14) commented because it crashes my computer

hclist10=[]
hclist24=[]
for m in range(20):
	for i in [10,24]: 
		b = list(range(i))
		k = hill_climber(numpy.random.permutation(b),b[len(b)-1]) 
		if i==10:
			hclist10.append(k[0])
		else:
			hclist24.append(k[0])
print()
print("HILL CLIMBER")
print("10 cities; minimum, maximum, average/mean and standard deviation, respectively:")
print(min(hclist10))
print(max(hclist10))
print(sum(hclist10)/len(hclist10))
print(numpy.std(hclist10))
print()
print("24 cities; minimum, maximum, average/mean and standard deviation, respectively:")
print(min(hclist24))
print(max(hclist24))
print(sum(hclist24)/len(hclist24))
print(numpy.std(hclist24))
print()
print()
			
plotter10=[]
plotter24=[]
galist10=[]
galist24=[]	
for subplot in [10,20,50]:			
	for m in range(20):
		for b in [10,24]:
			pop=[]
			for poppy in range(subplot):
				pop.append(numpy.random.permutation(b))
			u = genetic_algorithm(pop,50,b)
			
			if b==10:
				galist10.append(u[4])
				plotter10.append(u[3])
			else:
				galist24.append(u[4])
				plotter24.append(u[3])
	
	plt.plot([sum(e)/len(e) for e in zip(*plotter10)],'r',linewidth=(subplot/10.0))
	plt.plot([sum(e)/len(e) for e in zip(*plotter24)],'g',linewidth=(subplot/10.0))
plt.ylabel('wider line means bigger population')
plt.xlabel('generation')
plt.show()
print("GENETIC ALGORITHM")
print("10 cities; minimum, maximum, average/mean and standard deviation, respectively:")
print(min(galist10))
print(max(galist10))
print(sum(galist10)/len(galist10))
print(numpy.std(galist10))
print()
print("24 cities; minimum, maximum, average/mean and standard deviation, respectively:")
print(min(galist24))
print(max(galist24))
print(sum(galist24)/len(galist24))
print(numpy.std(galist24))
#_ would've been fun to make an algorithm that measured the optimal amount of generations needed to beat both speed and quality
print("Now for a special treat: a really simple hybrid algorithm!:")
for b in [10,14,24]:
	print()
	print(b)
	pop=[]
	for poppy in range(b):
		pop.append(numpy.random.permutation(b))
	u = hybrid_algorithm(pop,50,b)
	x=u[3]
	plt.plot(x)
	plt.ylabel('path length')
	plt.xlabel('generation')
	plt.show()
	print("TID: %s sekunder" % u[2])
	print(u[0])
	print(u[4])
	print(u[1])