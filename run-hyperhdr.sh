#!/data/data/com.termux/files/usr/bin/bash

BASE=$(cd "$(dirname "$0")" && pwd)

export LD_LIBRARY_PATH=$BASE/build/lib:$LD_LIBRARY_PATH

$BASE/build/bin/hyperhdr

