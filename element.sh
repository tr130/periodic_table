#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

SEARCH_FIELD=""
SEARCH_TERM=$1

if [[ ! $SEARCH_TERM ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $SEARCH_TERM =~ ^[0-9]+$ ]]
  then
    SEARCH_FIELD="atomic_number"
  elif [[ $SEARCH_TERM =~ ^[A-Z][a-z]?$ ]]
  then
    SEARCH_FIELD="symbol"
  else
    SEARCH_FIELD="name"
  fi
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $SEARCH_FIELD = '$1'")
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT_INFO | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
