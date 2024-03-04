from tawhiri import api

app = api.app
app.config["ELEVATION_API"] = "http://localhost:8080"
app.config["WIND_DATASET_DIR"] = "../../grib"

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
