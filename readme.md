# ARBOR build and benchmarks for ICEI

The `build.sh` file will check out and build the Arbor benchmarks.

It uses a `.in` file to configure the environment. There are two `.in` examples provided:
* `desktop.in` builds vectorized multicore version on my Linux desktop systems with OpenMPI installed.
* `daint-gpu.in` builds the GPU version on Piz Daint.
