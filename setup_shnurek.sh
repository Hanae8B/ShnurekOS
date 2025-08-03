#!/bin/bash

set -e

BASE_DIR="$HOME/ShnurekOS"

declare -A DIRS=(
  ["kernel/core"]="interrupts.asm scheduler.c pit.c pic.c"
  ["kernel/memory"]="paging.c heap.c alloc.c"
  ["kernel/syscall"]="trap_handler.c syscall.c"
  ["kernel/object"]="object_manager.c object_manager.h"
  ["kernel/process"]="process.c thread.c scheduler.c context_switch.asm"
  ["kernel/ipc"]="pipes.c sockets.c message_passing.c ipc.h"
  ["kernel/fs"]="vfs.c fat_driver.c ext2_driver.c file_descriptor.c"
  ["kernel/drivers"]="input.c disk.c display.c driver_loader.c"
  ["kernel/security"]="user_management.c access_control.c"
  ["user/init"]="init.c"
  ["user/shell"]="shell.c"
  ["user/desktop"]="desktop_manager.c"
  ["gui"]="compositor.c graphics_stack.c input_handler.c"
  ["net"]="tcp.c ip.c sockets.c dhcp.c"
  ["services"]="time_service.c logon_service.c security_service.c"
  ["libs"]="libc.c kernel32.c user32.c"
  ["tests"]="unit_tests.c integration_tests.c"
  ["tools"]="debugger.c log_viewer.c shell_tools.c"
  ["docs"]="README.md config.conf"
)

echo "Creating Shnurek OS base directory at $BASE_DIR"
mkdir -p "$BASE_DIR"

for dir in "${!DIRS[@]}"; do
  echo "Creating directory: $dir"
  mkdir -p "$BASE_DIR/$dir"

  files=${DIRS[$dir]}
  for file in $files; do
    filepath="$BASE_DIR/$dir/$file"
    if [[ ! -f "$filepath" ]]; then
      echo "Creating file: $filepath"
      case "$file" in
        *.c)
          cat > "$filepath" <<EOF
// $file - stub file for $dir subsystem
#include <stdint.h>

void ${file%.*}_init(void) {
    // TODO: Implement $file
}
EOF
          ;;
        *.h)
          cat > "$filepath" <<EOF
// $file - header stub for $dir subsystem
#ifndef ${file^^}_H
#define ${file^^}_H

// TODO: Define interfaces for $file

#endif // ${file^^}_H
EOF
          ;;
        *.asm)
          cat > "$filepath" <<EOF
; $file - assembly stub for $dir subsystem
BITS 32

global ${file%.*}_init

${file%.*}_init:
    ; TODO: Implement $file
    ret
EOF
          ;;
        *.md)
          echo "# Shnurek OS Documentation" > "$filepath"
          ;;
        *.conf)
          echo "# Configuration file for Shnurek OS" > "$filepath"
          ;;
        *)
          touch "$filepath"
          ;;
      esac
    else
      echo "File already exists: $filepath"
    fi
  done
done

echo "All files and directories created under $BASE_DIR."
echo "You can now start implementing the missing subsystems!"
