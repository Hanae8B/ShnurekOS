mkdir -p boot \
kernel/core kernel/memory kernel/modules kernel/drivers kernel/fs kernel/ipc kernel/syscall \
user/init user/shell user/desktop user/apps user/services \
gui/compositor gui/windowmgr gui/graphics gui/input \
libs/libcxx libs/libgfx libs/libfs libs/libcore \
net/protocols net/drivers net/services \
tools config docs tests .github/workflows

touch kernel/kernel.cpp README.md Makefile .github/workflows/build.yml
