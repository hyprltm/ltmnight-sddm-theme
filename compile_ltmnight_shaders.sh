#!/bin/bash
set -e

QSB_TOOL="/usr/lib/qt6/bin/qsb"

if [ ! -f "$QSB_TOOL" ]; then
    echo "Error: qsb tool not found at $QSB_TOOL"
    echo "Please install qt6-shadertools"
    exit 1
fi

echo ":: Compiling Shaders..."
mkdir -p Components

# Compile Vertex Shader
echo "   Compiling ltmnight.vert..."
"$QSB_TOOL" --glsl "100 es,120,150" --hlsl 50 --msl 12 --batchable -o Components/ltmnight.vert.qsb Shaders/ltmnight.vert

# Compile Fragment Shader
echo "   Compiling ltmnight.frag..."
"$QSB_TOOL" --glsl "100 es,120,150" --hlsl 50 --msl 12 --batchable -o Components/ltmnight.frag.qsb Shaders/ltmnight.frag

echo ":: Done!"
ls -lh Components/*.qsb
