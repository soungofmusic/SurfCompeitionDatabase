# Authors: Alan Massey, Spencer Oung
# CS340 Project: Wave of the Day
# Created: 5/21/2024
# Citation: Flask Starter App Materials were modified to create this file

from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
import os

app = Flask(__name__)

app.config["MYSQL_HOST"] = "classmysql.engr.oregonstate.edu"
app.config["MYSQL_USER"] = "cs340_xxxx"
app.config["MYSQL_PASSWORD"] = "xxxx"
app.config["MYSQL_DB"] = "cs340_xxxx"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

mysql = MySQL(app)


# Routes for each page
# App Route for Home Page containing Links to all Subpages
@app.route("/")
def home():
    # renders index.html
    return render_template("index.html")


# route for Surfers page
@app.route("/surfers", methods=["POST", "GET"])
def surfers():
    if request.method == "POST":
        # fire off if user presses the Add Person button
        if request.form.get("Add_Surfer"):
            # grab user form inputs from surfers.j2
            first_name = request.form["first_name"]
            last_name = request.form["last_name"]
            origin_country = request.form["origin_country"]
            age = request.form["age"]
            world_rank = request.form["world_rank"]

            # Executes query to add surfer into Surfers table
            query = "INSERT INTO Surfers (first_name, last_name, origin_country, age, world_rank) VALUES (%s,%s,%s,%s,%s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (first_name, last_name, origin_country, age, world_rank))
            mysql.connection.commit()

            # Once a surfer is added, redirects to the surfers page
            return redirect("/surfers")

    # For rendering Surfers in page
    if request.method == "GET":
        # mySQL query to display all the people in Surfers
        query = "SELECT surfer_id, first_name, last_name, origin_country, age, world_rank FROM Surfers"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # Renders the surfers in a table using surfers.j2
        return render_template("surfers.j2", data=data)


# Route for deleting surfers
@app.route("/delete_surfers/<int:surfer_id>")
def delete_surfers(surfer_id):
    # mySQL query to delete the surfer with our passed surfer_id
    query = "DELETE FROM Surfers WHERE surfer_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (surfer_id,))
    mysql.connection.commit()

    # redirect back to surfers page
    return redirect("/surfers")


