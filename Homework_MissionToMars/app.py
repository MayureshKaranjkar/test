# Dependencies
from flask import Flask, jsonify, render_template, request
import pymongo
import scrape_mars

app = Flask(__name__)

conn = 'mongodb://localhost:27017'
client = pymongo.MongoClient(conn)
db = client.mars_db
mars = db.mars


@app.route("/")
def index():
    mars_info = db.mars.find_one()

    return render_template("index.html", mars_info=mars_info)


@app.route("/scrape")
def scrape():
    mars_info = db.mars
    mars_data = scrape_mars.Scrape()
    mars_info.update(
        {},
        mars_data,
        upsert = True
    )

    return index()

if __name__ == "__main__":
    app.run(debug=False)