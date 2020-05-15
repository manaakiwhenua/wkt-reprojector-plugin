# wkt_reprojector_plugin

A sample [pygeoapi]() processing plugin. This plugin is capable of taking a WKT geometry with a stated projection, and reprojecting it to a target projection, returning the output as WKT.

Since it uses Proj v6, it is capable of supporting datum-shift transformations. The output includes information about the transformation that was applied, making this suitable for use by applications that need to maintain records of any transformations applied to data.

## Distribution

Uploaded to pypi with [Twine](https://pypi.org/project/twine/).
