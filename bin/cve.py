#!/usr/bin/env python3
import requests
import logging
import sys

logging.basicConfig(level=logging.WARN)


def cve_list():
    cves = []
    for cve in sys.argv[1:]:
        if cve == "-":
            cves.extend([x.strip() for x in sys.stdin.read().split()])
        else:
            cves.append(cve)
    return filter(None, cves)


def cve_patches1(cve):
    def is_patch(ref):
        return 'tags' in ref and "Patch" in ref['tags'] and \
               'url' in ref and 'git' in ref['url']

    if not cve.upper().startswith("CVE-"):
        cve = "CVE-" + cve
    logging.debug(f"Retrieving {cve}")
    r = requests.get(f"https://services.nvd.nist.gov/rest/json/cve/1.0/{cve}")
    response = r.json()
    try:
        refdata = response['result']['CVE_Items'][0]['cve']['references']['reference_data']
    except KeyError as e:
        logging.error(f"Index error, {response=}")
        return []
    cve_data = [f"{cve:20.20s} {ref['url']}" for ref in refdata if is_patch(ref)]
    return cve_data or [f"{cve:20.20s} ???"]


def cve_patches(cve_list):
    if cve_list is None:
        return ""
    return "\n".join(["\n".join(cve_patches1(cve)) for cve in cve_list])


if __name__ == "__main__":
    print(cve_patches(cve_list()))
