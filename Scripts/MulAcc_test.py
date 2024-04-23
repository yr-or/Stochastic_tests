def prob_to_bipolar(x):
	return (2*x)-1

def prob_int_to_bipolar(x):
	return prob_to_bipolar(x/256)

def bipolar_to_prob(y):
	return (y+1)/2

def bipolar_to_prob_int(y):
	return int(bipolar_to_prob(y)*256)


inputs = [156, 150, 123, 163, 93, 200, 72, 21]
weights = [156, 150, 123, 163, 93, 200, 72, 21]

mul_out = []

for i in range(len(inputs)):
	# Convert to float
	inputs_i_float = prob_int_to_bipolar(inputs[i])
	weights_i_float = prob_int_to_bipolar(weights[i])
	# Multiply each term
	mul_out.append( inputs_i_float*weights_i_float )

# Add 1
sum_1 = [ (mul_out[i]+mul_out[i+1])/2 for i in range(4) ]
sum_2 = [ (sum_1[i]+sum_1[i+1])/2 for i in range(2) ]
sum_3 = (sum_2[0] + sum_2[1])/2

# Convert to int
print( bipolar_to_prob_int(sum_3) )