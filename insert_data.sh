#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Empty all rows in the tables.
echo $($PSQL "TRUNCATE games, teams")

# Read games.csv and insert into each table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# Insert teams into table
  # Get winner team name
  if [[ $WINNER != winner ]]
    then
      # Get team name
      WINNING_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
        # Create team name if not found
        if [[ -z $WINNING_TEAM ]]
          then
            INSERT_WINNING_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
            # Announce creation of new team
              if [[ $INSERT_WINNING_TEAM == "INSERT 0 1" ]]
                then 
                  echo Inserted $WINNER to teams
              fi
        fi
  fi

  # Get opponent team 
  if [[ $OPPONENT != opponent ]]
    then
      # Get team name
      OPPOSING_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
        # Create team name if not found
        if [[ -z $OPPOSING_TEAM ]]
          then
            INSERT_OPPOSING_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
            # Announce creation of new team
              if [[ $INSERT_OPPOSING_TEAM == "INSERT 0 1" ]]
                then 
                  echo Inserted $OPPONENT to teams
              fi
        fi
  fi

# Insert game data
  if [[ YEAR != "year" ]]
    then
      # Get winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      # Get opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      # Insert new games
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
        # Announce creation of new team
        if [[ $INSERT_GAME == "INSERT 0 1" ]]
          then
            echo In $YEAR, in the $ROUND round, $WINNER_ID beat $OPPONENT_ID, with a score of $WINNER_GOALS to $OPPONENT_GOALS
        fi
  fi

done