#!/bin/bash

set -e

version=${1:?Input version}
outDir=$(realpath pack)

if [[ "$2" == "--push" ]]; then
    source=${3:?--push <source> <api key>}
    apiKey=${4:?--push <source> <api key>}
fi

function dotnet_restore {
    local path=$1

    pushd $path > /dev/null
    echo "[dotnet] restore"
    dotnet restore --no-cache
    popd > /dev/null
}

function dotnet_pack {
    local path=$1

    pushd $path > /dev/null
    echo "[dotnet] pack"
    dotnet pack -c Release -o $outDir -p:Version=$version --nologo --no-restore ${@:2}
    popd > /dev/null
}

function dotnet_nuget_push {
    local nupkg=$1
    local source=$2
    local apiKey=$3

    echo "[dotnet] $nupkg push to $source"
    dotnet nuget push $nupkg --source $source --api-key $apiKey
}

rm -rf $outDir

echo " ** J2NET ** "
dotnet_restore src/J2NET
dotnet_pack src/J2NET

if [[ "$2" == "--push" ]]; then
    for nupkg in $outDir/*.nupkg ; do
        dotnet_nuget_push $nupkg $source $apiKey
    done
fi