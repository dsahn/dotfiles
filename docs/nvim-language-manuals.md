# Rust 개발환경 매뉴얼

자동 설치까지는 넣지 않고, 아래 도구를 시스템에 준비해서 연결하는 방식으로 운영한다.

- 런타임
  - `rustup`
  - `cargo`
  - `rust-analyzer`
  - `rustfmt`
  - `clippy`
- 권장 설치 예시

  ```sh
  rustup toolchain install stable
  rustup component add rustfmt clippy
  rustup component add rust-analyzer
  ```

- Neovim 연동 포인트
  - chezmoi `[data] nvim_languages`에 `"rust"` 포함 시 `rust_analyzer`·`rustfmt`(conform)가 이미 연결됨
  - 필요하면 `crates.nvim`, `rustaceanvim` 도입 검토

# TypeScript 개발환경 매뉴얼

자동 설치까지는 넣지 않고, Node 생태계 도구를 먼저 준비한 뒤 Neovim에 연결한다.

- 런타임
  - `node`
  - `npm` 또는 `pnpm`
  - `typescript`
  - `typescript-language-server`
  - `prettier`
  - `eslint_d` 또는 `eslint`
- 권장 설치 예시

  ```sh
  npm install -g typescript typescript-language-server prettier eslint_d
  ```

- Neovim 연동 포인트
  - chezmoi `[data] nvim_languages`에 `"typescript"` 포함 시 `ts_ls`·Prettier(conform)가 이미 연결됨
  - 프로젝트별로 다른 LSP가 필요하면 `lang_profiles.lua`의 `enable_lsp("typescript", …)` 분기를 커스터마이즈
  - lint workflow가 중요하면 `nvim-lint` 추가 검토
