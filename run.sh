#!/bin/bash

set -e

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

DATASET="iabhishekofficial/mobile-price-classification"
DATASET_FILENAME="mobile-price-classification.zip"
DATASET_DIRECTORY="data"
if [ ! -f "$DATASET_FILENAME" ]
then
  echo 'Pobieram zbiór danych...'
  kaggle datasets download "$DATASET" -f "$DATASET_FILENAME"
fi

if [ ! -d "$DATASET_DIRECTORY" ]
then
  echo 'Rozpakowuję zbiór danych...'
  unzip "$DATASET_FILENAME" -d "$DATASET_DIRECTORY" > /dev/null
fi

echo 'Uruchamiam notebook...'
jupyter notebook project.ipynb
