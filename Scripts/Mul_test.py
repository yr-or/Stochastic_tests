def prob_to_bipolar(x):
	return (2*x)-1

def prob_int_to_bipolar(x):
	return prob_to_bipolar(x/256)

def bipolar_to_prob(y):
	return (y+1)/2

def bipolar_to_prob_int(y):
	return int(bipolar_to_prob(y)*256)


prob1 = 86
prob2 = 67

mul_out = []

# Convert to float
prob1_float = prob_int_to_bipolar(prob1)
prob2_float = prob_int_to_bipolar(prob2)

print(f"prob1: {prob1_float}, prob2: {prob2_float}")

# Multiply each term
mul_out = prob1_float*prob2_float
print(f"Actual result = {mul_out}")

# Convert to int
print( f"Bipolar int16 result: {bipolar_to_prob_int(mul_out)}" )