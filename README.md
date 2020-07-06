[![manaakiwhenua-standards](https://github.com/manaakiwhenua/wkt-reprojector-plugin/workflows/manaakiwhenua-standards/badge.svg)](https://github.com/manaakiwhenua/manaakiwhenua-standards)

# wkt_reprojector_plugin

A sample [pygeoapi](https://github.com/geopython/pygeoapi) processing plugin. This plugin is capable of taking a WKT geometry with a stated projection, and reprojecting it to a target projection, returning the output as WKT.

Since it uses Proj v7, it is capable of supporting datum-shift transformations. The output includes information about the transformation that was applied, making this suitable for use by applications that need to maintain records of any transformations applied to data.

Sample screenshots of how this looks in (a development version of) pygeoapi: https://imgur.com/a/yJc4IdU.

## Installation

This will work without PROJ datum grids being installed, but it's better if they are, since without them only fallback ("ballpark") datum transformations can be used. They can be installed into a Docker container with the following command:

```Dockerfile
ENV PROJ_DIR=/usr/local/lib/python3.8/dist-packages/pyproj/proj_dir/share/proj
# Install proj datum grids
RUN curl -L --output /tmp/proj-datumgrid-oceania-1.2.zip https://github.com/OSGeo/proj-datumgrid/releases/download/oceania-1.2/proj-datumgrid-oceania-1.2.zip \
&& unzip /tmp/proj-datumgrid-oceania-1.2.zip -d $PROJ_DIR \
&& curl -L --output /tmp/proj-datumgrid-north-america-1.4.zip https://github.com/OSGeo/proj-datumgrid/releases/download/north-america-1.4/proj-datumgrid-north-america-1.4.zip \
&& unzip /tmp/proj-datumgrid-north-america-1.4.zip -d $PROJ_DIR \
&& curl -L --output /tmp/proj-datumgrid-europe-1.6.zip https://github.com/OSGeo/proj-datumgrid/releases/download/europe-1.6/proj-datumgrid-europe-1.6.zip \
&& unzip /tmp/proj-datumgrid-europe-1.6.zip -d $PROJ_DIR \
&& curl -L --output /tmp/proj-datumgrid-world-1.0.zip https://github.com/OSGeo/proj-datumgrid/releases/download/world-1.0/proj-datumgrid-world-1.0.zip \
&& unzip /tmp/proj-datumgrid-world-1.0.zip -d $PROJ_DIR
# Include additional Ordnance Survey grids
&& curl -L --output /tmp/proj-datumgrid-europe-latest.zip https://download.osgeo.org/proj/proj-datumgrid-europe-latest.zip \
&& unzip -o /tmp/proj-datumgrid-europe-latest.zip -d $PROJ_DIR \
&& curl -L --output /tmp/OSTN15-NTv2.zip https://www.ordnancesurvey.co.uk/documents/resources/OSTN15-NTv2.zip \
&& unzip -o /tmp/OSTN15-NTv2.zip -d $PROJ_DIR \
```

If you have installed the PROJ datum grids somewhere else, you can set the environment variable `PROJ_DIR` as appropriate; this plugin will append this directory to PROJ's list of directories.

### Sample transformation

To convince yourself that transformations are correctly using the datum grids: there is an example documented [here](https://gis.stackexchange.com/questions/364871/why-does-pyproj-give-a-different-point-location-compared-to-ordnance-survey-when)

Input: `POINT Z (55.950621342577172 -3.209168460809744 116.378547668457031)` (ESPG:4326, WGS84)

Desired output: EPSG:27700 (British National Grid)

Naive output (does not use the best available transformation):

`POINT Z (324588.97992 673725.68925 116.37855)``

Output confirmed by Ordnance Survey:

`POINT Z (324589.04555 673726.19278 116.37855)``

In the job results, you should the following output, where the **Inverse of OSGB 1936 to WGS 84 (9) + British National Grid** is the key term to look for:

```json
[
    {
        "id": "wkt",
        "value": "POINT Z (324589.04555 673726.19278 116.37855)"
    },
    {
        "id": "definition",
        "value": "proj=pipeline step proj=axisswap order=2,1 step proj=unitconvert xy_in=deg xy_out=rad step inv proj=hgridshift grids=uk_os_OSTN15_NTv2_OSGBtoETRS.tif step proj=tmerc lat_0=49 lon_0=-2 k=0.9996012717 x_0=400000 y_0=-100000 ellps=airy"
    },
    {
        "id": "transformer",
        "value": {
            "$schema": "https://proj.org/schemas/v0.2/projjson.schema.json",
            "area": "UK - Britain and UKCS 49\u00b046'N to 61\u00b001'N, 7\u00b033'W to 3\u00b033'E",
            "bbox": {
                "east_longitude": 2.88,
                "north_latitude": 61.14,
                "south_latitude": 49.75,
                "west_longitude": -9.2
            },
            "name": "Inverse of OSGB 1936 to WGS 84 (9) + British National Grid",
            "source_crs": {
                "coordinate_system": {
                    "axis": [
                        {
                            "abbreviation": "Lat",
                            "direction": "north",
                            "name": "Geodetic latitude",
                            "unit": "degree"
                        },
                        {
                            "abbreviation": "Lon",
                            "direction": "east",
                            "name": "Geodetic longitude",
                            "unit": "degree"
                        }
                    ],
                    "subtype": "ellipsoidal"
                },
                "datum": {
                    "ellipsoid": {
                        "inverse_flattening": 298.257223563,
                        "name": "WGS 84",
                        "semi_major_axis": 6378137
                    },
                    "name": "World Geodetic System 1984",
                    "type": "GeodeticReferenceFrame"
                },
                "id": {
                    "authority": "EPSG",
                    "code": 4326
                },
                "name": "WGS 84",
                "type": "GeographicCRS"
            },
            "steps": [
                {
                    "accuracy": "1.0",
                    "id": {
                        "authority": "INVERSE(DERIVED_FROM(EPSG))",
                        "code": 7710
                    },
                    "method": {
                        "name": "Inverse of HORIZONTAL_SHIFT_GTIFF"
                    },
                    "name": "Inverse of OSGB 1936 to WGS 84 (9)",
                    "parameters": [
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8656
                            },
                            "name": "Latitude and longitude difference file",
                            "value": "uk_os_OSTN15_NTv2_OSGBtoETRS.tif"
                        }
                    ],
                    "source_crs": {
                        "coordinate_system": {
                            "axis": [
                                {
                                    "abbreviation": "Lat",
                                    "direction": "north",
                                    "name": "Geodetic latitude",
                                    "unit": "degree"
                                },
                                {
                                    "abbreviation": "Lon",
                                    "direction": "east",
                                    "name": "Geodetic longitude",
                                    "unit": "degree"
                                }
                            ],
                            "subtype": "ellipsoidal"
                        },
                        "datum": {
                            "ellipsoid": {
                                "inverse_flattening": 298.257223563,
                                "name": "WGS 84",
                                "semi_major_axis": 6378137
                            },
                            "name": "World Geodetic System 1984",
                            "type": "GeodeticReferenceFrame"
                        },
                        "id": {
                            "authority": "EPSG",
                            "code": 4326
                        },
                        "name": "WGS 84",
                        "type": "GeographicCRS"
                    },
                    "target_crs": {
                        "coordinate_system": {
                            "axis": [
                                {
                                    "abbreviation": "Lat",
                                    "direction": "north",
                                    "name": "Geodetic latitude",
                                    "unit": "degree"
                                },
                                {
                                    "abbreviation": "Lon",
                                    "direction": "east",
                                    "name": "Geodetic longitude",
                                    "unit": "degree"
                                }
                            ],
                            "subtype": "ellipsoidal"
                        },
                        "datum": {
                            "ellipsoid": {
                                "inverse_flattening": 299.3249646,
                                "name": "Airy 1830",
                                "semi_major_axis": 6377563.396
                            },
                            "name": "OSGB 1936",
                            "type": "GeodeticReferenceFrame"
                        },
                        "id": {
                            "authority": "EPSG",
                            "code": 4277
                        },
                        "name": "OSGB 1936",
                        "type": "GeographicCRS"
                    },
                    "type": "Transformation"
                },
                {
                    "id": {
                        "authority": "EPSG",
                        "code": 19916
                    },
                    "method": {
                        "id": {
                            "authority": "EPSG",
                            "code": 9807
                        },
                        "name": "Transverse Mercator"
                    },
                    "name": "British National Grid",
                    "parameters": [
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8801
                            },
                            "name": "Latitude of natural origin",
                            "unit": "degree",
                            "value": 49
                        },
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8802
                            },
                            "name": "Longitude of natural origin",
                            "unit": "degree",
                            "value": -2
                        },
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8805
                            },
                            "name": "Scale factor at natural origin",
                            "unit": "unity",
                            "value": 0.9996012717
                        },
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8806
                            },
                            "name": "False easting",
                            "unit": "metre",
                            "value": 400000
                        },
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8807
                            },
                            "name": "False northing",
                            "unit": "metre",
                            "value": -100000
                        }
                    ],
                    "type": "Conversion"
                }
            ],
            "target_crs": {
                "base_crs": {
                    "coordinate_system": {
                        "axis": [
                            {
                                "abbreviation": "Lat",
                                "direction": "north",
                                "name": "Geodetic latitude",
                                "unit": "degree"
                            },
                            {
                                "abbreviation": "Lon",
                                "direction": "east",
                                "name": "Geodetic longitude",
                                "unit": "degree"
                            }
                        ],
                        "subtype": "ellipsoidal"
                    },
                    "datum": {
                        "ellipsoid": {
                            "inverse_flattening": 299.3249646,
                            "name": "Airy 1830",
                            "semi_major_axis": 6377563.396
                        },
                        "name": "OSGB 1936",
                        "type": "GeodeticReferenceFrame"
                    },
                    "id": {
                        "authority": "EPSG",
                        "code": 4277
                    },
                    "name": "OSGB 1936"
                },
                "conversion": {
                    "method": {
                        "id": {
                            "authority": "EPSG",
                            "code": 9807
                        },
                        "name": "Transverse Mercator"
                    },
                    "name": "British National Grid",
                    "parameters": [
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8801
                            },
                            "name": "Latitude of natural origin",
                            "unit": "degree",
                            "value": 49
                        },
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8802
                            },
                            "name": "Longitude of natural origin",
                            "unit": "degree",
                            "value": -2
                        },
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8805
                            },
                            "name": "Scale factor at natural origin",
                            "unit": "unity",
                            "value": 0.9996012717
                        },
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8806
                            },
                            "name": "False easting",
                            "unit": "metre",
                            "value": 400000
                        },
                        {
                            "id": {
                                "authority": "EPSG",
                                "code": 8807
                            },
                            "name": "False northing",
                            "unit": "metre",
                            "value": -100000
                        }
                    ]
                },
                "coordinate_system": {
                    "axis": [
                        {
                            "abbreviation": "E",
                            "direction": "east",
                            "name": "Easting",
                            "unit": "metre"
                        },
                        {
                            "abbreviation": "N",
                            "direction": "north",
                            "name": "Northing",
                            "unit": "metre"
                        }
                    ],
                    "subtype": "Cartesian"
                },
                "id": {
                    "authority": "EPSG",
                    "code": 27700
                },
                "name": "OSGB 1936 / British National Grid",
                "type": "ProjectedCRS"
            },
            "type": "ConcatenatedOperation"
        }
    },
    {
        "id": "best_available",
        "value": true
    }
]
```

If you can reproduce the latter result, then the transformations are being applied correctly.

## Building for release

Requires wheel.

`python setup.py sdist bdist_wheel`

This can be included in a requirements.txt as: `git+https://github.com/manaakiwhenua/wkt-reprojector-plugin.git@master`

`master` branch is for release, changes should be proposed in a separate branch and a PR submitted for merging into master, including rebuilding the source distributions.
