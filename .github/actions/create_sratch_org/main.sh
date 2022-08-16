#!/bin/sh -l

echo "alias $1"
echo "duration $2"
sfdx --version
echo "::set-output name=  sc_username::randonUser@gmail.com"