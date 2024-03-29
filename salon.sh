#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  echo -e "Welcome to My Salon, how can I help you?\n"
  # menu 
  MENU=$($PSQL "SELECT service_id, name FROM services")
  echo "$MENU" | while read SERVICE_ID BAR NAME
  do 
    echo -e "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
   case $SERVICE_ID_SELECTED in
    1) CUT_STYLING ;;
    2) TECHNICAL_COLOURING ;;
    3) SPECIAL_OCCASION ;; 
    4) TREATMENTS ;;
    *) MAIN_MENU ;;
  esac
}

CUT_STYLING(){
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # If customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]] 
  then
    # Get customer name & appointment time
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME 
    echo -e "\nAt what time do you want the service?"
    read SERVICE_TIME
    
    # Insert new customer
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (name,phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    # Insert appointment
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nI have put you down for a$NAME at $SERVICE_TIME, $CUSTOMER_NAME."   
  fi   
}

MAIN_MENU
