library('doParallel')

args <- commandArgs(trailingOnly = TRUE)
cat(args,"\n")

perform_room_simulation <- function(x_length,y_length,num_people){
    #given dimensions of the room, and number of people return all pairwise distances
    x=runif(num_people, min = 0, max = x_length)
    y=runif(num_people, min = 0, max = y_length)
    df=t(rbind(x,y))
    df_dist=dist(df)
    #return(df_dist)
    to_return=as.list(df_dist)
    to_return=lapply(to_return,round,5)
    return(to_return)
}

start.time <- Sys.time()
x_length=as.integer(args[2])
y_length=as.integer(args[3])
num_people=as.integer(args[4])
max_iterations=as.integer(args[5])
#are we running a single core simulation, or run multicore? If local simulation, run single core
#if we are using SageMaker Processing, using multicore
is_local=as.integer(args[6]) 


num_to_parallelize <- detectCores(all.tests = FALSE, logical = TRUE) #find out how many cores are on the machine
if (is_local==1){
    num_to_parallelize=1
}
cl <- makeCluster(num_to_parallelize)
registerDoParallel(cl)



cat("x_length: ", x_length, "\n")
cat("y_length: ", y_length, "\n")
cat("num_people: ", num_people, "\n")
cat("max_iterations: ", max_iterations, "\n")


cat("Running in parallel with ", num_to_parallelize, "cores.\n")
start.time <- Sys.time()
result <- foreach (i =1:max_iterations) %dopar%
    {
        mini_result=perform_room_simulation(x_length=x_length,y_length=y_length,num_people=num_people)
        mini_result=unlist(mini_result)
        mini_result_pre=mini_result
        num_violates=length(mini_result[mini_result <6]) #number of violations of social distancing 
        average_violations_per_person=num_violates/num_people
        average_violations_per_person = average_violations_per_person *2
    }

result=unlist(result)
end.time <- Sys.time()
time.taken <- end.time - start.time
time_taken=time.taken
print(time_taken)
#cat("Finished simulation in ",time_taken," seconds.\n")
cat ("Simulation Mean: ",mean(result),"\n")
cat("Simulation Standard Deviation: ", sd(result), "\n")

#Write out the results to S3 if using SageMaker processing
if (is_local !=1){
    write(as.character(mean(result)), file = "/opt/ml/processing/output/output_result_mean.txt", append = TRUE)
}

#write(sd(result), file = "/opt/ml/processing/output/output_result_sd.txt", append = TRUE)