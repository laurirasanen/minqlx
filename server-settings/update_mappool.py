#!/usr/bin/env python3
import requests


def write_mappool(filename, mode):
    with open(filename, 'w') as f:
        for mapname in maps:
            print("{}|qlrace_{}".format(mapname, mode), file=f)

maps = requests.get("https://qlrace.com/api/maps").json()["maps"]
write_mappool("baseq3/mappool_qlrace.txt", "turbo")
write_mappool("baseq3/mappool_qlrace_classic.txt", "classic")
