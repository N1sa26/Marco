[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Marco: A Stochastic Asynchronous Concolic Explorer

Concolic execution is a powerful program analysis technique for code path exploration. Despite recent advances that greatly improved the efficiency of concolic execution engines, path constraint solving remains a major bottleneck of concolic testing. An intelligent scheduler for inputs/branches becomes even more crucial. Our studies show that the previously under-studied branch-flipping policy adopted by state-of-the-art concolic execution engines has several limitations. We propose to assess each branch by its potential for new code coverage from a global view, concerning the path divergence probability at each branch. To validate this idea, we implemented a prototype Marco and evaluated it against the state-of-the-art concolic executor on 30 real-world programs from Google’s Fuzzbench, Binutils, and UniBench. The result shows that Marco can outperform the baseline approach and make continuous progress after the baseline approach terminates.

To learn more, checkout our [paper](https://dl.acm.org/doi/pdf/10.1145/3597503.3623301) at ICSE 2024.


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

|    	| Benchmark       	| Target                  	| Option 	|
|----	|-----------------	|-------------------------	|--------	|
| 1  	| binutils-2.33.1 	| size                    	|        	|
| 2  	| binutils-2.33.1 	| nm-new                  	| -C     	|
| 3  	| binutils-2.33.1 	| objdump                 	| -D     	|
| 4  	| binutils-2.33.1 	| readelf                 	| -a     	|
| 5  	| libxml2-v2.9.2  	| xml                     	|        	|
| 6  	| lcms            	| cms_transform_fuzzer    	|        	|
| 7  	| file            	| magic_fuzzer            	|        	|
| 8  	| vorbis          	| decode_fuzzer           	|        	|
| 9  	| curl            	| curl_fuzzer_http        	|        	|
| 10 	| woff2           	| convert_woff2ttf_fuzzer 	|        	|
| 11 	| libjpeg-turbo   	| libjpeg_turbo_fuzzer    	|        	|
| 12 	| sqlite3         	| ossfuzz                 	|        	|
| 13 	| tcpdump-4.99.1  	| tcpdump                 	| -r     	|
| 14 	| freetype        	| ftfuzzer                	|        	|
| 15 	| libtiff         	| tiff_read_rgba_fuzzer   	|        	|
| 16 	| libpng-1.2.56   	| libpng_read_fuzzer      	|        	|

```
$ bash launch_building_docker.sh
# cd /data/src/benchmarks
# bash rebuild.sh
```

Building all targets at once may take a while. Feel free to modify `rebuild.sh` (the one in `Marco/src/benchmarks`) to customize which targets to build. All targets successfully built can be found under `src/benchmarks/targets/*/ce_targets`.

#### Script for building
Each target's building script can be found under `src/benchmarks/targets/*/build.sh`. To manually rebuild a target (e.g. libxml) for concolic execution, try:
```
$ bash launch_building_docker.sh
# cd /data/src/benchmarks
# git clone https://gitlab.gnome.org/GNOME/libxml2.git libxml2-v2.9.2_ce
# cd libxml2-v2.9.2_ce
# git checkout -f v2.9.2
# cp ../targets/libxml2-v2.9.2/build.sh ./
# ./build.sh ce
```
Here `ce` means to build target for concolic execution. To build the target for SanCov use `cov` instead.


## Test

### Concolic Execution Mode

Experiment configurations, such as directory of the experiment data, the number of trials, time budget, CPU core allocation, and the set of target programs to test, can be adjusted in the `launch_exp.sh` file. Once the necessary modifications are made, you can initiate the concolic execution trials by running the following command:

```
$ ./launch_exp.sh
```

The data for each trial is stored in the directory `[outroot]/[target]_[trialid]`. To check whether a trial has been successfully launched, review the contents of `debug.log` (crash message of the scheduler), `run_ce.log` (CE's log), and `Gscheduler.log` (scheduler's log) under that trial's data directory.






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

<!--
## TODO

### Hybrid Fuzzing Mode instructions

[TODO] Currently support hybrid fuzzing mode with fuzzer being AFL++ instance. To run Marco in hybrid fuzzing mode:

1. Install AFL++; [todo] add building scripts
2. Build the target for fuzzer (launch the building script with argument `afl` instead of `ce`);
3. launch exp.

### push the initial corpus of each target -->

