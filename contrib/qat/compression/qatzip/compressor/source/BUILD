load(
    "//bazel:envoy_build_system.bzl",
    "envoy_cc_contrib_extension",
    "envoy_cc_library",
    "envoy_contrib_package",
)
load("@rules_foreign_cc//foreign_cc:configure.bzl", "configure_make")

licenses(["notice"])  # Apache 2

envoy_contrib_package()

configure_make(
    name = "qatzip",
    autogen = True,
    configure_in_place = True,
    configure_options = [
        "--enable-static",
        "--disable-shared",
    ],
    copts = [
        "-Wno-error=newline-eof",
        "-Wno-error=strict-prototypes",
        "-Wno-error=unknown-warning-option",
        "-Wno-error=unused-but-set-variable",
    ],
    lib_source = "@com_github_intel_qatzip//:all",
    out_static_libs = [
        "libqatzip.a",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "//bazel/foreign_cc:lz4",
        "//bazel/foreign_cc:zlib",
        "//contrib/qat:qatlib",
        "@boringssl//:ssl",
    ],
    alwayslink = False,
)

envoy_cc_library(
    name = "compressor_lib",
    srcs = ["qatzip_compressor_impl.cc"],
    hdrs = ["qatzip_compressor_impl.h"],
    deps = [
        ":qatzip",
        "//envoy/compression/compressor:compressor_interface",
    ],
)

envoy_cc_contrib_extension(
    name = "config",
    srcs = ["config.cc"],
    hdrs = ["config.h"],
    deps = [
        ":compressor_lib",
        "//envoy/compression/compressor:compressor_config_interface",
        "//envoy/compression/compressor:compressor_factory_interface",
        "//source/common/http:headers_lib",
        "@envoy_api//contrib/envoy/extensions/compression/qatzip/compressor/v3alpha:pkg_cc_proto",
    ],
)
