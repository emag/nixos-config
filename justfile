# 利用できるコマンドを表示
default:
    @just --list

# NixOS 26.05 の nixpkgs を更新（他のパッケージも更新対象）
update:
    nix flake update nixpkgs

# すべての flake 入力を更新
update-all:
    nix flake update

# 依存関係の変更内容を確認
diff:
    git diff -- flake.lock

# 設定を検証
check:
    nix flake check

# システムをビルド
build:
    nixos-rebuild build --flake .#nixos

# 一時的に反映（起動時の既定にはしない）
test:
    sudo nixos-rebuild test --flake .#nixos

# システムに反映し、起動時の既定にする
switch:
    sudo nixos-rebuild switch --flake .#nixos
