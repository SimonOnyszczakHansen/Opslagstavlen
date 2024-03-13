const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

app.get("/test", (req, res) => {
    res.json({message: "IT WORKS"});
});

app.listen(port, () => {
    console.log("Server listening at http://localhost:${port}")
});