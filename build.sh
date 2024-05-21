#! /usr/bin/env bash

rm Stols.love
rm -rf web

zip -9 -x "dist/*" -x ".git/*" -r Stols.love .
love.js Stols.love web -t "Stols"
