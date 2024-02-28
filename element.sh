#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Verifica si no se proporcionaron argumentos
if [ ! "$#" -gt 0 ]; then
  echo "Please provide an element as an argument."
  exit
fi

# Verifica si el primer argumento es un número
if [[ "$1" =~ ^[0-9]+$ ]]; then
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number = $1")
else
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol = '$1' or name = '$1'")
fi

# Verifica si ATOMIC_NUMBER es nulo
if [ -z "$ATOMIC_NUMBER" ]; then
  echo "I could not find that element in the database."
  exit
fi

SYMBOL=$($PSQL "select symbol from elements where atomic_number = $ATOMIC_NUMBER")
NAME=$($PSQL "select name from elements where atomic_number = $ATOMIC_NUMBER")
ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number = $ATOMIC_NUMBER")
MELTING_POINT_CELSIUS=$($PSQL "select melting_point_celsius from properties where atomic_number = $ATOMIC_NUMBER")
BOILING_POINT_CELSIUS=$($PSQL "select boiling_point_celsius from properties where atomic_number = $ATOMIC_NUMBER")
TYPE=$($PSQL "select types.type from properties full join types on properties.type_id = types.type_id where properties.atomic_number = $ATOMIC_NUMBER")

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
