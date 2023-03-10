load(
  "@io_bazel_rules_docker//docker/util:run.bzl",
  "container_run_and_commit_layer"
)
container_run_and_commit_layer(
  name = "layer_with_packages",
  image = "@alpine_base//image",
  commands = [
    "sed -i -e 's/^http:/#http:/' -e 's/^#http:\\(.*edge.*\\)/https:\\1/' /etc/apk/repositories",
    "apk update",
    "apk add --no-cache autoconf",
    "apk add --no-cache autoconf-archive",
    "apk add --no-cache automake",
    "apk add --no-cache bash",
    "apk add --no-cache bash-completion",
    "apk add --no-cache binutils-gold",
    "apk add --no-cache clang",
    "apk add --no-cache cmake",
    "apk add --no-cache coreutils",
    "apk add --no-cache curl",
    "apk add --no-cache g++",
    "apk add --no-cache gcc",
    "apk add --no-cache gcompat",
    "apk add --no-cache gettext",
    "apk add --no-cache git",
    "apk add --no-cache gmp-dev",
    "apk add --no-cache go",
    "apk add --no-cache gpg",
    "apk add --no-cache libc-dev",
    "apk add --no-cache libc6-compat",
    "apk add --no-cache libffi-dev",
    "apk add --no-cache libtool",
    "apk add --no-cache linux-headers",
    "apk add --no-cache m4",
    "apk add --no-cache make",
    "apk add --no-cache musl-dev",
    "apk add --no-cache ncurses-dev",
    "apk add --no-cache openjdk11-jdk",
    "apk add --no-cache openjdk17-jdk",
    "apk add --no-cache patch",
    "apk add --no-cache perl",
    "apk add --no-cache pv",
    "apk add --no-cache py3-pip",
    "apk add --no-cache python3-dev",
    "apk add --no-cache shadow",
    "apk add --no-cache tar",
    "apk add --no-cache texinfo",
    "apk add --no-cache tig",
    "apk add --no-cache tree",
    "apk add --no-cache unzip",
    "apk add --no-cache vim",
    "apk add --no-cache wget",
    "apk add --no-cache xz",
    "apk add --no-cache zip",

    "export GOROOT=/usr/lib/go",

    "mkdir -p /tmp/bazel-release",
    "chmod a+rwx /tmp/bazel-release",
    "cd /tmp/bazel-release",
    "wget -O bazel-release-dist.zip https://github.com/bazelbuild/bazel/releases/download/6.0.0/bazel-6.0.0-dist.zip",
    "unzip bazel-release-dist.zip",
    "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk",
    "export EXTRA_BAZEL_ARGS='--tool_java_runtime_version=local_jdk'",
    "bash ./compile.sh",
    "cp output/bazel /usr/local/bin/",
    "cd",

    "echo 'export JAVA_HOME=$(dirname $(dirname $(readlink -f $(type -P javac))))' > /etc/profile.d/java_home.sh",

    "touch /etc/bazel.bazelrc",
    "echo 'startup --output_user_root=/tmp/bazel' >> /etc/bazel.bazelrc",
    "echo 'run --color=yes' >> /etc/bazel.bazelrc",
    "echo 'build --color=yes' >> /etc/bazel.bazelrc",
    "echo 'build --verbose_failures' >> /etc/bazel.bazelrc",
    "echo 'build --enable_runfiles' >> /etc/bazel.bazelrc",
    "echo 'test --test_output=errors' >> /etc/bazel.bazelrc",
    "echo 'test --test_verbose_timeout_warnings' >> /etc/bazel.bazelrc",
    "echo 'test --test_summary=terse' >> /etc/bazel.bazelrc",

    "export PATH=/usr/local/bin:$PATH",
  ],
)

load(
  "@io_bazel_rules_docker//container:container.bzl",
  "container_image",
)
container_image(
  name = "alpine_bazel",
  base = "@alpine_base//image",
  layers = [":layer_with_packages"],
)

load(
  "@io_bazel_rules_docker//container:container.bzl",
  "container_push",
)
container_push(
   name = "push",
   image = ":alpine_bazel",
   format = "Docker",
   registry = "ghcr.io",
   repository = "noldor-solutions/alpine-bazel",
   tag = "latest",
)
