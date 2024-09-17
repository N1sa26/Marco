[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Marco: A Stochastic Asynchronous Concolic Explorer

Concolic execution is a powerful program analysis technique for code path exploration. Despite recent advances that greatly improved the efficiency of concolic execution engines, path constraint solving remains a major bottleneck of concolic testing. An intelligent scheduler for inputs/branches becomes even more crucial. Our studies show that the previously under-studied branch-flipping policy adopted by state-of-the-art concolic execution engines has several limitations. We propose to assess each branch by its potential for new code coverage from a global view, concerning the path divergence probability at each branch. To validate this idea, we implemented a prototype Marco and evaluated it against the state-of-the-art concolic executor on 30 real-world programs from Google’s Fuzzbench, Binutils, and UniBench. The result shows that Marco can outperform the baseline approach and make continuous progress after the baseline approach terminates.

To learn more, checkout our [paper](https://dl.acm.org/doi/pdf/10.1145/3597503.3623301) at ICSE 2024.


<!-- ## Directory structure

```
Marco
├── docker
│   ├── builddocker.sh
│   └── Dockerfile
├── launch.sh
├── readme.md
├── run_icse.sh
├── run.sh
└── src
    ├── CE
    └── scheduler
``` -->


## Building

### To build docker image `marco_design`

```
$ cd Marco/docker 
$ ./builddocker.sh
```

### To build Marco
```
$ bash launch_building_docker.sh
# cd /data/src/CE
# bash rebuild.sh
```

To verify if Marco is successfully built, check if `ko-clang` and `ko-clang++` exist under `/data/src/CE/bin`.

### To build targets
```
$ bash launch_building_docker.sh
# cd /data/src/benchmarks
# bash rebuild.sh
```

Building all targets at once may take a while. Feel free to modify `rebuild.sh` (the one in `Marco/src/benchmarks`) to customize which targets to build. 

All targets successfully built can be found under `src/benchmarks/targets/*/ce_targets`.

<!-- ### Build targets

```
$ cd Marco/src/benchmarks

``` -->

## Test



### Concolic Execution Mode


### Hybrid Fuzzing Mode
TODO


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