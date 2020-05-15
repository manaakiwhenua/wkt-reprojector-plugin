# wkt_reprojector_plugin

A sample [pygeoapi](https://github.com/geopython/pygeoapi) processing plugin. This plugin is capable of taking a WKT geometry with a stated projection, and reprojecting it to a target projection, returning the output as WKT.

Since it uses Proj v6, it is capable of supporting datum-shift transformations. The output includes information about the transformation that was applied, making this suitable for use by applications that need to maintain records of any transformations applied to data.

Sample screenshots of how this looks in (a development version of) pygeoapi: https://imgur.com/a/yJc4IdU.

## Building for release

Requires wheel.

`python setup.py sdist bdist_wheel`

This can be included in a requirements.txt as: `git+https://github.com/manaakiwhenua/wkt-reprojector-plugin.git@master`

`master` branch is for release, changes should be proposed in a separate branch and a PR submitted for merging into master, including rebuilding the source distributions.
