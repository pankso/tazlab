# 🧪 TazLab

[![License](https://img.shields.io/badge/license-BSD-blue.svg)](LICENSE)
[![SliTaz](https://img.shields.io/badge/distro-SliTaz-orange.svg)](http://www.slitaz.org/)

**SliTaz development lab for foreign GNU/Linux hosts (Debian, Ubuntu, Arch, etc.).**

TazLab allows you to build, develop, and cook SliTaz packages from any Linux distribution using a POSIX shell, mount, chroot, and QEMU.
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
Clone the wok and essential repositories, then download and extract the SliTaz rootfs:
```bash
tazlab clone                # Clone wok + essential repos
sudo tazlab setup           # Download and extract SliTaz rootfs
```

### 4. Enter the Chroot
```bash
sudo tazlab enter           # Mount and enter the chroot
```

Inside the chroot, on first use, install the cooking tools:
```bash
tazpkg get-install cookutils
cook setup
```

### 5. Cook and Test
Back on your host, you can now build packages. If you build custom SliTaz ISOs (e.g. using `tazlito`), you can quickly test them:
```bash
sudo tazlab cook busybox      # Cook a package
sudo tazlab qemu              # Test your SliTaz ISO in QEMU
```

---

## 📁 Directory Layout

By default, everything lives in `~/.slitaz/` on your host. This isolation ensures your host system stays clean while keeping your work persistent across chroot sessions.

| Directory | Description |
| :--- | :--- |
| `chroot/` | The SliTaz rootfs (the actual chroot environment). |
| `wok/` | Package recipes (bind-mounted inside the chroot). |
| `repos/` | Cloned Mercurial (HG) repos (cookutils, base-files, etc). |
| `packages/` | Built `.tazpkg` files ready for deployment. |
| `cache/` | Build cache. |
| `log/` | Build logs. |
| `src/` | Downloaded source tarballs. |
| `iso/` | Cached SliTaz ISO images. |

> **Note:** You can override these paths via `/etc/slitaz/tazlab.conf`, `~/.slitaz/tazlab.conf`, or `./tazlab.conf` (last wins).

---

## 🛠️ Commands Reference

TazLab is split into logical command groups. Run `tazlab help` for a quick overview.

### 📦 Chroot Management
- `setup` — Download SliTaz ISO and extract rootfs to chroot.
- `setup-user [u]` — Create an unprivileged user in the chroot.
- `enter` — Mount and enter the chroot as `root`.
- `enter-user [u]` — Mount and enter as an unprivileged user.
- `umount` — Unmount the chroot (skips if another session is active).
- `cook <pkg>` — Cook a package inside the chroot.
- `run <cmd>` — Run an arbitrary command inside the chroot.
- `update-chroot` — Update all packages inside the chroot (`tazpkg upgrade`).
- `nuke` — Wipe the chroot (keeps wok, packages, cache, log, src, repos, iso).

### 🌐 Repositories
- `clone` — Clone the wok and extra repos into `~/.slitaz/repos/`.
- `pull` — Run `hg pull -u` on all cloned repositories.
- `repos` — Show the status of each cloned repository.
- `add-repo <url>` — Add an extra HG repo to the tracking list.

### 🖥️ Virtualization
- `qemu [iso]` — Run a SliTaz ISO in QEMU (use `--iso=<url>` to download a specific one).

### 🔍 Inspection
- `log <pkg>` — Show the build log (runs `tail -f` if currently building).
- `list [filter]` — List package recipes available in the wok.
- `search <pat>` — Search for a pattern across all receipts.
- `info <pkg>` — Show detailed package receipt metadata.
- `edit <pkg>` — Open a package receipt in `$EDITOR`.
- `deps <pkg>` — Show build and runtime dependencies of a package.

### 🧹 Maintenance
- `check` — Verify all host dependencies are installed.
- `config` — Show effective configuration (all variables resolved).
- `init` — Interactive first-time setup wizard.
- `status` — Show the overall status of the chroot, wok, packages, and repos.
- `clean` — Clean the build cache and logs.

---

## ⚠️ Security Note

> [!WARNING]
> A chroot is **not** a strict security boundary. Do not run untrusted package recipes on your host machine.
