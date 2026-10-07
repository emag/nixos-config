# Repository Guidelines

## Project Structure & Module Organization

This repository defines a flake-based NixOS system for a Dell XPS 15 7590 (`x86_64-linux`). All configuration lives at the repository root:

- `flake.nix`: inputs, the `nixos` system output, hardware modules, and Home Manager integration.
- `flake.lock`: pinned dependency revisions; commit intentional dependency updates.
- `configuration.nix`: system services, GNOME, networking, graphics, locale, and user accounts.
- `hardware-configuration.nix`: machine-specific hardware and filesystem settings.
- `home.nix`: packages and user configuration for `emag`, including Git, Vim, and GNOME settings.

There are no separate source, test, or asset directories. Place system settings in `configuration.nix` and user settings in `home.nix`; wire additional modules through explicit imports.

## Build, Test, and Development Commands

Run commands from the repository root:

- `nix flake check`: evaluate the flake and run any declared checks.
- `nixos-rebuild build --flake .#nixos`: build the system without activating it.
- `sudo nixos-rebuild test --flake .#nixos`: activate the configuration temporarily, without making it the boot default.
- `sudo nixos-rebuild switch --flake .#nixos`: activate the configuration and make it the boot default.
- `nix flake update`: update dependency pins; review the resulting `flake.lock` diff.

## Coding Style & Naming Conventions

Use two-space indentation, semicolon-terminated Nix assignments, and multiline lists for multiple packages or modules. Follow the existing grouping by subsystem and use short comments to explain intent. Name additional module files descriptively with lowercase, hyphen-separated names, such as `desktop-settings.nix`.

No formatter or linter is configured in the flake. Match the surrounding style and keep unrelated formatting changes out of functional patches.

## Testing Guidelines

There is no dedicated test framework or coverage requirement. Validate configuration changes with flake evaluation and a system build. For runtime changes, use temporary activation and verify affected services or desktop behavior on the target machine. Document the commands run and any checks that could not be completed.

## Commit & Pull Request Guidelines

Existing commits use short, imperative subjects, such as `Install wl-clipboard`. Keep commits focused on one change. Pull requests should explain the purpose, affected configuration, and validation results. Link relevant issues when available; include screenshots only for visible desktop changes.

## Security & Configuration Tips

Never commit credentials or private keys. Review hardware changes carefully for this specific machine. Preserve `system.stateVersion` and `home.stateVersion` unless deliberately performing a migration; dependency upgrades alone do not justify changing them.
