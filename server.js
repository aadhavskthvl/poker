const express = require('express');
const bodyParser = require('body-parser');

const app = express();

// Use body-parser middleware to parse JSON bodies
app.use(bodyParser.json());

// Listen for POST requests to /submitData
app.post('/submitData', (req, res) => {
  console.log('POST request received at /submitData');
  console.log('Request body:', req.body);

  // Send a response back to the client
  res.json({ message: 'Data received successfully' });
});

// Start the server on port 3000
app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
