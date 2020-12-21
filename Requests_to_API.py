
#-----------------------------------------------------Test №3

import yaml	   
import requests
import mysql.connector
import datetime

from mysql.connector import errorcode

try:
	mydb = mysql.connector.connect(                         #Establishing the connection to db.
		host='localhost',
		user='root',
		password='777denis',
		port='3306',
		database='kids'
		)

except mysql.connector.Error as err:
	if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
		print("Something is wrong with your user name or password")
	elif err.errno == errorcode.ER_BAD_DB_ERROR:
		print("Database does not exist")
	else:
		print(err)

except Exception as e:
        template = "An exception of type {} occured. Arguments:\n{!r}"
        mes = template.format(type(e).__name__, e.args)
        print(mes)


mycursor = mydb.cursor()                                      #Create cursor.




def get_data_from_API(cathegory='games', params={}):                                     #This function makes request to API.
    if params == {}:
        params = {
        "date_to":datetime.date.today(),
        "date_from":datetime.datetime(2020, 12, 3) - datetime.timedelta(days=7)
        }
    try:
        url = 'http://kids.example.com/' + cathegory + '/'
        response = requests.get(url, params=params)

        data = yaml.load(response, Loader=yaml.FullLoader)
        
        return data['games']

    except Exception as e:
        print("Some troubles with API.")
        template = "An exception of type {} occured. Arguments:\n{!r}"
        mes = template.format(type(e).__name__, e.args)
        print(mes)
        return ""

def insert_data_to_games(data):                         #Adding all data to the db -> `kids.games`
    try:

        for id, name, date in data:
            sql = ("INSERT INTO games (game_id, name, date) VALUES (%s) ")                   
            val = (id, name, date)
            mycursor.execute(sql, val)                                           
            mydb.commit()

        return "Good job!"

    except Exception as e:
        template = "An exception of type {} occured. Arguments:\n{!r}"
        mes = template.format(type(e).__name__, e.args)
        print(mes)

def insert_data_to_toys(data):                          #Adding all data to the db -> `kids.toys`
    try:

        for id, name, status, st_updated in data:
            sql = ("INSERT INTO toys (toy_id, name, status, status_updated) VALUES (%s) ")                   
            val = (id, name, status, st_updated)
            mycursor.execute(sql, val)                                           
            mydb.commit()

        return "Good job!"

    except Exception as e:
        template = "An exception of type {} occured. Arguments:\n{!r}"
        mes = template.format(type(e).__name__, e.args)
        print(mes)

def insert_data_to_toys_repair(data):                   #Adding all data to the db -> `kids.toys_repair` and than can sort useful data.                        
    try:

        for g_id, t_id, note in data:
            sql = ("INSERT INTO toys_repair (game_id, toy_id, note) VALUES (%s) ")                   
            val = (g_id, t_id, note)
            mycursor.execute(sql, val)                                           
            mydb.commit()

        query = ("SELECT * FROM toys_repair join toys_games as tg"
                 "using(toy_id)"
                 "WHERE  note like '%repair%' or '%broken%' or '%break%' "
                 "ORDER BY toy_id ")

        mycursor.execute(query)
        results = mycursor.fetchall()

        # We can fix some information into file->
        # ---
        # with open('some_data.yaml', 'w') as f:   
            # data = yaml.dump(f, Loader=yaml.FullLoader)
        # ---

        return results

    except Exception as e:
        template = "An exception of type {} occured. Arguments:\n{!r}"
        mes = template.format(type(e).__name__, e.args)
        print(mes)






