from flask import Flask, render_template

# Import our pymongo library, which lets us connect our Flask app to our Mongo database.
import pymongo

# Create an instance of our Flask app.
app = Flask(__name__)

#create route that renders index.html template
@app.route("/")
def index():
    mars = mondo.db.mars.find_one()
    return render_templates("index.html", mars = mars)

#create route that renders index.html template
@app.route("/scrape")

def scrape():
    listings = mongo.db.mars
    mars_data = mission_to_mars.scrape()
    mars.update(
        {},
        mars_data,
        upsert=True
    )
     # Redirect back to home page
    return redirect("http://localhost:5000/", code=302)

if __name__ == "__main__":
    app.run(debug=True)

