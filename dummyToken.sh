#!/bin/bash
echo "Inserting Keys!"
DEVISE_SECRET_TOKEN=`bundle exec rake secret`
echo $DEVISE_SECRET_TOKEN
echo "export DEVISE_SECRET_TOKEN=$DEVISE_SECRET_TOKEN" >> ~/.bash_profile
echo "export SECRET_KEY_BASE=f4cd2c8dcfb4a3bc3f2696f8bc01305bda70c5e88e94b4d5e96bea4670ad896862660f80b48fcf3c98c422a2e9341f1bfd5b48576c639a947d536cc2e" >> ~/.bash_profile
echo "Keys Successfully Inserted"
