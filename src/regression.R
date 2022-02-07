# load library
library(MASS)
set.seed(88)
# read data
file<-"deepstream_xavier_normalized.csv"
df<-read.csv(file,sep=",")

# perform stepwise regression
stepwise_regression <- function(data,s) {
    if (s=="throughput") {
        X <- subset(df, select=c("core_freq", "gpu_freq", "emc_freq",   
                                  "cache_pressure","swappiness","dirty_ratio",
                                  "dirty_bg_ratio","drop_caches","policy",
                                  "sched_rt_runtime","sched_child_runs_first","memory_growth",
                                  "throughput","interval","bitrate",
                                  "batch_size","qos","padding",
                                  "batched-push-timeout","cache_size","crf",
                                  "buffer_size","presets","maxrate",
                                  "buffer_pool_size","nvbuf_mem_type","sync_inputs",
                                  "active_cores","net_scale_factor","offset",
                                  "process_mode","use_dla_core","enable_dla",
                                  "enable_dbscan","sec_reinfer_interval","maintain_aspect_ratio",
                                  "iou_thereshold","enable_batch","enable_past_frame",
                                  "compute_hw","dirty_bytes","nr_hugepages",
                                  "sched_rt_period","sched_migration","sched_nr_migrate",
                                  "sched_time_avg","kernel_numa_balancing","kernel_numa_balancing_latency",
                                  "min_free_kbytes","overcommit_ratio","min_granularity",
                                  "sched_timeslice","sched_time_avg"))
         
         
         Y<-X$throughput
         X <- subset (X, select = -throughput)
    } else if (s=="total_energy_consumption") {
       X <- subset(df, select=c("core_freq", "gpu_freq", "emc_freq",   
                                "cache_pressure","swappiness","dirty_ratio",
                                "dirty_bg_ratio","drop_caches","policy",
                                "sched_rt_runtime","sched_child_runs_first","memory_growth",
                                "total_energy_consumption","interval","bitrate",
                                "batch_size","qos","padding",
                                "batched-push-timeout","cache_size""crf",
                                "buffer_size","presets","maxrate",
                                "buffer_pool_size","nvbuf_mem_type","sync_inputs",
                                "active_cores","net_scale_factor","offset",
                                "process_mode","use_dla_core","enable_dla",
                                "enable_dbscan","sec_reinfer_interval","maintain_aspect_ratio",
                                "iou_thereshold","enable_batch","enable_past_frame",
                                "compute_hw","dirty_bytes","nr_hugepages",
                                "sched_rt_period","sched_migration","sched_nr_migrate",
                                "sched_time_avg","kernel_numa_balancing","kernel_numa_balancing_latency",
                                "min_free_kbytes","overcommit_ratio","min_granularity",
                                "sched_timeslice","sched_time_avg"
          ))
         
         
         Y<-X$total_energy_consumption
         X <- subset (X, select = -total_energy_consumption)
  
    } else
        return
    
    
    model<-lm(Y ~ .,data=X)
    stepwise_model=step(model, scope= . ~ . ^6, direction= 'both')
    return (stepwise_model$coefficients)
    
}

# Throughput
thm=stepwise_regression(df,"throughput")
# energy
the=stepwise_regression(df,"total_energy_consumption")

