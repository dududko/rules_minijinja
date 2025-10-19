"""Mirror of release info for minijinja-cli

TODO: generate this file from GitHub API"""

# The integrity hashes are SHA256 from the official release
# https://github.com/mitsuhiko/minijinja/releases/tag/2.12.0
TOOL_VERSIONS = {
    "2.12.0": {
        # macOS
        "aarch64-apple-darwin": "d73fd3f8379ccbc6f3bc2155f9186e2474f9c5046f49742256a9b31c0177ab51",
        "x86_64-apple-darwin": "7680ea1bec2502ed18d6473bb8fdf35792e6102758a1e6a4507cec4b471caff7",
        # Linux
        "aarch64-unknown-linux-musl": "b8307220324981b02242673a128d66100b45b865dc48e54fff8aeca87c8a59ef",
        "i686-unknown-linux-musl": "c309b1c251d7efba4812e97082dea46bb8b728a6bd7d36ce8c23fbfd6f5cba3a",
        "x86_64-unknown-linux-musl": "25a66c167af416890e44688f63967001bf570d5885f63cc9c721faa98af1024d",
        # Windows
        "i686-pc-windows-msvc": "9808ee7d06445932bf0281e7c0754265b6152e187a2fdc42965b5eeadb0e1287",
        "x86_64-pc-windows-msvc": "bd2ce61fc7013939e15cf8abc451df00447de75ecfd009cc60627d2953ad3f92",
    },
}
