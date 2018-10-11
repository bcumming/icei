# ARBOR build and benchmarks for ICEI

## Building Arbor

The `build.sh` file get the Arbor source, configure with CMake, then build the Arbor benchmarks.

It uses a `.in` file to configure the environment. There are two `.in` examples provided:
* `desktop.in` builds vectorized multicore version on my Linux desktop systems with OpenMPI installed.
* `daint-gpu.in` builds the GPU version on Piz Daint.

At the moment it clones the repository from GitHub, you might want to choose another source like a tar ball.
If you do choose a tar ball, make sure that all the dependencies (git submodules) are included.

## Benchmarks

### Ring

A ring

This benchmark is designed to test the computational and memory throughput of a single node.
Not all nodes are equal, for example the following three nodes:
1. GPU node on Piz Daint: 1 P100 GPU + 1 socket Haswell CPU.
2. GPU node on Piz Daint: 2 socket Broadwell CPU.
3. Node on Summit: 6 V100 GPU + 2 socket Power 9 CPU.

The ring benchmark uses a basic unit:
* 8192 cells with:
    * 15 branches and 150 compartments
    * 10,000 synapses
* 

The procedure for benchmarking a node is follows:
* take the 
