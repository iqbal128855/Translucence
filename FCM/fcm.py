import cdt
import os
import pandas as pd
path = os.path.abspath(cdt.__file__)
print (path)
from cdt import SETTINGS
SETTINGS.verbose=False
SETTINGS.NJOBS=16
import networkx as nx
import time

import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

data=pd.read_csv("Image-Xavier.csv")
data=data[["swappiness","context-switches","cycles",
           "memory_growth","cache_pressure","policy",
           "sched_child_runs_first","sched_rt_runtime",
           "inference_time","total_energy_consumption","drop_caches",
           "dirty_ratio","dirty_bg_ratio","core_freq","gpu_freq","emc_freq",
           "branch-misses","minor-faults","sched:sched_stat_sleep","cpu_utilization",
           "sched:sched_migrate_task","irq:softirq_entry","major-faults","cache-misses","cache-loads","cache-loads-misses"]]
from cdt.independence.graph import FSGNN

Fsgnn = FSGNN(train_epochs=1, test_epochs=1, l1=0.1, batch_size=100)

ugraph = Fsgnn.predict(data, threshold=1e-7)

from cdt.causality.pairwise import GNN
from cdt.utils.graph import dagify_min_edge

print (ugraph)
gnn = GNN(nruns=1, train_epochs=1, test_epochs=1, batch_size=100)
ograph = dagify_min_edge(gnn.orient_graph(data, ugraph))
print (ograph)
from cdt.causality.graph import CGNN
Cgnn = CGNN(nruns=1, train_epochs=1, test_epochs=1, batch_size=100)

dgraph = Cgnn.orient_directed_graph(data, ograph)
print (dgraph.edges())
cdf = pd.DataFrame(list(dgraph.edges(data='weight')), columns=['Cause', 'Effect', 'Score'])
print (cdf)
