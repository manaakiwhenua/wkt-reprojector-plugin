[![manaakiwhenua-standards](https://github.com/manaakiwhenua/wkt-reprojector-plugin/workflows/manaakiwhenua-standards/badge.svg)](https://github.com/manaakiwhenua/manaakiwhenua-standards)

# wkt_reprojector_plugin

A sample [pygeoapi](https://github.com/geopython/pygeoapi) processing plugin. This plugin is capable of taking a WKT geometry with a stated projection, and reprojecting it to a target projection, returning the output as WKT.

Since it uses Proj v7, it is capable of supporting datum-shift transformations. The output includes information about the transformation that was applied, making this suitable for use by applications that need to maintain records of any transformations applied to data.

Sample screenshots of how this looks in (a development version of) pygeoapi: https://imgur.com/a/yJc4IdU.

## Installation

This will work without Proj datum grids being installed, but it's better if they are. They can be installed into a Docker container with the following command:

```Dockerfile
ENV PROJ_DIR=/usr/local/share/proj
# Install proj datum grids
RUN curl -L --output /tmp/proj-datumgrid-oceania-1.2.zip https://github.com/OSGeo/proj-datumgrid/releases/download/oceania-1.2/proj-datumgrid-oceania-1.2.zip \
&& unzip /tmp/proj-datumgrid-oceania-1.2.zip -d $PROJ_DIR \
&& curl -L --output /tmp/proj-datumgrid-north-america-1.4.zip https://github.com/OSGeo/proj-datumgrid/releases/download/north-america-1.4/proj-datumgrid-north-america-1.4.zip \
&& unzip /tmp/proj-datumgrid-north-america-1.4.zip -d $PROJ_DIR \
&& curl -L --output /tmp/proj-datumgrid-europe-1.6.zip https://github.com/OSGeo/proj-datumgrid/releases/download/europe-1.6/proj-datumgrid-europe-1.6.zip \
&& unzip /tmp/proj-datumgrid-europe-1.6.zip -d $PROJ_DIR \
&& curl -L --output /tmp/proj-datumgrid-world-1.0.zip https://github.com/OSGeo/proj-datumgrid/releases/download/world-1.0/proj-datumgrid-world-1.0.zip \
&& unzip /tmp/proj-datumgrid-world-1.0.zip -d $PROJ_DIR
```

### Sample transformation

To convince yourself that transformations are correctly using the datum grids: there is an example documented [here](https://gis.stackexchange.com/questions/364871/why-does-pyproj-give-a-different-point-location-compared-to-ordnance-survey-when)

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
