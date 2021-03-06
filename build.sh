#!/bin/bash

## Customize here
PATH_TO_TEI_STYLESHEETS="/usr/local/share/tei/Stylesheets"
PATH_TO_SAXON_JAR="/usr/share/java/Saxon-HE-9.4.0.7.jar"
PATH_TO_TRANG_JAR="/usr/share/java/trang.jar"
PATH_TO_JING="/usr/bin/jing"

## Do not customize here
TEI_TO_RELAXNG_BIN="${PATH_TO_TEI_STYLESHEETS}/bin/teitorelaxng"
BUILD_DIR="build"
CUSTOMIZATIONS_DIR="customizations"
SOURCE_DIR="source"
SAMPLES_DIR="samples"
DRIVER_FILE=${SOURCE_DIR}"/driver.xml"

all()
{
    if [ -d "build" ]; then
        echo "Removing old build directory"
        rm -r ${BUILD_DIR}
    fi

    mkdir -p ${BUILD_DIR}

    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")

    for file in $(find ${CUSTOMIZATIONS_DIR} -name '*.xml');
    do
        echo "processing" "${file}"
        $TEI_TO_RELAXNG_BIN --saxonjar=$PATH_TO_SAXON_JAR --trangjar=$PATH_TO_TRANG_JAR --localsource=$DRIVER_FILE $file $BUILD_DIR/$(basename ${file%%.*}).rng

        if [ $? = 1 ]; then
            IFS=$SAVEIFS
            echo "Build failed on" $file
            exit 1
        fi

    done

    IFS=$SAVEIFS
}

test()
{
    echo "Validating 2013 samples directory against mei-all"

    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")

    for file in $(find ${SAMPLES_DIR}/MEI2013 -name '*.mei');
    do
        echo "Testing: " $file
        $PATH_TO_JING $BUILD_DIR/mei-all.rng "${file}"

        if [ $? = 1 ]; then
            IFS=$SAVEIFS
            echo "Tests failed on" $file
            exit 1
        fi
    done

    IFS=$SAVEIFS
}

case "$1" in
    "all" ) all;;
    "test" ) test;;
    * )
        echo "Build options:"
        echo "  all"
        echo "  test"
    ;;
esac