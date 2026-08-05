FROM registry.redhat.io/rhel9/python-314

ARG TARGETARCH

USER 0

WORKDIR /workspace
COPY upstream/openshift-virtualization-tests/ /workspace/

ENV LANG=C.UTF-8
ENV CNV_TESTS_CONTAINER=Yes

RUN pip3 install uv
ENV UV_PYTHON_INSTALL_DIR=/opt/python

RUN uv sync --locked

