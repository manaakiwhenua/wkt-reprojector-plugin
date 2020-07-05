[![manaakiwhenua-standards](https://github.com/manaakiwhenua/wkt-reprojector-plugin/workflows/manaakiwhenua-standards/badge.svg)](https://github.com/manaakiwhenua/manaakiwhenua-standards)

# wkt_reprojector_plugin

A sample [pygeoapi](https://github.com/geopython/pygeoapi) processing plugin. This plugin is capable of taking a WKT geometry with a stated projection, and reprojecting it to a target projection, returning the output as WKT.

Since it uses Proj v7, it is capable of supporting datum-shift transformations. The output includes information about the transformation that was applied, making this suitable for use by applications that need to maintain records of any transformations applied to data.

Sample screenshots of how this looks in (a development version of) pygeoapi: https://imgur.com/a/yJc4IdU.

## Sample transformation

...to convince yourself that transformations are correct.

There is an example documented [here](https://gis.stackexchange.com/questions/364871/why-does-pyproj-give-a-different-point-location-compared-to-ordnance-survey-when)

Input: `POINT Z (55.950621342577172 -3.209168460809744 116.378547668457031)` (ESPG:4326, WGS84)

Desired output: EPSG:27700 (British National Grid)

Naive output (does not use the best available transformation):

POINT Z (324588.97991822625 673725.6892528223 116.378547668457031)

Output confirmed by Ordnance Survey:

POINT Z (324589.0436663538 73726.1910941075 116.378547668457031)

If you can reproduce the latter result, then the transformations are being applied correctly.

## Building for release

Requires wheel.

`python setup.py sdist bdist_wheel`

This can be included in a requirements.txt as: `git+https://github.com/manaakiwhenua/wkt-reprojector-plugin.git@master`

`master` branch is for release, changes should be proposed in a separate branch and a PR submitted for merging into master, including rebuilding the source distributions.
