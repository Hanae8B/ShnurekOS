# 🐚 ShnurekOS

**ShnurekOS** is a modular, custom-built x86 operating system written mainly in C and Assembly. It is designed for experimentation, education, and exploration of operating system concepts. The project covers all layers of an OS—from bootloader through kernel and drivers to a graphical desktop environment, including networking and an AI-assisted shell.

---

## 🧠 What is ShnurekOS?

ShnurekOS is a full-stack operating system developed from scratch. It implements a custom boot process, process and memory management, device drivers, system calls, interprocess communication (IPC), user authentication, networking protocols, and a lightweight graphical user interface.

The design focuses on modularity and flexibility, enabling easier extension and experimentation.

---

## ✨ Key Features

- ✅ **Custom Kernel**: Modular components for process, memory, and I/O management.
- 💬 **Interprocess Communication**: Message passing, pipes, and socket support.
- 👤 **User Management**: Authentication and user-space privilege handling.
- 🗂 **File Systems**: Virtual file system layer supporting ext2 and FAT.
- 🖥 **Graphical Desktop**: Lightweight desktop environment with graphics and input handling.
- 🌐 **Networking Stack**: TCP/IP, DHCP, and socket APIs.
- 🧪 **Testing Strategy**: Organized into incremental test phases.
- 🤖 **AI-Integrated Shell**: Experimental shell with AI interaction capabilities.
- 🧰 **Utilities and Tools**: Debuggers, shell utilities, and log viewers.

---

## 🔍 How is ShnurekOS Different?

| Area             | ShnurekOS                                  | Traditional OS (e.g., Linux)    |
|------------------|--------------------------------------------|---------------------------------|
| Kernel Type       | Modular, microkernel-inspired               | Monolithic                     |
| GUI Stack         | Built-in desktop and graphics stack         | External (e.g., GNOME, KDE)    |
| Shell             | Command line interface with optional AI     | Traditional CLI shells         |
| Development Approach | Incremental test-phase-based design       | Monolithic                    |
| Educational Focus | Covers low- to high-level OS concepts       | Production-oriented            |
| IPC/Services      | Custom IPC and OS services                   | Often abstracted               |

---

## 📁 Project Structure

```plaintext
.
├── boot/                # GRUB configuration and bootloader
├── docs/                # Documentation files (e.g., this README)
├── fs/                  # Filesystem code (VFS, ext2)
├── gui/                 # Compositor, input, graphics stack
├── include/             # Shared headers
├── kernel/              # Main kernel logic (drivers, memory, IPC, etc.)
├── libs/                # Minimal libc and helper libraries
├── net/                 # Networking stack (TCP, DHCP, sockets)
├── services/            # OS-level services (login, time, security)
├── tests/               # Integration and unit tests
├── user/                # User space applications (desktop, shell, init)
├── tools/               # Utilities: debugger, shell tools, log viewer
├── *.c, *.asm           # Core entry points and stubs
└── Makefile             # Build instructions
