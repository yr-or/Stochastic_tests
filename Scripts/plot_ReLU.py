import matplotlib.pyplot as plt
import re

def prob_to_bipolar(x):
	return (2*x)-1

def prob_int_to_bipolar(x):
	return prob_to_bipolar(x/256)

def bipolar_to_prob(y):
	return (y+1)/2

def bipolar_to_prob_int(y):
	return int(bipolar_to_prob(y)*256)

def unipolar_to_int(x):
	return int(x*256)

def int_to_unipolar(x):
	return x/256

inps = []
outs = []

regexp = re.compile(r"Input:\s+(?P<input>\d+), Output:\s+(?P<output>\d+)")
with open("C:\\Users\\Rory\\Documents\\HDL\\Stochastic_tests\\Stochastic_tests.sim\\sim_1\\behav\\xsim\\relu_data.txt", "r+") as f:
	for line in f:
		m = regexp.search(line)
		inps.append(int(m.group('input')))
		outs.append(int(m.group('output')))

x_bi = [prob_int_to_bipolar(x) for x in inps]
y_uni = [int_to_unipolar(y) for y in outs]

plt.figure(1)
plt.scatter(inps, outs)
plt.grid(True)

plt.figure(2)
plt.scatter(x_bi, y_uni)
plt.grid(True)
plt.xlabel("Input value")
plt.ylabel("Output value")
plt.title("ReLU data")

plt.show()




