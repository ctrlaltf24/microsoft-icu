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
$icuDir = Resolve-Path -Path '$icuDir\..\icu\icu4c'

echo  $icuDir

# ok, create some work areas
New-Item -Path "$icuDir\source\dist" -ErrorAction SilentlyContinue -ItemType "directory"
$source = "$icuDir\source\dist\to_package"
Get-ChildItem -Path $source -ErrorAction SilentlyContinue | Remove-Item -Recurse
New-Item -Path $source -ItemType "directory" -ErrorAction SilentlyContinue
New-Item -Path "$source\windows" -ItemType "directory" -ErrorAction SilentlyContinue
New-Item -Path "$source\windows\system32" -ItemType "directory" -ErrorAction SilentlyContinue
New-Item -Path "$source\windows\syswow64" -ItemType "directory" -ErrorAction SilentlyContinue
New-Item -Path "$source\windows\globalization" -ItemType "directory" -ErrorAction SilentlyContinue
New-Item -Path "$source\windows\globalization\ICU" -ItemType "directory" -ErrorAction SilentlyContinue

# copy required stuff
# Dlls
Copy-Item -Path "$icuDir\bin64\icu.dll" -Destination "$source\windows\system32\"
Copy-Item -Path "$icuDir\bin64\icuuc.dll" -Destination "$source\windows\system32\"
Copy-Item -Path "$icuDir\bin64\icuin.dll" -Destination "$source\windows\system32\"
Copy-Item -Path "$icuDir\bin\icu.dll" -Destination "$source\windows\syswow64\"
Copy-Item -Path "$icuDir\bin\icuuc.dll" -Destination "$source\windows\syswow64\"
Copy-Item -Path "$icuDir\bin\icuin.dll" -Destination "$source\windows\syswow64\"

# data and .res (this assumes an in-source tree build)
Copy-Item -Path "$icuDir\source\data\out\icudt72l.dat" -Destination "$source\windows\globalization\ICU\icudtl.dat"
Copy-Item -Path "$icuDir\source\data\out\build\icudt72l\metaZones.res" -Destination "$source\windows\globalization\ICU\"
Copy-Item -Path "$icuDir\source\data\out\build\icudt72l\timezoneTypes.res" -Destination "$source\windows\globalization\ICU\"
Copy-Item -Path "$icuDir\source\data\out\build\icudt72l\windowsZones.res" -Destination "$source\windows\globalization\ICU\"
Copy-Item -Path "$icuDir\source\data\out\build\icudt72l\zoneinfo64.res" -Destination "$source\windows\globalization\ICU\"

Copy-Item -Path "$icuDir\LICENSE" -Destination "$source\windows\globalization\ICU\LICENSE-ICU"


$destination = "$icuDir\source\dist\icu-win.tar.gz"
Remove-Item -Path $destination -ErrorAction Continue
Echo $source
Echo $destination

tar -cvf $destination -C $source .

echo $destination