useful: https://unicode-org.github.io/icu/userguide/icu_data/buildtool.html

setup env (in one cmd terminal unless otherwise specified):
- `"C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"`
- `PATH`
- Now insert `C:\tools\cygwin\bin\` after the MSVC but before the remainder per https://unicode-org.github.io/icu/userguide/icu4c/build.html#configuring-icu-on-windows
- `set PATH=`...
- (in git bash) `dos2unix -f config* runConfigureICU mkinstalldirs`
- edit runConfigureICU to add the following under the platform MSYS/MSVC (next setting CXX=cl). This is needed to turn on C++17 (alternatively you could export these envs)
```
        CPPFLAGS="$CPPFLAGS -std:c++17"
        CXXFLAGS="$CXXFLAGS -std:c++17"
```
- if you're building in a different dir, fix the path-ing on the file `configure=$configuredir/configure`
- (back in cmd) `bash ./runConfigureICU MSYS/MSVC --with-library-bits=64 --with-data-packaging=archive --disable-renaming --disable-tests`
- `make` (this is needed for generating the icu76l.dat, we could cope it but this is easier)
- Generate libs for combined build `msbuild icu\icu4c\source\allinone\allinone.sln /p:Configuration=Release /p:Platform=x64 /p:SkipUWP=true`
- Generate the combined icu.dll `msbuild icu\icu4c\source\command-and-i18n\combined.vcxproj /p:Configuration=Release /p:Platform=x64 `