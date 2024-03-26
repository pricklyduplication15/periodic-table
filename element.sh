PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"
SYMBOL=$1

SEARCH() {
  if [[ -z $1 ]]; then
 echo -e "Search by atomic number, symbol, or name: " 
 read QUERY
 else
  QUERY=$1
    if [[ $QUERY =~ ^[0-9]+$ ]]; then
      RESPONSE=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number="$QUERY"")
      ATOMIC_NUMBER=$RESPONSE
    elif [[ $QUERY =~ ^[A-Za-z]{1,2}$ ]]; then
      RESPONSE=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$QUERY'")
      ATOMIC_NUMBER=$RESPONSE
    elif [[ $QUERY =~ [A-Za-z]{3,40} ]]; then
      RESPONSE=$($PSQL "SELECT atomic_number FROM elements WHERE name='$QUERY'")
      ATOMIC_NUMBER=$RESPONSE
    else
    echo -e "I could not find that element in the database."
    exit
fi
fi

if [[ $RESPONSE ]]; then
NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
TYPE=$($PSQL "SELECT type FROM types WHERE type_id='$TYPE_ID'")
ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")

FORMATTED_ATOMIC_NUMBER=$(echo -e "${ATOMIC_NUMBER}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
FORMATTED_NAME=$(echo -e "${NAME}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
FORMATTED_SYMBOL=$(echo -e "${SYMBOL}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
FORMATTED_TYPE=$(echo -e "${TYPE}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
FORMATTED_ATOMIC_MASS=$(echo -e "${ATOMIC_MASS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
FORMATTED_MELTING_POINT_CELSIUS=$(echo -e "${MELTING_POINT_CELSIUS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
FORMATTED_BOILING_POINT_CELSIUS=$(echo -e "${BOILING_POINT_CELSIUS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

echo -e "The element with atomic number $FORMATTED_ATOMIC_NUMBER is $FORMATTED_NAME ($FORMATTED_SYMBOL). It's a $FORMATTED_TYPE, with a mass of $FORMATTED_ATOMIC_MASS amu. $FORMATTED_NAME has a melting point of $FORMATTED_MELTING_POINT_CELSIUS celsius and a boiling point of $FORMATTED_BOILING_POINT_CELSIUS celsius."
else
echo "I could not find that element in the database."
fi
}


if [[ -z $1 ]]; then
 echo "Please provide an element as an argument."
 exit
 else
 SEARCH "$1"
 fi

