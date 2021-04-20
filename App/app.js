var express = require("express");
var app = express();
var port = 3000;
var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

var mongoose = require("mongoose");
mongoose.Promise = global.Promise;
const DB_USER = 'admin';
const PASSWORD = encodeURIComponent('p@ssw0rd');

var mongoUrl = `mongodb://${DB_USER}:${PASSWORD}@10.10.0.200:27017,10.10.16.201:27017,10.10.32.202:27017/app?replicaSet=rs01`

var connectWithRetry = function() {
return mongoose.connect(mongoUrl, { useNewUrlParser: true, authSource:'admin'}, function(err) {
    if (err) {
    console.error('Failed to connect to mongo on startup - retrying in 5 sec', err);
    setTimeout(connectWithRetry, 5000);
    }
});
};
connectWithRetry();

var nameSchema = new mongoose.Schema({
    firstName: String,
    lastName: String
});
var User = mongoose.model("User", nameSchema);

app.get("/", (req, res) => {
    res.sendFile(__dirname + "/index.html");
});

app.post("/addname", (req, res) => {
    var myData = new User(req.body);
    myData.save()
        .then(item => {
            res.send("Name saved to database");
        })
        .catch(err => {
            res.status(400).send("Unable to save to database");
        });
});

app.listen(port, () => {
    console.log("Server listening on port " + port);
});