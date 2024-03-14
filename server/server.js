// Required Node.js modules
const express = require('express'); // Framework for building web applications
const multer = require('multer'); // Middleware for handling multipart/form-data, used for uploading files
const path = require('path'); // Provides utilities for working with file and directory paths
const fs = require('fs'); // File System module to interact with the file system

const app = express(); // Create an Express application
const port = 3000; // Port number for the server to listen on

// Serve static files from the "public" directory
app.use(express.static('public'));

// Set up storage engine for Multer
const storage = multer.diskStorage({
  destination: './public/uploads/', // Set the destination for storing uploaded files
  filename: function(req, file, cb) {
    // Set the filename for the uploaded file
    cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
  }
});

// Initialize upload configuration using Multer
const upload = multer({
  storage: storage, // Use the storage engine defined above
  limits: { fileSize: 1000000 }, // Set the file size limit to 1MB
}).single('image'); // Specify that the field name in the form should be 'image', and only one file at a time

// Endpoint for handling file uploads
app.post('/api/upload', (req, res) => {
  upload(req, res, (err) => {
    if(err) {
      // If an error occurred during uploading, send an error message
      res.send({ message: 'Error uploading file.', error: err });
    } else {
      if(req.file == undefined) {
        // If no file was selected for upload, send a message indicating so
        res.send({ message: 'No file selected.' });
      } else {
        // If the file was successfully uploaded, send a success message and the filename
        res.send({ message: 'File uploaded.', filename: req.file.filename });
      }
    }
  });
});

// Endpoint to retrieve a list of uploaded images
app.get('/api/images', (req, res) => {
    const dir = './public/uploads/'; // Directory where uploaded images are stored
    fs.readdir(dir, (err, files) => {
      if (err) {
        // If an error occurred reading the directory, send a server error
        console.error(err);
        res.status(500).send('Server error');
      } else {
        // Filter the list of files to only include images and prepend the path to each file
        const imageFiles = files.filter(file => /\.(jpg|jpeg|png|gif)$/i.test(file))
                               .map(file => `${req.protocol}://${req.get('host')}/uploads/${file}`);
        res.send(imageFiles); // Send the list of image files
      }
    });
  });

// Start the server and listen on the specified port
app.listen(port, () => console.log(`Server listening at http://localhost:${port}`));
