#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# Get this EC2's instance ID
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

# Create feedback form webpage
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback Form</title>
    <style>
        body { font-family: Arial; background: #f5f7fa; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .form-card { background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.2); width: 350px; }
        input, textarea, select, button { width: 100%; padding: 10px; margin: 8px 0; border-radius: 5px; border: 1px solid #ccc; }
        button { background-color: #3498db; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #2980b9; }
        #instance-id { color: #e74c3c; font-weight: bold; text-align: center; margin-top: 15px; }
        .thankyou { color: green; font-weight: bold; text-align: center; margin-top: 10px; }
    </style>
</head>
<body>
<div class="form-card">
    <h1>Feedback Form</h1>
    <form id="feedback-form">
        <input type="text" name="name" placeholder="Enter Name" required>
        <input type="email" name="email" placeholder="Enter Email" required>
        <textarea name="message" placeholder="Your Message" required></textarea>
        <select name="rating">
            <option value="">Rate us</option>
            <option value="1">★</option>
            <option value="2">★★</option>
            <option value="3">★★★</option>
            <option value="4">★★★★</option>
            <option value="5">★★★★★</option>
        </select>
        <button type="submit">Submit</button>
        <div class="thankyou" id="thankyou-msg"></div>
    </form>
    <div id="instance-id">Served by Instance: $INSTANCE_ID</div>
</div>

<script>
    document.getElementById('feedback-form').addEventListener('submit', function(e){
        e.preventDefault();
        document.getElementById('thankyou-msg').innerText = "Thank you for your feedback!";
        this.reset();
    });
</script>
</body>
</html>
EOF

