# 🧪 TazLab

[![License](https://img.shields.io/badge/license-BSD-blue.svg)](LICENSE)
[![SliTaz](https://img.shields.io/badge/distro-SliTaz-orange.svg)](http://www.slitaz.org/)

**SliTaz development lab for foreign GNU/Linux hosts (Debian, Ubuntu, Arch, etc.).**

TazLab allows you to build, develop, and cook SliTaz packages for i486, x86_64, or custom environments from any Linux distribution using a POSIX shell, mount, chroot, and QEMU.
No `proot`, no `systemd`, no extra dependencies beyond what every standard distro already ships.

---

## 🚀 Quick Start

### 1. Install
TazLab is a single self-contained script. You can run it directly without installing:
```bash
./tazlab help
```

Or install system-wide so it is available as `tazlab` from anywhere:
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
Clone the wok and essential repositories, then download and extract the SliTaz rootfs for your target architecture or custom environment:
```bash
tazlab clone i486                    # Clone wok + essential repos (32-bit)
tazlab clone x86_64                  # Clone wok + essential repos (64-bit)
tazlab clone mylab                   # Clone wok for a custom env
sudo tazlab setup i486              # Setup 32-bit chroot
sudo tazlab setup x86_64            # Setup 64-bit chroot
sudo tazlab setup mylab             # Setup custom env (needs ISO_URL_mylab in config)
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
sudo tazlab cook mylab busybox     # Cook in a custom environment
sudo tazlab qemu i486              # Test your 32-bit ISO in QEMU
```

---

## 📁 Directory Layout

By default, everything lives in `~/.slitaz/` on your host. Each environment has its own chroot, wok, packages, cache, logs, and distro build output, while repos, src, and ISOs are shared across environments. Custom environments use the same layout as built-in archs (e.g. `mylab/chroot/`, `mylab/wok/`).

| Directory | Description |
| :--- | :--- |
| `<env>/chroot/` | SliTaz rootfs for that environment. |
| `<env>/wok/` | Package recipes for that environment (bind-mounted). |
| `<env>/packages/` | Built `.tazpkg` files. |
| `<env>/distro/` | Distro/ISO build output (bind-mounted). |
| `repos/` | Cloned Mercurial (HG) repos (cookutils, base-files, etc). |
| `src/` | Downloaded source tarballs, shared. |
| `iso/` | Cached SliTaz ISO images. |

> **Note:** You can override these paths via `/etc/slitaz/tazlab.conf`, `~/.slitaz/tazlab.conf`, or `./tazlab.conf` (last wins).
>
> **Custom env ISO URLs:** hyphens in env names become underscores in variable names. For an env named `my-lab`, set `ISO_URL_my_lab="https://..."` in your config.

---

## 🛠️ Commands Reference

TazLab is split into logical command groups. Run `tazlab help` for a quick overview.

### 📦 Chroot Management
All chroot commands accept an optional `[env]` argument (`i486`, `x86_64`, or a custom name). If omitted, the default environment from your config is used.

- `setup [env]` — Download SliTaz ISO and extract rootfs to chroot.
- `setup-user [env] [u]` — Create an unprivileged user in the chroot.
- `enter [env]` — Mount and enter the chroot as `root`.
- `enter-user [env] [u]` — Mount and enter as an unprivileged user.
- `umount [env]` — Unmount the chroot (skips if another session is active).
- `cook [env] <pkg>` — Cook a package inside the chroot.
- `run [env] <cmd>` — Run an arbitrary command inside the chroot.
- `update-chroot [env]` — Update all packages inside the chroot (`tazpkg upgrade`).
- `nuke [env]` — Wipe an environment (chroot, packages, cache, distro, logs). Wok kept.

### 🌐 Repositories
- `clone [env]` — Clone the wok (per-environment) and extra repos into `~/.slitaz/`.
- `pull [env]` — Run `hg pull -u` on cloned repositories. Without `env`, pulls every per-environment wok plus shared repos; with `env`, only that environment's wok.
- `repos` — Show the status of each cloned repository.
- `add-repo <url>` — Add an extra HG repo to the tracking list.

### 🖥️ Virtualization
- `qemu [env] [iso]` — Run a SliTaz ISO in QEMU (env selects the right ISO and QEMU binary).

### 🔍 Inspection
- `log <pkg>` — Show the build log (runs `tail -f` if currently building).
- `list [env] [filter]` — List package recipes available in the wok.
- `search [env] <pat>` — Search for a pattern across all receipts.
- `info [env] <pkg>` — Show detailed package receipt metadata.
- `edit [env] <pkg>` — Open a package receipt in `$EDITOR`.
- `deps [env] <pkg>` — Show build and runtime dependencies of a package.

### 🧹 Maintenance
- `check` — Verify all host dependencies are installed.
- `config` — Show effective configuration (all variables resolved).
- `init` — Interactive first-time setup wizard.
- `status` — Show status of all environments (chroot, wok, packages, cache) and shared dirs.
- `clean` — Clean the build cache and logs.

---

## ⚠️ Security Note

> [!WARNING]
> A chroot is **not** a strict security boundary. Do not run untrusted package recipes on your host machine.
