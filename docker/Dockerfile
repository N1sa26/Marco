FROM ubuntu:18.04

RUN apt-get update && apt-get install -y sudo
RUN apt-get -y install wget python-pip python3.7 python3-pip apt-transport-https \
    llvm-6.0 llvm-6.0-dev clang-6.0 llvm-6.0-tools libboost-all-dev texinfo \
    lsb-release software-properties-common autoconf curl zlib1g-dev \
	libgd-dev cmake vim redis-server libc++abi-dev libc++-dev
RUN apt-get -y install libtool-bin bison flex libpixman-1-dev git libglib2.0-dev nasm
RUN pip install xlsxwriter pycrypto

RUN python3.7 -m pip install pip
RUN python3.7 -m pip install pip --upgrade pip

RUN apt-get -y install libc-dev
RUN apt-get -y install build-essential

RUN git clone https://github.com/Z3Prover/z3.git /z3 && \
		cd /z3 && git checkout z3-4.8.10 && \
		mkdir -p build && cd build && \
		cmake .. && make -j && make install

RUN ln -s /usr/lib/llvm-6.0/include/llvm /usr/include/llvm
RUN ln -s /usr/lib/llvm-6.0/include/llvm-c /usr/include/llvm-c
RUN ln -s /usr/bin/llvm-config-6.0 /usr/local/bin/llvm-config

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# ------------------------------ create directories required  ----------------------------------
USER root
RUN mkdir -p /workdir/input && \
    mkdir -p /outroot

# apt-get update
RUN apt-get install -y libpython3.7-dev
RUN apt-get install -y libprotobuf-dev protobuf-compiler
RUN pip3 install gensim numpy matplotlib annoy
RUN pip3 install transformers torch sklearn seaborn
RUN python3.7 -m pip install Cython
RUN python3.7 -m pip install nearpy
RUN python3.7 -m pip install sysv_ipc
RUN python3.7 -m pip install datasets
RUN python3.7 -m pip install tokenizers
RUN python3.7 -m pip install microdict
RUN python3.7 -m pip install z3-solver
RUN python3.7 -m pip install redis
RUN python3.7 -m pip install gputil
RUN python3.7 -m pip install psutil
RUN python3.7 -m pip install humanize
RUN python3.7 -m pip install networkit

WORKDIR /workdir
