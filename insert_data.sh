#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
  TEAM1_ID=$($PSQL "select team_id from teams where name = '$WINNER' ")
    if [[ -z $TEAM1_ID ]]
    then
    INSERT_TEAM1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM1_NAME == "INSERT 0 1" ]]
      then
      echo Inserted team $WINNER
      fi
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
  TEAM2_ID=$($PSQL "select team_id from teams where name = '$OPPONENT' ")
    if [[ -z $TEAM2_ID ]]
    then
    INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
      then
      echo Inserted team $OPPONENT
      fi
    fi
  fi

  if [[ $YEAR != "year" ]]
  then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
    echo New game added: $YEAR, $ROUND
    fi
  fi
done