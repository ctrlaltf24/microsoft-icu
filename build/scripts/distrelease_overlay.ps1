# Copyright (C) 2016 and later: Unicode, Inc. and others.
# License & terms of use: http://www.unicode.org/copyright.html
#-------------------------
# Script: icu\packaging\distrelease_overlay.ps1
# Original Author: Steven R. Loomis
# Date: 2017-04-14
# Edited by: Nathan Shaaban
# Date: 2024-10-22
#-------------------------
#
# This builds a tarball containing the icu binaries that windows ships with

$icuDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$icuDir = Resolve-Path -Path '$icuDir\..'

echo  $icuDir

# ok, create some work areas
New-Item -Path "$icuDir\source\dist" -ErrorAction SilentlyContinue -ItemType "directory"
$source = "$icuDir\source\dist\windows"
Get-ChildItem -Path $source -ErrorAction SilentlyContinue | Remove-Item -Recurse
New-Item -Path $source -ItemType "directory" -ErrorAction SilentlyContinue

# copy required stuff
# Dlls 
Copy-Item -Path "$icuDir\bin64\icu.dll" -Destination "$source\system32\" -Recurse
Copy-Item -Path "$icuDir\bin\icu.dll" -Destination "$source\syswow64\" -Recurse
# XXX: also copy icuuc and icuin after we can figure out how to generate them...

# data and .res (this assumes an in-source tree build)
Copy-Item -Path "$icuDir\data\out\icudt72l.dat" -Destination "$source\Globalization\ICU\icudtl.dat"
Copy-Item -Path "$icuDir\data\out\build\metaZones.res" -Destination "$source\Globalization\ICU\"
Copy-Item -Path "$icuDir\data\out\build\timezoneTypes.res" -Destination "$source\Globalization\ICU\"
Copy-Item -Path "$icuDir\data\out\build\windowsZones.res" -Destination "$source\Globalization\ICU\"
Copy-Item -Path "$icuDir\data\out\build\zoneinfo64.res" -Destination "$source\Globalization\ICU\"

Copy-Item -Path "$icuDir\LICENSE" -Destination "$source\Globalization\ICU\LICENSE-ICU" -Recurse


$destination = "$icuDir\source\dist\icu-win.tar.gz"
Remove-Item -Path $destination -ErrorAction Continue
Echo $source
Echo $destination

tar -cvf $destination $source

echo $destination