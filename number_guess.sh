#!/bin/bash

# تعريف متغير الاتصال بقاعدة البيانات
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# طلب اسم المستخدم
echo "Enter your username:"
read USERNAME

# التحقق مما إذا كان المستخدم موجوداً متبوعاً بجلب البيانات
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")

if [[ -z $USER_ID ]]; then
  # إذا كان المستخدم جديداً
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # إدخال المستخدم الجديد بقاعدة البيانات مع تصفير العدادات مبدئياً
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, NULL);")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")
  GAMES_PLAYED=0
  BEST_GAME=""
else
  # إذا كان المستخدم موجوداً مسبقاً
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID;")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID;")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# توليد رقم عشوائي بين 1 و 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

echo "Guess the secret number between 1 and 1000:"

while true; do
  read GUESS
  
  # التحقق مما إذا كان المدخل رقماً صحيحاً (Integer)
  if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  ((NUMBER_OF_GUESSES++))

  if [[ $GUESS -eq $SECRET_NUMBER ]]; then
    break
  elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
done

# طباعة رسالة الفوز النهائية
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

# تحديث بيانات الألعاب والمستخدم في قاعدة البيانات
NEW_GAMES_PLAYED=$((GAMES_PLAYED + 1))

if [[ -z $BEST_GAME || $BEST_GAME == "" || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]; then
  NEW_BEST_GAME=$NUMBER_OF_GUESSES
else
  NEW_BEST_GAME=$BEST_GAME
fi

UPDATE_RESULT=$($PSQL "UPDATE users SET games_played=$NEW_GAMES_PLAYED, best_game=$NEW_BEST_GAME WHERE user_id=$USER_ID;")
# Setup database connection
# Add welcome messages
# Add guessing loop
# Update stats
# DB connection
# Welcome msg
# Guess loop
# Stats fix
