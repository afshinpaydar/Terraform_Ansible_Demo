const express = require('express');
const app = express();
var ip = require("ip");

app.listen(3000, function(){
  console.log("server up on port 3000");

  app.get("/",(req, res) => {
    res.sendFile(__dirname + '/index.html')
  })

  app.post("/address",(req, res) => {
    res.send(`Host name is: ${ip.address().toString()}`);
  })
})
