## MPFR failure

> possibly undefined macro: AX_PTHREAD If this token and others are legitimate, please use m4_pattern_allow.

Install
[autoconf-archive](https://www.gnu.org/software/autoconf-archive/)
package with the system package manager.

## macOS try disable Zstd to avoid

```
make[3]: *** [s-selftest-c] Error 4
make[3]: *** Waiting for unfinished jobs....
dyld[41139]: Library not loaded: @rpath/libzstd.1.dylib
  Referenced from: <9DC13B0B-CEBA-32C8-8235-9A5B8A18FA10> cmake-build-gcc/build/GCC-prefix/src/GCC-build/gcc/cc1plus
  Reason: tried: 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libstdc++-v3/src/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libssp/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libgomp/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libitm/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libatomic/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/./gcc/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/./prev-gcc/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libstdc++-v3/src/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libssp/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libgomp/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libitm/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/aarch64-apple-darwin23.4.0/libatomic/.libs/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/./gcc/libzstd.1.dylib' (no such file), 'cmake-build-gcc/build/GCC-prefix/src/GCC-build/./prev-gcc/libzstd.1.dylib' (no such file), '/usr/local/lib/libzstd.1.dylib' (no such file), '/usr/lib/libzstd.1.dylib' (no such file, not in dyld cache)
```
