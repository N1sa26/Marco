export CFLAGS=
export CXXFLAGS=
export KO_DONT_OPTIMIZE=1
export KO_CC=clang-6.0

cd /
wget https://raw.githubusercontent.com/llvm/llvm-project/5feb80e748924606531ba28c97fe65145c65372e/compiler-rt/lib/fuzzer/standalone/StandaloneFuzzTargetMain.c -O ./StandaloneFuzzTargetMain.c

KO_DONT_OPTIMIZE=1 $CC -c ./StandaloneFuzzTargetMain.c -fPIC -o ./driver.o
ar r /driver.a ./driver.o
cp /driver.a /usr/lib/libFuzzingEngine.a
