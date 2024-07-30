"""
For comparing outputs of PUF to mult
"""

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.metrics import r2_score
import re

############### Read ILA data ################
file1 = r"C:\Users\Rory\Documents\HDL\Stochastic_tests\Outputs\LFSR_SNG_mult_test1.csv"

df1 = pd.read_csv(file1)

# Delete row 2 and rewrite to file
if "UNSIGNED" in df1.iloc[0].values:
    df2 = df1.drop(index=0).reset_index(drop=True)
    df2.to_csv(file1, index=False)
######### 

df = pd.read_csv(file1)

# Set start and end range
row_index_done = (df[df['done[0:0]'] == 1].index)
data = df.iloc[row_index_done, 5:]

## ILA results
mul_out_int8 = data.loc[:, "mul_out[0][7:0]":"mul_out[49][7:0]"].values.tolist()[0]


############ Functions #################
def bipolar_to_prob(y):
    return (y+1)/2

def bipolar_to_prob_int(y):
    return int(bipolar_to_prob(y)*256)

def prob_to_bipolar(x):
    return (2*x)-1

def prob_int_to_bipolar(x):
    return prob_to_bipolar(x/256)

def prob_int16_to_bipolar(x):
    return prob_to_bipolar(x/65536)



############ Python data #################
num1_tests = [163, 149, 98, 109, 131, 46, 183, 22, 243, 121, 151, 186, 152, 9, 131, 208, 207, 111, 105, 179, 165, 156, 149, 218, 175, 125, 188, 187, 86, 49, 215, 95, 241, 196, 245, 187, 66, 172, 162, 75, 161, 168, 141, 121, 205, 46, 160, 0, 63, 129]
num2_tests = [10, 241, 139, 249, 142, 98, 3, 33, 178, 242, 115, 127, 231, 171, 179, 132, 32, 15, 128, 2, 222, 49, 249, 6, 110, 54, 83, 213, 151, 171, 52, 174, 217, 149, 132, 11, 190, 194, 228, 70, 69, 159, 48, 225, 153, 5, 85, 133, 208, 254]

num1_float = [ prob_int_to_bipolar(x) for x in num1_tests ]
num2_float = [ prob_int_to_bipolar(x) for x in num2_tests ]
mul_res_float = [num1_float[i]*num2_float[i] for i in range(50)]

############### ILA data #################
mul_res_ila_float = [prob_int_to_bipolar(x) for x in mul_out_int8]


############### Plot results #################
plt.figure(1)
plt.title("Multiply test LFSR_SNG")
plt.scatter(mul_res_float, mul_res_ila_float)
plt.axline( (-1,-1), (1,1), color='r' )
plt.xlabel("Python values")
plt.ylabel("ILA values")
plt.grid()

plt.show()

############### Get Metrics ###############
r2 = r2_score(mul_res_float, mul_res_ila_float)
print(f"R^2 score: {r2}")
