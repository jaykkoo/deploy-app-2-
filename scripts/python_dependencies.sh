#!/usr/bin/env bash

virtualenv /home/ubuntu/venv
source /home/ubuntu/venv/bin/activate
pip install -r /home/ubuntu/django-aws_cicd/requirements.txt