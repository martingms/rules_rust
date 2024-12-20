"""Dependencies needed for the cross-installer tool"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//cargo:defs.bzl", "cargo_bootstrap_repository")

# buildifier: disable=bzl-visibility
load("//rust/private:common.bzl", "DEFAULT_RUST_VERSION")

def cross_installer_deps():
    """Define cross repositories used for compiling cargo-bazel for various platforms"""
    maybe(
        http_archive,
        name = "cross_rs",
        # v0.2.5+
        urls = ["https://github.com/cross-rs/cross/archive/4090beca3cfffa44371a5bba524de3a578aa46c3.zip"],
        strip_prefix = "cross-4090beca3cfffa44371a5bba524de3a578aa46c3",
        integrity = "sha256-9lo/wRsDWdaTzt3kVSBWRfNp+DXeDZqrG3Z+10mE+fo=",
        build_file_content = """exports_files(["Cargo.toml", "Cargo.lock"], visibility = ["//visibility:public"])""",
    )

    version = DEFAULT_RUST_VERSION
    if "-" in version:
        version = "nightly/{}".format(version)

    maybe(
        cargo_bootstrap_repository,
        name = "cross_rs_host_bin",
        binary = "cross",
        cargo_toml = "@cross_rs//:Cargo.toml",
        cargo_lockfile = "@cross_rs//:Cargo.lock",
        version = version,
    )
