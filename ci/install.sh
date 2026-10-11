#!/bin/bash

set -exo pipefail


# Install Nox into its own venv instead of the job's interpreter: on the 2.7 legs
# `python3` is a pyenv 3.7 whose scripts dir is not on PATH (`nox: command not
# found`), and on the 3.x legs the Travis virtualenv ships a present-day
# setuptools that the pre-installed virtualenv cannot import alongside
# (`canonicalize_version() got an unexpected keyword argument
# 'strip_trailing_zero'`). ci/run.sh calls this venv's nox.
python3 -m venv "${HOME}/noxenv"
"${HOME}/noxenv/bin/python" -m pip install nox

if [[ "${NOX_SESSION}" == "app_engine" ]]; then
    python -m pip install gcp-devrel-py-tools
    gcp-devrel-py-tools download-appengine-sdk "$(dirname ${GAE_SDK_PATH})"
fi
