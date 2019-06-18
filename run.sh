#!/bin/bash

if [ ! -d ".venv" ]
then
  echo 'Tworzę wirtualne środowisko...'
  python3 -m venv .venv
fi

. ./.venv/bin/activate

if [ "$(pip freeze --local | diff requirements.txt - | wc -l)" -gt 0 ]
then
  echo 'Instaluję zależności...'
  pip install -r requirements.txt > /dev/null
fi

if [ ! -d ".venv/share/jupyter/kernels/venv" ]
then
  echo 'Instaluję kernel...'
  ipython kernel install --sys-prefix --name=venv > /dev/null
fi

DATASET_URL="https://data.seattle.gov/api/views/tw7j-dfaw/rows.csv?accessType=DOWNLOAD"
DATASET_FILENAME="seattle-cycle-share.csv"
if [ ! -f "$DATASET_FILENAME" ]
then
  echo 'Pobieram zbiór danych (44,8 MB)...'
  wget -q -O $DATASET_FILENAME $DATASET_URL
fi

echo 'Uruchamiam notebook...'
jupyter notebook seattle-cycle-share.ipynb
