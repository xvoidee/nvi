#!/bin/bash

echo "%compile_commands.json" > .ccls
$1 -Wp,-v -x c++ - -fsyntax-only < /dev/null 2>&1 | sed -n '/#include <...>/,/End/p' | egrep -v '#include|End' | sed 's/ \//-I\//g' | sed 's/ (framework directory)//g' >> .ccls