# App for editing a surfer
@app.route("/edit_surfers/<int:surfer_id>", methods=["POST", "GET"])
def edit_surfer(surfer_id):
    if request.method == "GET":
        # mySQL query to display the info of the surfer with using the surfer_id
        query = "SELECT * FROM Surfers WHERE surfer_id = %s" % (surfer_id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # Renders surfer on edit_surfers page using surfer_id of the surfer chosen
        return render_template("edit_surfers.j2", data=data)

    # Used when editing attributes of surfers
    if request.method == "POST":

        # Activated when using the Edit_Surfer button in edit_surfers.j2
        if request.form.get("Edit_Surfer"):
            # User inputs from form
            surfer_id = request.form["surfer_id"]
            first_name = request.form["first_name"]
            last_name = request.form["last_name"]
            origin_country = request.form["origin_country"]
            age = request.form["age"]
            world_rank = request.form["world_rank"]

            # Updates values based on user input
            query = "UPDATE Surfers SET first_name = %s,last_name = %s,origin_country = %s, age = %s, world_rank = %s WHERE surfer_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (first_name, last_name, origin_country, age, world_rank, surfer_id))
            mysql.connection.commit()

            # redirect back to surfers page after we execute the update query
            return redirect("/surfers")


# Route to competitions
@app.route("/competitions", methods=["POST", "GET"])
def competitions():
    if request.method == "POST":
        # fire off if user presses the Add Person button
        if request.form.get("Add_Competition"):
            # grab user form inputs from competitions.j2
            competition_name = request.form["competition_name"]
            competition_location = request.form["competition_location"]
            competition_date = request.form["competition_date"]

            # Executes query to add competition'' into competitions table
            query = "INSERT INTO Competitions (competition_name, competition_location, competition_date) VALUES (%s,%s,%s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (competition_name, competition_location, competition_date))
            mysql.connection.commit()

            # Once a competition is added, redirects to the competitions page
            return redirect("/competitions")
        
    if request.method == "GET":
        query: str = "SELECT * FROM Competitions"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        return render_template("competitions.j2", data=data)
    
@app.route("/delete_competitions/<int:competition_id>")
def delete_competitions(competition_id):
    # mySQL query to delete the competition with our passed competition_id
    query = "DELETE FROM Competitions WHERE competition_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (competition_id,))
    mysql.connection.commit()

    # redirect back to competitions page
    return redirect("/competitions")

# Route for editing a competition
@app.route("/edit_competitions/<int:competition_id>", methods=["POST", "GET"])
def edit_competition(competition_id):
    if request.method == "GET":
        query = "SELECT * FROM Competitions WHERE competition_id = %s"
        cur = mysql.connection.cursor()
        cur.execute(query, (competition_id,))
        data = cur.fetchall()

        return render_template("edit_competitions.j2", data=data)

    if request.method == "POST":
        if request.form.get("Edit_Competition"):
            competition_id = request.form["competition_id"]
            competition_name = request.form["competition_name"]
            competition_location = request.form["competition_location"]
            competition_date = request.form["competition_date"]

            query = "UPDATE Competitions SET competition_name = %s, competition_location = %s, competition_date = %s WHERE competition_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (competition_name, competition_location, competition_date, competition_id))
            mysql.connection.commit()

            return redirect("/competitions")

@app.route("/rounds", methods=["POST", "GET"])
def rounds():
    if request.method == "POST":
        if request.form.get("Add_Round"):
            competition_id = request.form["competition_id"]
            round_type = request.form["round_type"]

            query = "INSERT INTO Rounds (competition_id, round_type) VALUES (%s, %s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (competition_id, round_type))
            mysql.connection.commit()

            return redirect("/rounds")

    if request.method == "GET":
        query = "SELECT Rounds.round_id, Competitions.competition_name, Rounds.round_type FROM Rounds INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        
        query2 = "SELECT Competitions.competition_id, Competitions.competition_name FROM Competitions"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        competition_data = cur.fetchall()

        return render_template("rounds.j2", data=data, competitions = competition_data)

# Route for deleting rounds
@app.route("/delete_round/<int:round_id>")
def delete_round(round_id):
    query = "DELETE FROM Rounds WHERE round_id = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (round_id,))
    mysql.connection.commit()

    return redirect("/rounds")

# Route for editing a round
@app.route("/edit_rounds/<int:round_id>", methods=["POST", "GET"])
def edit_round(round_id):
    if request.method == "GET":
        query = "SELECT Rounds.round_id, Competitions.competition_name, Rounds.round_type FROM Rounds INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id WHERE round_id = %s"
        cur = mysql.connection.cursor()
        cur.execute(query, (round_id,))
        data = cur.fetchall()
        
        query2 = "SELECT Competitions.competition_id, Competitions.competition_name FROM Competitions"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        competition_data = cur.fetchall()

        return render_template("edit_rounds.j2", data=data, competitions = competition_data)

    if request.method == "POST":
        if request.form.get("Edit_Round"):
            round_id = request.form["round_id"]
            competition_id = request.form["competition_id"]
            round_type = request.form["round_type"]

            query = "UPDATE Rounds SET competition_id = %s, round_type = %s WHERE round_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (competition_id, round_type, round_id))
            mysql.connection.commit()

            return redirect("/rounds")

# Route for heats page
@app.route("/heats", methods=["POST", "GET"])
def heats():
    if request.method == "POST":
        if request.form.get("Add_Heat"):
            round_id = request.form["round_id"]
            heat_number = request.form["heat_number"]
            
            query = "INSERT INTO Heats (round_id, heat_number) VALUES (%s, %s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (round_id, heat_number))
            mysql.connection.commit()

            return redirect("/heats")

    if request.method == "GET":
        query = "SELECT Heats.heat_id, Competitions.competition_name, Rounds.round_type, Heats.heat_number FROM Heats INNER JOIN Rounds ON Heats.round_id = Rounds.round_id INNER JOIN Competitions on Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        
        query2 = "SELECT Competitions.competition_name, Rounds.round_id, Rounds.round_type FROM Rounds INNER JOIN Competitions on Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        round_data = cur.fetchall()

        return render_template("heats.j2", data=data, rounds = round_data)

# Route for deleting heats
@app.route("/delete_heat/<int:heat_id>")
def delete_heat(heat_id):
    query = "DELETE FROM Heats WHERE heat_id = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (heat_id,))
    mysql.connection.commit()

    return redirect("/heats")

# Route for editing a heat
@app.route("/edit_heats/<int:heat_id>", methods=["POST", "GET"])
def edit_heat(heat_id):
    if request.method == "GET":
        query = "SELECT Heats.heat_id, Competitions.competition_name, Rounds.round_type, Heats.heat_number FROM Heats INNER JOIN Rounds ON Heats.round_id = Rounds.round_id INNER JOIN Competitions on Rounds.competition_id = Competitions.competition_id WHERE Heats.heat_id = %s" % (heat_id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        
        query2 = "SELECT Competitions.competition_name, Rounds.round_id, Rounds.round_type FROM Rounds INNER JOIN Competitions on Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        round_data = cur.fetchall()

        return render_template("edit_heats.j2", data=data, rounds = round_data)

    if request.method == "POST":
        if request.form.get("Edit_Heat"):
            heat_id = request.form["heat_id"]
            round_id = request.form["round_id"]
            heat_number = request.form["heat_number"]

            query = "UPDATE Heats SET round_id = %s, heat_number = %s WHERE heat_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (round_id, heat_number, heat_id))
            mysql.connection.commit()

            return redirect("/heats")

# Route for heat scores page
@app.route("/heat-scores", methods=["POST", "GET"])
def heat_scores():
    if request.method == "POST":
        if request.form.get("Add_Heat_Score"):
            surfer_id = request.form["surfer_id"]
            heat_id = request.form["heat_id"]
            score_num = request.form["score_num"]

            query = "INSERT INTO Heat_Scores (surfer_id, heat_id, score_num) VALUES (%s, %s, %s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (surfer_id, heat_id, score_num))
            mysql.connection.commit()

            return redirect("/heat-scores")

    if request.method == "GET":
        query = "SELECT Heat_Scores.score_id, Surfers.first_name, Surfers.last_name, Competitions.competition_name, Rounds.round_type, Heats.heat_number, Heat_Scores.score_num FROM Surfers INNER JOIN Heat_Scores ON Surfers.surfer_id = Heat_Scores.surfer_id INNER JOIN Heats ON Heat_Scores.heat_id = Heats.heat_id INNER JOIN Rounds ON Heats.round_id = Rounds.round_id INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id ORDER BY Heat_Scores.score_id ASC"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        
        query2 = "SELECT Surfers.surfer_id, Surfers.first_name, Surfers.last_name FROM Surfers"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        surfer_data = cur.fetchall()
        
        query3 = "SELECT Competitions.competition_name, Rounds.round_type, Heats.heat_id, Heats.heat_number FROM Heats INNER JOIN Rounds ON Heats.round_id = Rounds.round_id INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query3)
        heat_data = cur.fetchall()
        
        return render_template("heat-scores.j2", data=data, surfers = surfer_data, heats = heat_data)

# Route for deleting heat scores
@app.route("/delete_heat-scores/<int:score_id>")
def delete_heat_score(score_id):
    query = "DELETE FROM Heat_Scores WHERE score_id = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (score_id,))
    mysql.connection.commit()

    return redirect("/heat-scores")

# Route for editing a heat score
@app.route("/edit_heat-scores/<int:score_id>", methods=["POST", "GET"])
def edit_heat_score(score_id):
    if request.method == "GET":
        query = "SELECT Heat_Scores.score_id, Surfers.first_name, Surfers.last_name, Competitions.competition_name, Rounds.round_type, Heats.heat_number, Heat_Scores.score_num FROM Surfers INNER JOIN Heat_Scores ON Surfers.surfer_id = Heat_Scores.surfer_id INNER JOIN Heats ON Heat_Scores.heat_id = Heats.heat_id INNER JOIN Rounds ON Heats.round_id = Rounds.round_id INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id WHERE score_id = %s"
        cur = mysql.connection.cursor()
        cur.execute(query, (score_id,))
        data = cur.fetchall()
        
        query2 = "SELECT Surfers.surfer_id, Surfers.first_name, Surfers.last_name FROM Surfers"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        surfer_data = cur.fetchall()
        
        query3 = "SELECT Competitions.competition_name, Rounds.round_type, Heats.heat_id, Heats.heat_number FROM Heats INNER JOIN Rounds ON Heats.round_id = Rounds.round_id INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query3)
        heat_data = cur.fetchall()

        return render_template("edit_heat-scores.j2", data=data, surfers = surfer_data, heats = heat_data)

    if request.method == "POST":
        if request.form.get("Edit_Heat_Score"):
            score_id = request.form["score_id"]
            surfer_id = request.form["surfer_id"]
            heat_id = request.form["heat_id"]
            score_num = request.form["score"]

            query = "UPDATE Heat_Scores SET surfer_id = %s, heat_id = %s, score_num = %s WHERE score_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (surfer_id, heat_id, score_num, score_id))
            mysql.connection.commit()

            return redirect("/heat-scores")


# Route to results
@app.route("/results", methods=["POST", "GET"])
def results():
    if request.method == "POST":
        if request.form.get("Add_Result"):
            surfer_id = request.form["surfer_id"]
            competition_id = request.form["competition_id"]
            round_id = request.form["round_id"]
            heat_id = request.form["heat_id"]
            result_type = request.form["result_type"]
            placement = request.form["placement"]
            
            # Allows for the passing of Null values if a field is left blank
            if round_id == "" or round_id == 'N/A':
                round_id = None
            if heat_id == "" or round_id == 'N/A':
                heat_id = None
                
            query = "INSERT INTO Results (surfer_id,competition_id,round_id,heat_id,result_type,placement) VALUES (%s, %s, %s, %s, %s, %s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (surfer_id,competition_id,round_id,heat_id,result_type,placement))
            mysql.connection.commit()

            return redirect("/results")

    if request.method == "GET":
        query = "SELECT Results.result_id, Surfers.first_name, Surfers.last_name, Competitions.competition_name, Rounds.round_type, Heats.heat_number, Results.result_type, placement FROM Results INNER JOIN Surfers ON Results.surfer_id = Surfers.surfer_id INNER JOIN Competitions on Results.competition_id = Competitions.competition_id LEFT JOIN Rounds ON Results.round_id = Rounds.round_id LEFT JOIN Heats ON Results.heat_id = Heats.heat_id ORDER BY Results.result_id ASC"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        query2 = "SELECT Surfers.surfer_id, Surfers.first_name, Surfers.last_name FROM Surfers"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        surfer_data = cur.fetchall()
        
        query3 = "SELECT Competitions.competition_id, Competitions.competition_name FROM Competitions"
        cur = mysql.connection.cursor()
        cur.execute(query3)
        competition_data = cur.fetchall()
        
        query4 = "SELECT Rounds.round_id, Competitions.competition_id,Competitions.competition_name, Rounds.round_type FROM Rounds INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query4)
        round_data = cur.fetchall()
        
        query5 = "SELECT Heats.heat_id, Competitions.competition_name, Rounds.round_type, Heats.heat_number FROM Heats INNER JOIN Rounds ON Heats.round_id = Rounds.round_id INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query5)
        heat_data = cur.fetchall()
        
        return render_template("results.j2", data=data, surfers = surfer_data, competitions = competition_data, rounds = round_data, heats = heat_data)
    
        
        
    
@app.route("/delete_results/<int:result_id>")
def delete_result(result_id):
    query = "DELETE FROM Results WHERE result_id = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (result_id,))
    mysql.connection.commit()

    return redirect("/results")

@app.route("/edit_results/<int:result_id>", methods=["POST", "GET"])
def edit_result(result_id):
    if request.method == "GET":
        # mySQL query to display the info of the result with using the result_id

        query = "SELECT Results.result_id, Surfers.first_name, Surfers.last_name, Competitions.competition_name, Rounds.round_type, Heats.heat_number, Results.result_type, placement FROM Results INNER JOIN Surfers ON Results.surfer_id = Surfers.surfer_id INNER JOIN Competitions on Results.competition_id = Competitions.competition_id LEFT JOIN Rounds ON Results.round_id = Rounds.round_id LEFT JOIN Heats ON Results.heat_id = Heats.heat_id WHERE result_id = %s" % (result_id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        
        query2 = "SELECT Surfers.surfer_id, Surfers.first_name, Surfers.last_name FROM Surfers"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        surfer_data = cur.fetchall()
        
        query3 = "SELECT Competitions.competition_id, Competitions.competition_name FROM Competitions"
        cur = mysql.connection.cursor()
        cur.execute(query3)
        competition_data = cur.fetchall()
        
        query4 = "SELECT Rounds.round_id, Competitions.competition_id,Competitions.competition_name, Rounds.round_type FROM Rounds INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query4)
        round_data = cur.fetchall()
        
        query5 = "SELECT Heats.heat_id, Competitions.competition_name, Rounds.round_type, Heats.heat_number FROM Heats INNER JOIN Rounds ON Heats.round_id = Rounds.round_id INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id"
        cur = mysql.connection.cursor()
        cur.execute(query5)
        heat_data = cur.fetchall()

        # Renders result on edit_results page using result_id of the result chosen
        return render_template("edit_results.j2",  data=data, surfers = surfer_data, competitions = competition_data, rounds = round_data, heats = heat_data)

    # Used when editing attributes of results
    if request.method == "POST":

        # Activated when using the Edit_Surfer button in edit_results.j2
        if request.form.get("Edit_Result"):
            # User inputs from form
            result_id = request.form["result_id"]
            surfer_id = request.form["surfer_id"]
            competition_id = request.form["competition_id"]
            round_id = request.form["round_id"]
            heat_id = request.form["heat_id"]
            result_type = request.form["result_type"]
            placement = request.form["placement"]

            if round_id == "" or round_id == 'N/A':
                round_id = None
            if heat_id == "" or round_id == 'N/A':
                heat_id = None
                
            # Updates values based on user input
            query = "UPDATE Results SET surfer_id = %s, competition_id = %s, round_id = %s, heat_id = %s, result_type = %s, placement = %s WHERE result_id = %s"
            cur = mysql.connection.cursor()
            cur.execute(query, (surfer_id, competition_id, round_id, heat_id, result_type, placement, result_id))
            mysql.connection.commit()

            # redirect back to results page after we execute the update query
            return redirect("/results")

if __name__ == "__main__":
    app.run(port=3453, debug=True)
