msg() {
    >&2 printf "== $*\n"
}
exit_on_error() {
    if [ $? != 0 ]; then
        msg "  ERROR  $*"
        exit 1
    fi
}

base_path=`pwd`

#
# prologue: set up environment
#

#source daint-mc.sh
#source daint-gpu.sh

#
# download arbor from github
#

repo_path="$base_path/arbor"
git_repo="https://github.com/arbor-sim/arbor.git"

log="$base_path/build_log"
rm -f "$log"

msg "cloning repository from $git_repo"
git clone "$git_repo" "$repo_path" --recursive &>> "$log"
exit_on_error "see ${log}"

#
# configure build with CMake
#

build_path="$base_path/build"
mkdir -p "$build_path"
msg "configure with CMake in $build_path"
cd "$build_path"
cmake "$repo_path"

