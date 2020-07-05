from setuptools import setup

setup(name='wkt_reprojector_plugin',
    version='0.1.0',
    description='pygeoapi plugin for performing reprojection on geometries encoded as WKT',
    url='https://github.com/manaakiwhenua/wkt-reprojector-plugin',
    author='Richard Law',
    author_email='lawr@landcareresearch.co.nz',
    license='MIT',
    packages=['wkt_reprojector_plugin'],
    install_requires=[
        'pyproj>=2.6.1', 'shapely>=1.7.0'
    ],
    zip_safe=False
)
