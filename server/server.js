const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const port = 3000;

// Serve static files from the "public" directory
app.use(express.static('public'));

// Set up storage engine
const storage = multer.diskStorage({
  destination: './public/uploads/',
  filename: function(req, file, cb) {
    cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
  }
});

// Initialize upload
const upload = multer({
  storage: storage,
  limits: { fileSize: 1000000 }, // Limit file size to 1MB
}).single('image');

app.post('/api/upload', (req, res) => {
  upload(req, res, (err) => {
    if(err) {
      res.send({ message: 'Error uploading file.', error: err });
    } else {
      if(req.file == undefined) {
        res.send({ message: 'No file selected.' });
      } else {
        res.send({ message: 'File uploaded.', filename: req.file.filename });
      }
    }
  });
});

// Endpoint to retrieve an image
app.get('/api/images', (req, res) => {
    const dir = './public/uploads/';
    fs.readdir(dir, (err, files) => {
      if (err) {
        console.error(err);
        res.status(500).send('Server error');
      } else {
        // Filter out non-image files and prepend the path
        const imageFiles = files.filter(file => /\.(jpg|jpeg|png|gif)$/i.test(file))
                               .map(file => `${req.protocol}://${req.get('host')}/uploads/${file}`);
        res.send(imageFiles);
      }
    });
  });
  

app.listen(port, () => console.log(`Server listening at http://localhost:${port}`));
