library(reticulate)

use_condaenv(condaenv = 'r-reticulate') # this is where we installed the SageMaker Python SDK
sagemaker <- import('sagemaker')
session <- sagemaker$Session()
bucket <- session$default_bucket()
role_arn <- session$expand_role(role='sagemaker-service-role')

## using r_container
container <- 'URI TO CONTAINER AND TAG' # can be found under $ docker images. Remember to include the tag

# one single run
processor <- sagemaker$processing$ScriptProcessor(role = role_arn,
                                                  image_uri = container,
                                                  command = list('/usr/bin/Rscript'),
                                                  instance_count = 1L,
                                                  instance_type = 'ml.m5.4xlarge',
                                                  volume_size_in_gb = 5L,
                                                  max_runtime_in_seconds = 3600L,
                                                  base_job_name = 'social-distancing-simulation',
                                                  sagemaker_session = session)

max_iterations <- 10000
x_length <- 1000
y_length <- 1000
num_people <- 1000

is_local <- 0 #we are going to run this simulation with SageMaker processing
result=processor$run(code = 'Social_Distancing_Simulations.R',
              outputs=list(sagemaker$processing$ProcessingOutput(source='/opt/ml/processing/output')),
              arguments = list('--args', paste(x_length), paste(y_length), paste(num_people), paste(max_iterations),paste(is_local)),
              wait = TRUE,
              logs=TRUE
                )

get_job_results <- function(session,processor){
    #get the mean results of the simulation
    the_bucket=session$default_bucket()
    job_name=processor$latest_job$job_name
    cmd=capture.output(cat('aws s3 cp s3://',the_bucket,"/",job_name,"/","output/output-1/output_result_mean.txt .",fill = FALSE,sep="")
    )
    system(cmd)
    my_data <- read.delim('output_result_mean.txt',header=FALSE)$V1
    return(my_data)
    }

simulation_mean=get_job_results(session,processor)
cat(simulation_mean)
