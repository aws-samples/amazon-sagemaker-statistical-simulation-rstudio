#local simulations on t3.xlarge
#First we will perform a very small simulation, with only 10 iterations
#USING Only 1 CPU
#takes about: 5.5 seconds
max_iterations <- 10
x_length <- 1000
y_length <- 1000
num_people <- 1000

local_simulation <- 1 # we are running the simulation locally on 1 vCPU
cmd= paste('Rscript Social_Distancing_Simulations.R --args',paste(x_length),paste(y_length), paste(num_people),paste(max_iterations),paste(local_simulation), sep = ' ')
result=system(cmd)


#takes about: 48 seconds
max_iterations <- 100
x_length <- 1000
y_length <- 1000
num_people <- 1000
cmd= paste('Rscript Social_Distancing_Simulations.R --args',paste(x_length),paste(y_length), paste(num_people),paste(max_iterations),paste(local_simulation), sep = ' ')
result=system(cmd)


#takes about: 460 seconds
max_iterations <- 1000
x_length <- 1000
y_length <- 1000
num_people <- 1000
cmd= paste('Rscript Social_Distancing_Simulations.R --args',paste(x_length),paste(y_length), paste(num_people),paste(max_iterations),paste(local_simulation), sep = ' ')
result=system(cmd)


#takes about: 4600 seconds (i.e. 1 hour and 16 minutes)
max_iterations <- 10000
x_length <- 1000
y_length <- 1000
num_people <- 1000
cmd= paste('Rscript Social_Distancing_Simulations.R --args',paste(x_length),paste(y_length), paste(num_people),paste(max_iterations),paste(local_simulation), sep = ' ')
result=system(cmd)



