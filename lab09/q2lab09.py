import numpy as numpy
import pandas as pd
from scipy.stats import norm

from math import sqrt,log,exp,erf

from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

import datetime as dt

def getImpliedVolatilityCall(T, k, C):
	x0 = 0.4
	x1 = 0.8
	r = 0.05
	S0 = 10910
	pv = k * exp(-r*T)
	cnt = 10
	while abs(x1 - x0) > 0.01 and cnt > 0 :
		x0 = x1
		sigma = x0
		d1 = log(S0/k)
		d1 = d1 + (r + sigma*sigma/2)*(T)
		print(sigma, T)
		d1 = d1 / (sigma*sqrt(T))
		d2 = d1 - sigma*(sqrt(T))
		Nd1 = norm.cdf(d1)
		Nd2 = norm.cdf(d2)
		callPrice = S0*Nd1 - Nd2*pv - C
		d11 = sqrt(T) - d1 / sigma
		callPrice1 = norm.pdf(d2)*sqrt(T)*pv
		x1 = x0 - (callPrice) / (callPrice1)
		cnt = cnt - 1

	return x1


def solve():

	data = pd.read_csv("NIFTYoptiondata.csv")
	n,m = data.shape
	
	X = []
	for i in range(1,n):
		temp1 = dt.datetime.strptime(data['Date'][i], '%d-%b-%Y')
		temp2 = dt.datetime.strptime(data['CallExpiry'][i], '%d-%b-%Y')
		X.append((temp2 - temp1) / dt.timedelta(days=365))

	# 1a
	Y = data['CallStrikePrice']
	Z = data['CallClose']

	figCall = plt.figure()
	ax = figCall.add_subplot(111, projection='3d')
	ax.scatter(X,Y,Z,'.')
	ax.set_xlabel('Maturity')
	ax.set_ylabel('StrikePrice')
	ax.set_zlabel('OptionPrice')
	#figCall.savefig('aIndexCallOption.png')
	plt.show()

	plt.figure()
	f, (ax1, ax2) = plt.subplots(2,1)
	ax1.scatter(X,Z)
	ax1.set_xlabel('Maturity')
	ax1.set_ylabel('Call Price')
	ax1.title.set_text('Call Price vs Maturity')
	ax2.scatter(Y,Z)
	ax1.set_xlabel('StrikePrice')
	ax1.set_ylabel('Call Price')
	ax2.title.set_text('Call Price vs StrikePrice')
	f.suptitle('NIFTY Call Option')
	f.show()

	Y = data['PutStrikePrice']
	Z = data['PutClose']

	figPut = plt.figure()
	ax = figPut.add_subplot(111, projection='3d')
	ax.scatter(X,Y,Z, '.')
	ax.set_xlabel('Maturity')
	ax.set_ylabel('StrikePrice')
	ax.set_zlabel('OptionPrice')
	#figPut.savefig('aIndexPutOption.png')
	plt.show()

	plt.figure()
	f, (ax1, ax2) = plt.subplots(2,1)
	ax1.scatter(X,Z)
	ax1.set_xlabel('Maturity')
	ax1.set_ylabel('Put Price')
	ax1.title.set_text('Put Price vs Maturity')
	ax2 .scatter(Y,Z)
	ax1.set_xlabel('StrikePrice')
	ax1.set_ylabel('Put Price')
	ax2.title.set_text('Put Price vs StrikePrice')
	f.suptitle('NIFTY Put Option')
	f.show()

	impliedVolatilityCall = []
	impliedVolatilityPut = []
	# 1b
	for i in range(1,2):
		impliedVolatilityCall.append(getImpliedVolatilityCall(X[i-1],data['CallStrikePrice'][i],data['CallClose'][i]))
		#impliedVolatilityPut.append(getImpliedVolatilityPut(X[i-1],data['PutStrikePrice'][i],data['PutClose'][i]))

if __name__ == "__main__":
	solve()