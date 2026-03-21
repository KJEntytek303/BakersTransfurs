#!/bin/bash
find data -type f > cache
./gtmpg.pl
./greg.pl < variants.greg

cp -R ./generated/java/registries/* ../../src/main/java/net/kjentytek303/additional_transfurs/init/
cp -R ./generated/data/* ../../src/main/resources/data/
