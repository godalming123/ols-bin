FROM debian:latest
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y git gcc-aarch64-linux-gnu g++-aarch64-linux-gnu lld curl unzip clang
RUN curl --location https://github.com/odin-lang/Odin/releases/download/dev-2025-09/odin-linux-amd64-dev-2025-09.zip -o odin.zip
RUN unzip odin.zip -d .
RUN tar -xzf dist.tar.gz -C /usr/bin --strip-components 1
RUN git clone https://github.com/DanielGavin/ols.git
RUN mkdir ols/build
RUN echo "-collection:src=src -no-bounds-check -o:speed -define:VERSION=dev-$(date -u '+%Y-%m-%d')-$(GIT_DIR=ols git rev-parse --short HEAD)" > ols/GENERAL_FLAGS
RUN echo "-target:linux_amd64 -linker:lld -microarch:generic -extra-linker-flags:'--target=amd64-linux-gnu'" > ols/AMD64_FLAGS
RUN echo "-target:linux_arm64 -linker:lld -microarch:generic -extra-linker-flags:'--target=aarch64-linux-gnu'" > ols/ARM64_FLAGS
RUN cd ols; odin build src/                    $(cat GENERAL_FLAGS) $(cat AMD64_FLAGS) -out:build/amd64-linux-gnu-ols
RUN cd ols; odin build src/                    $(cat GENERAL_FLAGS) $(cat ARM64_FLAGS) -out:build/arm64-linux-gnu-ols
RUN cd ols; odin build tools/odinfmt/main.odin $(cat GENERAL_FLAGS) $(cat AMD64_FLAGS) -out:build/amd64-linux-gnu-odinfmt -file
RUN cd ols; odin build tools/odinfmt/main.odin $(cat GENERAL_FLAGS) $(cat ARM64_FLAGS) -out:build/arm64-linux-gnu-odinfmt -file
