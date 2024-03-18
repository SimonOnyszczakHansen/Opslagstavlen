const express = require('express');
const multer = require('multer');
const path = require('path'); 
const fs = require('fs');
const jwt = require('jsonwebtoken');
const cors = require('cors');

const app = express(); // Create an Express application
const port = 3000; // Define the port number for the server to listen on

// Middlewares
app.use(cors()); // Enable CORS for all domains
app.use(express.static('public')); // Serve static files from the 'public' directory
app.use(express.json()); // Parse JSON bodies in incoming requests

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: './public/uploads/', // Destination directory for uploaded files
  filename: function (req, file, cb) {
    // Generate a unique filename for the uploaded file
    cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
  }
});

// Initialize multer with the storage configuration and file size limit
const upload = multer({
  storage: storage,
  limits: { fileSize: 1000000 }, // 1MB file size limit
}).single('image'); // Accept a single file with the field name 'image'

// JWT secret for signing tokens, use environment variable or a fallback string
const jwtSecret = process.env.JWT_SECRET || 'your-secret-key';

// POST endpoint for user login
app.post('/api/login', (req, res) => {
  const { username, password } = req.body;
  // Example credentials check (in a real application, verify against a database)
  if (username === 'user1' && password === '1234') {
    const user = { username: 'user1', mail: 'simon@mail.com' }
    // Sign a JWT for the authenticated user
    jwt.sign({ user }, jwtSecret, { expiresIn: '1h' }, (err, token) => {
      if (err) {
        res.sendStatus(500); // Internal server error
      } else {
        res.json({ token }); // Send the JWT to the client
      }
    });
  } else {
    res.status(401).json({ message: 'invalid credentials' }); // Unauthorized access
  }
});

// POST endpoint for file uploads
app.post('/api/upload', (req, res) => {
  upload(req, res, (err) => {
    if (err) {
      // Handle file upload errors
      res.send({ message: 'Error uploading file.', error: err });
    } else {
      if (req.file == undefined) {
        // No file was selected for upload
        res.send({ message: 'No file selected.' });
      } else {
        // File was successfully uploaded
        res.send({ message: 'File uploaded.', filename: req.file.filename });
      }
    }
  });
});

// GET endpoint to retrieve a list of uploaded images
app.get('/api/images', (req, res) => {
  const dir = './public/uploads/'; // Directory where uploaded images are stored
  fs.readdir(dir, (err, files) => {
    if (err) {
      // Handle errors reading the directory
      console.error(err);
      res.status(500).send('Server error');
    } else {
      // Filter and send the list of image files
      const imageFiles = files.filter(file => /\.(jpg|jpeg|png|gif)$/i.test(file))
        .map(file => `${req.protocol}://${req.get('host')}/uploads/${file}`);
      res.send(imageFiles);
    }
  });
});

// Start the server
app.listen(port, () => console.log(`Server listening at http://localhost:${port}`));
