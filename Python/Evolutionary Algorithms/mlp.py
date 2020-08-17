import numpy as np
import math
import random
import time

def sigmoid(k):
	k=round(k,200)
	return (1.0/(1.0+math.exp(-k)))
def dsigmoid(k):
	k=round(k,200)
	return k*(1-k)
class Neuron:
	def __init__(self,input,w,id):
		self.id=id
		self.input=input
		self.outconnections=[]
		self.inconnections=[]
		self.weights=[]
		self.beta=1
		self.eta=0.1
		self.momentum=0.0
		
		for i in range(w):
			self.weights.append(random.uniform(-1.0,1.0))
			
	def connect(self,out,neuron):
		if out:
			self.outconnections.append(neuron)
		else:
			self.inconnections.append(neuron)
		
	def setConnection(self,out,neuronarr):
		for neuron in neuronarr:
			if out:
				self.outconnections.append(neuron)
			else:
				self.inconnections.append(neuron)
			neuron.connect(not out,self)
			
	def updateinput(self,i):
		self.input=i
	
	def getinput(self):
		return self.input
		
	def getWeights(self):
		return self.weights
	
	def setWeights(self,new):
		self.weights=new
		
		
	def forward(self):
		s=0.0
		if self.inconnections:
			for i in range(len(self.inconnections)):
				s+=self.inconnections[i].getinput()*self.weights[i]
			self.updateinput(sigmoid(-self.beta*s))
			#self.updateinput(sigmoid(round(self.input,200)))
			
	def backpropagateError(self,target):
		delpar=0
		delta=dsigmoid(self.input)
		if(self.outconnections):
			for i in range(len(self.outconnections)):
				delpar+=self.weights[i]*self.outconnections[i].backpropagateError(target)
		else:
			delpar=(target[self.id]-self.input)
		delta=delta*delpar		
		for w in range(len(self.weights)):
			self.weights[w]=self.weights[w]-(self.eta*(delta*(self.inconnections[w].getinput())))
		return delta
			
class mlp:
	def __init__(self, inputs, targets, nhidden):
		self.inputlayer=[]
		self.hiddenlayer=[]
		self.outputlayer=[]
		startinput = -1.0
		
		for i in range(len(inputs[0])):
			self.inputlayer.append(Neuron(startinput,0,i))
		self.inputlayer.append(Neuron(-1,0,i))
		self.inputlayer[len(self.inputlayer)-1].setConnection(True,self.hiddenlayer)
		
		for i in range(nhidden):
			self.hiddenlayer.append(Neuron(0.0,len(inputs[0])+1,i))
			self.hiddenlayer[i].setConnection(False,self.inputlayer)
		self.hiddenlayer.append(Neuron(-1,0,i))
		self.hiddenlayer[len(self.hiddenlayer)-1].setConnection(True,self.outputlayer)
		
		for i in range(8):
			self.outputlayer.append(Neuron(0.0,nhidden+1,i))
			self.outputlayer[i].setConnection(False,self.hiddenlayer)
		
		
		#exit("exited")
		
	def inputarr(self,neurarr):
		inputarr=[]
		for neu in neurarr:
			inputarr.append(neu.getinput())
		return inputarr
	
	def earlystopping(self, inputs, targets, valid, validtargets,test,test_target):
			start_time=time.time()
			i = 0
			while(i<=100 and self.confusion(False,test,test_target)):
				self.train(inputs,targets)
				i+=1
			print("finished in time:")
			print(time.time()-start_time)
	def train(self, input, target, iterations=100):
		for i in range(iterations):
			r=random.randint(0,len(input)-1)
			inputs=input[r]
			targets=target[r]
			prediction=self.forward(inputs)
			for j in range(len(self.hiddenlayer)-1):
				self.hiddenlayer[j].backpropagateError(targets)

	def forward(self, inputs):
		for i in range(len(inputs)):
			self.inputlayer[i].updateinput(inputs[i])
		for hidden in self.hiddenlayer[:len(self.hiddenlayer)-1]:
			hidden.forward()
		for output in self.outputlayer:
			output.forward()
		return self.inputarr(self.outputlayer)

	def confusion(self, printtable, inputs, targets):
		nofit=True
		acc=[]
		classa=[0,0,0,0,0,0,0,0]
		classb=[0,0,0,0,0,0,0,0]
		classc=[0,0,0,0,0,0,0,0]
		classd=[0,0,0,0,0,0,0,0]
		classe=[0,0,0,0,0,0,0,0]
		classf=[0,0,0,0,0,0,0,0]
		classg=[0,0,0,0,0,0,0,0]
		classh=[0,0,0,0,0,0,0,0]
		table=[classa,classb,classc,classd,classe,classf,classg,classh]
		for i in range(len(inputs)):
			prediction=list(self.forward(inputs[i]))
			target=list(targets[i])
			table[target.index(1)][prediction.index(np.amax(prediction))]+=1
		for t in range(len(table)):
			a=0.0
			b=0.0
			for i in range(len(table[t])):
				if(i==t):
					a+=table[t][i]
				else:
					b+=table[t][i]
			acc.append(a/(a+b))
		totacc=0.0
		for i in acc:
			totacc+=i
		totacc=totacc/len(acc)
		if(totacc>=0.94):
			nofit=False
			
		if(printtable):
			for t in table:	
				print(t)
			print("classwise accuracy:")
			for a in acc:
				print(a*100)
			print("total accuracy:")
			print(totacc*100)
		return nofit
			