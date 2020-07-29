FROM pygeoapi
LABEL maintainer="Richard Law <lawr@landcareresearch.co.nz>"

# ENV PROJ_DIR=/usr/local/share/proj
ENV PROJ_DIR=/usr/local/lib/python3.8/dist-packages/pyproj/proj_dir/share/proj

ENV DEB_BUILD_DEPS="curl unzip"

RUN apt-get update && apt-get install -y ${DEB_BUILD_DEPS}

# Install proj datum grids
RUN curl -L --output /tmp/proj-datumgrid-oceania-1.2.zip https://github.com/OSGeo/proj-datumgrid/releases/download/oceania-1.2/proj-datumgrid-oceania-1.2.zip \
&& unzip /tmp/proj-datumgrid-oceania-1.2.zip -d $PROJ_DIR \
&& curl -L --output /tmp/proj-datumgrid-north-america-1.4.zip https://github.com/OSGeo/proj-datumgrid/releases/download/north-america-1.4/proj-datumgrid-north-america-1.4.zip \
&& unzip /tmp/proj-datumgrid-north-america-1.4.zip -d $PROJ_DIR \
&& curl -L --output /tmp/proj-datumgrid-europe-1.6.zip https://github.com/OSGeo/proj-datumgrid/releases/download/europe-1.6/proj-datumgrid-europe-1.6.zip \
&& unzip /tmp/proj-datumgrid-europe-1.6.zip -d $PROJ_DIR \
&& curl -L --output /tmp/proj-datumgrid-world-1.0.zip https://github.com/OSGeo/proj-datumgrid/releases/download/world-1.0/proj-datumgrid-world-1.0.zip \
&& unzip /tmp/proj-datumgrid-world-1.0.zip -d $PROJ_DIR \
# Include additional Ordnance Survey grids
&& curl -L --output /tmp/proj-datumgrid-europe-latest.zip https://download.osgeo.org/proj/proj-datumgrid-europe-latest.zip \
&& unzip -o /tmp/proj-datumgrid-europe-latest.zip -d $PROJ_DIR \
&& curl -L --output /tmp/OSTN15-NTv2.zip https://www.ordnancesurvey.co.uk/documents/resources/OSTN15-NTv2.zip \
&& unzip -o /tmp/OSTN15-NTv2.zip -d $PROJ_DIR \
# Do the above as one command to avoid large intermediate images
&& apt-get remove --purge ${DEB_BUILD_DEPS} -y

WORKDIR /pygeoapi
ENTRYPOINT ["/entrypoint.sh"]
