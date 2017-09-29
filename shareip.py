#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Module: shareip.py
Author: zlamberty
Created: 2017-09-28

Description:


Usage:
<usage>

"""

import argparse
import datetime
import json
import socket

import boto3
import requests


# ----------------------------- #
#   Module Constants            #
# ----------------------------- #

BUCKET_NAME = 'shareip.lamberty.io'
KEY_NAME = 'rzl.ip.json'


# ----------------------------- #
#   Main routine                #
# ----------------------------- #

def main(bucketname=BUCKET_NAME, keyname=KEY_NAME):
    # get ip address, hostname, and current time
    try:
        resp = requests.get('https://api.ipify.org', params={'format': 'json'})
        ip = resp.json()['ip']
    except:
        ip = 'oh shit dun bustred'

    hostname = socket.getfqdn()
    now = str(datetime.datetime.now())

    # set up aws s3 resource
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(bucketname)

    # get the existing file contents
    s3file = bucket.Object(keyname)

    try:
        j = json.loads(s3file.get()['Body'].read())
    except:
        j = {}

    # update as needed:
    j[hostname] = {
        'ip': ip,
        'datetime': now,
    }

    j['most_recent_update'] = now

    # post to s3
    resp = s3file.put(
        Body=json.dumps(j),
        ContentType='application/json',
    )


# ----------------------------- #
#   Command line                #
# ----------------------------- #

def parse_args():
    """ Take a log file from the commmand line """
    parser = argparse.ArgumentParser()

    bucketname = "s3 bucket name"
    parser.add_argument(
        "-b", "--bucketname", help=bucketname, default=BUCKET_NAME
    )

    keyname = "file key name"
    parser.add_argument(
        "-k", "--keyname", help=keyname, default=KEY_NAME
    )

    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    main(bucketname=args.bucketname, keyname=args.keyname)
