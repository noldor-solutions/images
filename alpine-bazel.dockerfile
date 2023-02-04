FROM alpine:edge

RUN \
    sed -i -e 's/^http:/#http:/' -e 's/^#http:\(.*edge.*\)/https:\1/' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
    autoconf \
    autoconf-archive \
    automake \
    bash \
    bash-completion \
    binutils-gold \
    clang \
    cmake \
    coreutils \
    curl \
    g++ \
    gcc \
    gcompat \
    gettext \
    git \
    gmp-dev \
    go \
    gpg \
    libc-dev \
    libc6-compat \
    libffi-dev \
    libtool \
    linux-headers \
    m4 \
    make \
    musl-dev \
    ncurses-dev \
    openjdk11-jdk \
    openjdk17-jdk \
    patch \
    perl \
    pv \
    py3-pip \
    python3-dev \
    shadow \
    tar \
    texinfo \
    tig \
    tree \
    unzip \
    vim \
    wget \
    xz \
    zip

RUN \
    mkdir -p /tmp/bazel-release \
    && chmod a+rwx /tmp/bazel-release \
    && cd /tmp/bazel-release \
    && wget -O bazel-release-dist.zip \
       https://github.com/bazelbuild/bazel/releases/download/6.0.0/bazel-6.0.0-dist.zip \
    && unzip bazel-release-dist.zip \
    && env JAVA_HOME=/usr/lib/jvm/java-11-openjdk \
       EXTRA_BAZEL_ARGS="--tool_java_runtime_version=local_jdk" \
       bash ./compile.sh \
    && cp output/bazel /usr/local/bin/ \
    && cd

RUN printf 'export JAVA_HOME=$(dirname $(dirname $(readlink -f $(type -P javac))))' > /etc/profile.d/java_home.sh

RUN printf 'startup --output_user_root=/tmp/bazel\n\
run --color=yes\n\
build --color=yes\n\
build --verbose_failures\n\
build --enable_runfiles\n\
test --test_output=errors\n\
test --test_verbose_timeout_warnings\n\
test --test_summary=terse\n'\
> /etc/bazel.bazelrc

ENV PATH="/usr/local/bin:$PATH"
