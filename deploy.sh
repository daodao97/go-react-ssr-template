#!/bin/bash

git pull --recurse-submodules

git submodule update --init --recursive

docker compose up -d --build --remove-orphans