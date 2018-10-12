msg() {
    echo
    printf "========================================================================\n"
    printf "= $*\n"
    printf "========================================================================\n"
    echo
}
exit_on_error() {
    if [ $? != 0 ]; then
        msg "  ERROR  $*"
        exit 1
    fi
}

base_path=`pwd`

source clean.sh

#
# Prologue
#

# Set up the environment, load modules, etc

# this will configure on an intel desktop system with OpenMPI installed
source desktop.in

# an example for configuring on Piz Daint GPU partition.
#source daint-gpu.in

# an example for configuring on Piz Daint multicore partition.
#source daint-mc.in

# Construct the arguments that will be passed to Arbor's CMake.
cmake_args="-DARB_WITH_MPI=ON -DARB_WITH_GPU=$arb_gpu -DARB_ARCH=$arb_arch -DARB_VECTORIZE=$arb_vectorize"

#
# download arbor from github
# you might want to replace this with a tar-ball?
#

repo_path="$base_path/arbor"
git_repo="https://github.com/arbor-sim/arbor.git"

msg "cloning repository from $git_repo"
git clone "$git_repo" "$repo_path" --recursive
exit_on_error "cloning repository"

#
# configure build with CMake
#

build_path="$base_path/build"
mkdir -p "$build_path"
msg "configure with CMake: cmake $repo_path $cmake_args"
cd "$build_path"
cmake "$repo_path" $cmake_args
exit_on_error "configuring"

#
# make ring and benchmark-cell benchmarks
#

msg "building ring and benchmark-cell benchmarks"
make -j8 ring bench
exit_on_error "building ring and bench benchmarks"
