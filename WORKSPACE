# Copyright 2020 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Workspace for MLIR HLO."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

SKYLIB_VERSION = "1.3.0"

http_archive(
    name = "bazel_skylib",
    sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/{version}/bazel-skylib-{version}.tar.gz".format(version = SKYLIB_VERSION),
        "https://github.com/bazelbuild/bazel-skylib/releases/download/{version}/bazel-skylib-{version}.tar.gz".format(version = SKYLIB_VERSION),
    ],
)

LLVM_COMMIT = "846709b287abe541fcad42e5a54d37a41dae3f67"

LLVM_SHA256 = "95057e70244cec91e3b35b03c8ed129d938cbb515dc308e3f8af50e20b07bf98"

http_archive(
    name = "llvm-raw",
    build_file_content = "# empty",
    sha256 = LLVM_SHA256,
    strip_prefix = "llvm-project-" + LLVM_COMMIT,
    urls = ["https://github.com/llvm/llvm-project/archive/{commit}.tar.gz".format(commit = LLVM_COMMIT)],
)

load("@llvm-raw//utils/bazel:configure.bzl", "llvm_configure", "llvm_disable_optional_support_deps")

llvm_configure(name = "llvm-project")

llvm_disable_optional_support_deps()
