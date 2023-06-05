import numpy as np
import pandas as pd
from scipy.stats import norm
import statistics
from math import sqrt,log,exp,erf
from matplotlib import pyplot as plt

def getHistoricalVolatility(data, months, n):
	n,m = data.shape

	n1 = min(n, months*21)
	sigma = []
	
	
	for i in range(m):
		arr = np.array(data.iloc[n-n1:n-1,i])
		arr = np.log(arr)
		j = arr.size-1
		while j > 0:
			arr[j] = arr[j] - arr[j-1]
			j = j - 1
		arr[0] = arr[0] - np.log(data.iloc[n-n1-1,i])
		sigma.append(sqrt(252*statistics.variance(arr)))
	return sigma

def getOptionPrices(S, Sigma, K, months, r):
	c = []
	p = []
	T = months / 12.0
	n = S.size
	c1 = []
	p1 = []
	for i in range(n):
		S0 = S[i]
		k = K[i]
		sigma = Sigma[i]
		d1 = (log(S0/k) + (r + sigma*sigma/2)*(T)) / (sigma*sqrt(T))
		d2 = d1 - sigma*(sqrt(T))
		pv = k * exp(-r*T)
		Nd1 = norm.cdf(d1)
		Nd2 = norm.cdf(d2)
		callPrice = S0*Nd1 - Nd2*pv
		c1.append(callPrice)
		p1.append(pv - S0 + callPrice)
	return c1,p1

def solve():
	index = ["nsedata1.csv", "bsedata1.csv"]

	for ind in index:
		print(ind)
		data = pd.read_csv(ind)
		names = data.columns
		n,m = data.shape
		# 1a
		historicalVolatilities = getHistoricalVolatility(data, 1, n)
		for i in range(10):
			print(names[i], " -- ", historicalVolatilities[i])
		
		# 1b
		K = data.iloc[n-1,:]
		r = 0.05
		c = []
		p = []
		for j in range(11):
			a = 0.5 + j * 0.1
			callPrices1, putPrices1 = getOptionPrices(data.iloc[n-1,:], historicalVolatilities, a*K, 6, r)
			c.append(callPrices1)
			p.append(putPrices1)

		c= np.array(c)
		p = np.array(p)
		X = np.arange(0.5,1.6,0.1)
	
		for i in range(10):
			plt.figure(i+1)
			f, (ax1, ax2) = plt.subplots(1,2)
			ax1.plot(X, c[:,i])
			ax1.title.set_text("callPrice vs Strike Price")
			ax2.plot(X, p[:,i])
			ax2.title.set_text("Put Price vs Strike Price")
			f.suptitle(names[i])
			f.show()
			#f.savefig(ind+"plot"+str(i+1)+".png")

		# 1c
		c1 = []
		p1 = []
		for i in range(1,12):
			historicalVolatilities = getHistoricalVolatility(data, i, n)
			callPrices1, putPrices1 = getOptionPrices(data.iloc[n-1,:], historicalVolatilities, K, 6, r)
			c1.append(callPrices1)
			p1.append(putPrices1)
		c1 = np.array(c1)
		p1 = np.array(p1)
		X = np.arange(1,12,1)
	
		for i in range(10):
			plt.figure(i+1)
			f, (ax1, ax2) = plt.subplots(1,2)
			ax1.plot(X, c1[:,i])
			ax1.title.set_text("callPrice vs LookBackTime")
			ax2.plot(X, p1[:,i])
			ax2.title.set_text("Put Price vs LookBackTime")
			f.suptitle(names[i])
			f.show()
			#f.savefig(ind+"plot1"+str(i+1)+".png")


if __name__ == "__main__":
	solve()



	