[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Marco: A Stochastic Asynchronous Concolic Explorer

Concolic execution is a powerful program analysis technique for code path exploration. Despite recent advances that greatly improved the efficiency of concolic execution engines, path constraint solving remains a major bottleneck of concolic testing. An intelligent scheduler for inputs/branches becomes even more crucial. Our studies show that the previously under-studied branch-flipping policy adopted by state-of-the-art concolic execution engines has several limitations. We propose to assess each branch by its potential for new code coverage from a global view, concerning the path divergence probability at each branch. To validate this idea, we implemented a prototype Marco and evaluated it against the state-of-the-art concolic executor on 30 real-world programs from Google’s Fuzzbench, Binutils, and UniBench. The result shows that Marco can outperform the baseline approach and make continuous progress after the baseline approach terminates.



To learn more, checkout our [paper](https://dl.acm.org/doi/pdf/10.1145/3597503.3623301) at ICSE 2024.



## Build

TODO

<!-- 
Because SymSan leverages the shadow memory implementation from LLVM's sanitizers,
it has more strict dependency on the LLVM version. Right now only LLVM 12 is tested.

### Build Requirements

- Linux-amd64 (Tested on Ubuntu 20.04)
- [LLVM 12.0.1](http://llvm.org/docs/index.html): clang, libc++, libc++abi

### Compilation

Create a `build` directory and execute the following commands in it:

```shell
$ CC=clang-12 CXX=clang-12 cmake -DCMAKE_INSTALL_PREFIX=/path/to/install -DCMAKE_BUILD_TYPE=Release /path/to/symsan/source
$ make
$ make install
```

### Build in Docker

```
docker build -t symsan .
```

### LIBCXX

The repo contains instrumented libc++ and libc++abi to support C++ programs.
To rebuild these libraries from source, execute the `rebuild.sh` script in the
`libcxx` directory.

**NOTE**: because the in-process solving module (`solver/z3.cpp`) uses Z3's C++ API
and STL containers, so itself depends on the C++ libs. Due to such dependencies,
you'll see linking errors when building C++ targets when using this module.
Though it's possible to resolve these errors by not instrumenting the dependencies
(adding them to the [ABIList](https://clang.llvm.org/docs/DataFlowSanitizer.html#abi-list),
 then rebuild the C++ libs), we don't recommend using it for C++ targets.
Instead, it's much cleaner to use ann out-of-process solving module like Fastgen. -->

## Test
TODO

### Concolic Execution
TODO

### Hybrid Fuzzing
TODO

TODO
<!-- 
To verify the code works, try some simple tests
(forked from [Angora](https://github.com/AngoraFuzzer/Angora),
adapted by [@insuyun](https://github.com/insuyun) to lit):

```
$ pip install lit
$ cd your_build_dir
$ lit tests
```

### Environment Options

* `KO_CC` specifies the clang to invoke, if the default version isn't clang-12,
  set this variable to allow the compiler wrapper to find the correct clang.

* `KO_CXX` specifies the clang++ to invoke, if the default version isn't clang++-12,
  set this variable to allow the compiler wrapper to find the correct clang++.

* `KO_USE_Z3` enables the in-process Z3-based solver. By default, it is disabled,
  so SymSan will only perform symbolic constraint collection without solving.
  SymSan also supports out-of-process solving, which provides better compatiblility.
  Check [FastGen](https://github.com/R-Fuzz/fastgen).

* `KO_USE_NATIVE_LIBCXX` enables using the native uninstrumented libc++ and libc++abi.

* `KO_DONT_OPTIMIZE` don't override the optimization level to `O3`.



SymSan needs a driver to perform hybrid fuzzing, like [FastGen](https://github.com/R-Fuzz/fastgen).
It could also be used as a custom mutator for [AFL++](https://github.com/AFLplusplus/AFLplusplus)
(check the [plugin readme](driver/aflpp/README.md)). -->


## Reference

To cite Marco in scientific work, please use the following BibTeX:

``` bibtex
@inproceedings{hu2024marco,
  title={Marco: A Stochastic Asynchronous Concolic Explorer},
  author={Hu, Jie and Duan, Yue and Yin, Heng},
  booktitle={Proceedings of the 46th IEEE/ACM International Conference on Software Engineering},
  pages={1--12},
  year={2024}
}
```