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

# These variables configure the build of Arbor, specifically which architecture to target

# Set to ON if targeting NVIDIA GPU.
# Arbor requires minimum CUDA 9
arb_gpu=OFF

# CPU architecture to target (still set this if targetting GPU)
# This corresponds to the GNU equivalent -march argument, e.g.
#   native, broadwell, haswell, skylake, knl, skylake-512
arb_arch=native

# Whether to use SIMD template library: set to ON if the target architecture supports
# one of AVX, AVX2 or AVX512.
arb_vectorize=ON

# Set the MPI compiler wrappers
# These should use either of
#   * gcc >= 6.0
#   * clang >= 4.0
# Note that CUDA will restrict which gcc version can be used.

export CC=`which mpicc`
export CXX=`which mpicxx`

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
# make ring and bench benchmarks
#

msg "building ring and bench benchmarks"
make -j8 ring bench
exit_on_error "building ring and bench benchmarks"
