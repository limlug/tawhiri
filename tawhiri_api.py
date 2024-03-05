from tawhiri import api
import os

app = api.app
app.config["ELEVATION_API"] = os.environ["ELEVATION_API"]
app.config["WIND_DATASET_DIR"] = "/grib"

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
