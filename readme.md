# ARBOR build and benchmarks for ICEI

## Building Arbor

The `build.sh` file get the Arbor source, configure with CMake, then build the Arbor benchmarks.

It uses a `.in` file to configure the environment. There are three `.in` examples provided:
* `desktop.in` builds vectorized multicore version on my Linux desktop systems with OpenMPI installed.
* `daint-gpu.in` builds the GPU version on Piz Daint.
* `daint-mc.in` builds the multicore version on Piz Daint.

At the moment it clones the repository from GitHub, you might want to choose another source like a tar ball.
If you do choose a tar ball, make sure that all the dependencies (git submodules) are included.

## Benchmarks

### Ring

A ring model is relatively simple model that connects N cells in a simple "ring network", where the first cell has a single connection to the second cell, and so on until the last cell, which connects back to the first cell. A spike in a cell will cause a spike in the second, and so forth.

The model thus has neglicable communication overheads, so it is ideal for measuring the computational throughput of cell-state integration.

This benchmark is designed to test the computational and memory throughput of a single node.
Not all nodes are equal, for example the following three nodes:
1. GPU node on Piz Daint: 1 P100 GPU + 1 socket Haswell CPU.
2. GPU node on Piz Daint: 2 socket Broadwell CPU.
3. Node on Summit: 6 V100 GPU + 2 socket Power 9 CPU.

The ring benchmark defined in `ring/input.json` has the following size
* 10000 cells with:
    * 15 branches and 150 compartments
    * 10,000 synapses
* duration 100 ms

The time to solution scales linearly with the number of cells, and the model weak scales perfectly.
On the other hand the model will stop strong scaling sooner on GPU architectures than on multicore.

The strategy for benchmarking a node is to pick the appropriate sized model (by scaling the number of cells in `ring/input.json`).
E.g. running two instances simply requires doubling the number of cells.
Then picking the number of MPI ranks and threads per rank.

* 2-socket CPU node: run a single instance with 2 MPI ranks and multithreading on the node.
* 2 GPU node: run a single instance with 1 MPI rank and multithreading.
* multiple GPU node: run one instance

The results on different nodes could normalised using `(time_to_solution / num_instances)`.
Further adjustments could be made for cost of ownership/energy requirements/etc.

The value being measured is the `model-run` time in seconds.

### example: running on Piz Daint multicore

*  2 MPI ranks (one per socket).
*  36 threads per rank (use hyperthreading on 18 core Broadwell socket)

```
> srun -n2 -c36 ../build/bin/ring input.json
gpu:      no
threads:  36
mpi:      yes
ranks:    2

Loading parameters from file: input.json
cell stats: 10000 cells; 152097 segments; 1488145 compartments.
running simulation

9 spikes generated at rate of 11.1111 ms between spikes

---- meters -------------------------------------------------------------------------------
meter                         time(s)      memory(MB)      energy(kJ)
-------------------------------------------------------------------------------------------
model-init                     10.677       -1661.977           1.443
model-run                      46.400           0.016          12.839
```

### example: running on Piz Daint GPU

*  1 MPI ranks (one per GPU).
*  24 threads per rank (use hyperthreading on 12 core Haswell socket)

```
> srun -n1 -c24 ../build/bin/ring input.json
gpu:      yes
threads:  24
mpi:      yes
ranks:    1

Loading parameters from file: input.json
cell stats: 10000 cells; 152097 segments; 1488145 compartments.
running simulation

9 spikes generated at rate of 11.1111 ms between spikes

---- meters -------------------------------------------------------------------------------
meter                         time(s)      memory(MB)  memory-gpu(MB)      energy(kJ)
-------------------------------------------------------------------------------------------
model-init                     30.214        1205.029        3850.371           2.914
model-run                      45.732           0.115           4.194           8.907
```
