# 🧪 TazLab

[![License](https://img.shields.io/badge/license-BSD-blue.svg)](LICENSE)
[![SliTaz](https://img.shields.io/badge/distro-SliTaz-orange.svg)](http://www.slitaz.org/)

**SliTaz development lab for foreign GNU/Linux hosts (Debian, Ubuntu, Arch, etc.).**

TazLab allows you to build, develop, and cook SliTaz packages for i486 and x86_64 from any Linux distribution using a POSIX shell, mount, chroot, and QEMU.
No `proot`, no `systemd`, no extra dependencies beyond what every standard distro already ships.

---

## 🚀 Quick Start

### 1. Install
Install the script on your host system:
```bash
sudo make install
```

### 2. Check & Init
Verify host dependencies and create your configuration:
```bash
tazlab check                # Verify all host deps are installed
tazlab init                 # Interactive setup wizard
```

### 3. Setup the Lab
Clone the wok and essential repositories, then download and extract the SliTaz rootfs for your target architecture:
```bash
tazlab clone i486                    # Clone wok + essential repos (32-bit)
tazlab clone x86_64                  # Clone wok + essential repos (64-bit)
sudo tazlab setup i486              # Setup 32-bit chroot
sudo tazlab setup x86_64            # Setup 64-bit chroot
```

### 4. Enter the Chroot
```bash
sudo tazlab enter i486              # Enter 32-bit chroot as root
sudo tazlab enter x86_64            # Enter 64-bit chroot as root
```

Inside the chroot, on first use, install the cooking tools:
```bash
tazpkg get-install cookutils
cook setup
```

### 5. Cook and Test
Back on your host, you can now build packages. If you build custom SliTaz ISOs (e.g. using `tazlito`), you can quickly test them:
```bash
sudo tazlab cook i486 busybox      # Cook a 32-bit package
sudo tazlab cook x86_64 busybox    # Cook a 64-bit package
sudo tazlab qemu i486              # Test your 32-bit ISO in QEMU
```

---

## 📁 Directory Layout

By default, everything lives in `~/.slitaz/` on your host. Each architecture has its own chroot, wok, packages, cache, and logs, while repos, src, and ISOs are shared between architectures.

| Directory | Description |
| :--- | :--- |
| `i486/chroot/` | 32-bit SliTaz rootfs (the chroot environment). |
| `i486/wok/` | Package recipes for 32-bit builds (bind-mounted). |
| `i486/packages/` | Built 32-bit `.tazpkg` files. |
| `x86_64/chroot/` | 64-bit SliTaz rootfs. |
| `x86_64/wok/` | Package recipes for 64-bit builds (bind-mounted). |
| `x86_64/packages/` | Built 64-bit `.tazpkg` files. |
| `repos/` | Cloned Mercurial (HG) repos (cookutils, base-files, etc). |
| `src/` | Downloaded source tarballs, shared. |
| `iso/` | Cached SliTaz ISO images for both architectures. |

> **Note:** You can override these paths via `/etc/slitaz/tazlab.conf`, `~/.slitaz/tazlab.conf`, or `./tazlab.conf` (last wins).

---

## 🛠️ Commands Reference

TazLab is split into logical command groups. Run `tazlab help` for a quick overview.

### 📦 Chroot Management
All chroot commands accept an optional `[arch]` argument (`i486` or `x86_64`). If omitted, the default architecture from your config is used.

- `setup [arch]` — Download SliTaz ISO and extract rootfs to chroot.
- `setup-user [arch] [u]` — Create an unprivileged user in the chroot.
- `enter [arch]` — Mount and enter the chroot as `root`.
- `enter-user [arch] [u]` — Mount and enter as an unprivileged user.
- `umount [arch]` — Unmount the chroot (skips if another session is active).
- `cook [arch] <pkg>` — Cook a package inside the chroot.
- `run [arch] <cmd>` — Run an arbitrary command inside the chroot.
- `update-chroot [arch]` — Update all packages inside the chroot (`tazpkg upgrade`).
- `nuke [arch]` — Wipe an architecture (chroot, packages, cache, logs). Wok kept.

### 🌐 Repositories
- `clone [arch]` — Clone the wok (per-architecture) and extra repos into `~/.slitaz/`.
- `pull [arch]` — Run `hg pull -u` on the wok and all cloned repositories.
- `repos` — Show the status of each cloned repository.
- `add-repo <url>` — Add an extra HG repo to the tracking list.

### 🖥️ Virtualization
- `qemu [arch] [iso]` — Run a SliTaz ISO in QEMU (arch selects the right ISO and QEMU binary).

### 🔍 Inspection
- `log <pkg>` — Show the build log (runs `tail -f` if currently building).
- `list [arch] [filter]` — List package recipes available in the wok.
- `search [arch] <pat>` — Search for a pattern across all receipts.
- `info [arch] <pkg>` — Show detailed package receipt metadata.
- `edit [arch] <pkg>` — Open a package receipt in `$EDITOR`.
- `deps [arch] <pkg>` — Show build and runtime dependencies of a package.

### 🧹 Maintenance
- `check` — Verify all host dependencies are installed.
- `config` — Show effective configuration (all variables resolved).
- `init` — Interactive first-time setup wizard.
- `status` — Show status of both architectures (chroot, packages, cache) and shared dirs.
- `clean` — Clean the build cache and logs.

---

## ⚠️ Security Note

> [!WARNING]
> A chroot is **not** a strict security boundary. Do not run untrusted package recipes on your host machine.
