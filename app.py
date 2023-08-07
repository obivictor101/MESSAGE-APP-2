from flask import Flask, request, render_template, session, redirect, url_for, jsonify
import bcrypt
import MySQLdb
import os
import ssl
import re
import secrets
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from flask_wtf.csrf import CSRFProtect
import base64
from cryptography.hazmat.primitives.asymmetric import dh
from cryptography.hazmat.backends import default_backend
import json
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives.padding import PKCS7

app = Flask(__name__)

# Load the SSL certificate and key
context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
context.load_cert_chain('cert.pem', 'key.pem')

app.config['SECRET_KEY'] = secrets.token_hex(32)
app.config['SESSION_TYPE'] = 'filesystem'
app.config['UPLOAD_FOLDER'] = 'static/uploads'

# Store database credentials in a separate configuration file
db_config = {
    'host': 'localhost',
    'user': 'root',
    'passwd': '',
    'db': 'messageapp'
}

db = MySQLdb.connect(**db_config)
cursor = db.cursor(MySQLdb.cursors.DictCursor)

def insert_user_data(name, username, hashed_password):
    # Generate RSA key pair
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )

    # Get the RSA public key for storing in the database
    public_key = private_key.public_key()

    # Serialize the public key and store it in the database
    public_key_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    ).decode('utf-8')

    # Serialize the private key and store it in the database
    private_key_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()  # No encryption for simplicity; use encryption for security
    ).decode('utf-8')

    cursor.execute("INSERT INTO users (name, username, password_hash, rsa_public_key, rsa_private_key) VALUES (%s, %s, %s, %s, %s)",
                   (name, username, hashed_password, public_key_pem, private_key_pem))
    db.commit()

def get_user_data_by_username(username):
    cursor.execute("SELECT id, password_hash FROM users WHERE username=%s", (username,))
    return cursor.fetchone()

def generate_hashed_password(password):
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt(rounds=12))

def generate_random_key():
    return secrets.token_bytes(32)

def encrypt_message(message, key):
    backend = default_backend()
    iv = os.urandom(16)
    cipher = Cipher(algorithms.AES(key), modes.CFB(iv), backend=backend)
    encryptor = cipher.encryptor()
    padder = PKCS7(128).padder()  
    padded_data = padder.update(message.encode('utf-8')) + padder.finalize()
    encrypted_data = encryptor.update(padded_data) + encryptor.finalize()
    return iv + encrypted_data

def decrypt_message(encrypted_message, key):
    backend = default_backend()
    iv = encrypted_message[:16]
    encrypted_data = encrypted_message[16:]
    cipher = Cipher(algorithms.AES(key), modes.CFB(iv), backend=backend)
    decryptor = cipher.decryptor()
    decrypted_data = decryptor.update(encrypted_data) + decryptor.finalize()
    unpadder = PKCS7(128).unpadder() 
    data = unpadder.update(decrypted_data) + unpadder.finalize()
    return data.decode('utf-8')

def generate_dh_parameters():
    parameters = dh.generate_parameters(generator=2, key_size=2048)
    private_key = parameters.generate_private_key()
    public_key = private_key.public_key()
    return parameters, private_key, public_key

# Implement CSRF protection
csrf = CSRFProtect(app)

@app.route('/')
def index():
    msg = request.args.get('msg')
    if msg:
        return render_template('index.html', msg=msg)
    return render_template('index.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        name = request.form['name']
        username = request.form['username']
        password = request.form['password']

        # Validate and sanitize user input
        if not name or not username or not password:
            return render_template('register.html', msg='Please fill in all fields.')

        # Additional validation: Ensure the username contains only alphanumeric characters and underscores
        if not re.match("^[a-zA-Z0-9_]+$", username):
            return render_template('register.html', msg='Invalid username. Only letters, numbers, and underscores are allowed.')

        # Check if the username already exists
        cursor.execute("SELECT id FROM users WHERE username=%s", (username,))
        user_id = cursor.fetchone()

        if user_id:
            return render_template('register.html', msg='Username already exists. Please try another one.')
        else:
            # Hash the password securely
            hashed_password = generate_hashed_password(password)

            # Insert the new user data into the database
            insert_user_data(name, username, hashed_password)

            return render_template('register.html', msg='You have been successfully registered. You can login')

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        # Retrieve the user data from the database based on the provided username
        user_data = get_user_data_by_username(username)

        if user_data and bcrypt.checkpw(password.encode('utf-8'), user_data['password_hash'].encode('utf-8')):
            # Password is correct, proceed with login
            session['user_id'] = user_data['id']
            
            # Retrieve the RSA private key from the database and store it in the session
            cursor.execute("SELECT rsa_private_key FROM users WHERE id = %s", (user_data['id'],))
            private_key_pem = cursor.fetchone()['rsa_private_key']
            session['rsa_private_key'] = private_key_pem.encode('utf-8')
            
            return redirect(url_for('dashboard'))  # Redirect to the dashboard
        else:
            # Incorrect username or password
            return render_template('login.html', msg='Invalid credentials. Please try again.')

    return render_template('login.html')

@app.route('/dashboard', methods=['GET', 'POST'])
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    user_id = session['user_id']
    cursor = db.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM users WHERE id != %s", (user_id,))
    users = cursor.fetchall()
    return render_template('dashboard.html', users=users)

@app.route('/send', methods=['GET','POST'])
def sendmess():
    if request.method == 'POST':
        receiver_id = request.form['receiver']
        message = request.form['message']

        # Additional validation: Ensure the message is not empty
        if not message.strip():
            return '3'

        # Generate a random symmetric encryption key for each message
        key = generate_random_key()

        # Encrypt the message using the generated key and AES
        encrypted_data = encrypt_message(message, key)

        # Get the recipient's RSA public key from the database
        cursor.execute("SELECT rsa_public_key FROM users WHERE id = %s", (receiver_id,))
        recipient_public_key_pem = cursor.fetchone()['rsa_public_key'].encode('utf-8')

        # Encrypt the symmetric key using the recipient's RSA public key
        recipient_public_key = serialization.load_pem_public_key(recipient_public_key_pem, backend=default_backend())
        encrypted_symmetric_key = recipient_public_key.encrypt(
            key,
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA256()),
                algorithm=hashes.SHA256(),
                label=None
            )
        )

        # Store the encrypted message and the encrypted symmetric key in the database
        cursor.execute("INSERT INTO messages (sender_id, receiver_id, message, encryption_key) VALUES (%s, %s, %s, %s)",
                       (session['user_id'], receiver_id, encrypted_data, encrypted_symmetric_key))
        db.commit()
        
        return '1'
    
@app.route('/receive', methods=['GET'])
def recmess():
    if 'user_id' not in session:
        # If the user is not logged in, redirect to the login page or take appropriate action.
        return '2'

    cursor = db.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM messages WHERE receiver_id = %s", (session['user_id'],))
    messages = cursor.fetchall()

    decrypted_messages = []
    for message in messages:
        ciphertext = message['message']
        encrypted_symmetric_key = message['encryption_key']

        # Retrieve the user's RSA private key from the database (assuming it's already loaded into the session)
        private_key_pem = session['rsa_private_key']
        private_key = serialization.load_pem_private_key(private_key_pem, password=None, backend=default_backend())

        # Decrypt the symmetric key using the recipient's RSA private key
        try:
            symmetric_key = private_key.decrypt(
                encrypted_symmetric_key,
                padding.OAEP(
                    mgf=padding.MGF1(algorithm=hashes.SHA256()),
                    algorithm=hashes.SHA256(),
                    label=None
                )
            )
        except ValueError:
            # If the decryption fails, continue to the next message (skip this one)
            continue

        # Use the decrypted symmetric key to decrypt the message
        decrypted_message = decrypt_message(ciphertext, symmetric_key)

        # Get the sender's username
        cursor.execute("SELECT * FROM users WHERE id = %s", (message['sender_id'],))
        sender = cursor.fetchone()
        sender_username = sender['username']

        decrypted_messages.append({'username': sender_username, 'decrypted_message': decrypted_message})

    cursor.close()  # Close the cursor to avoid "out of sync" error
    return jsonify(decrypted_messages)

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('index'))

if __name__ == "__main__":
    app.run(debug=True, ssl_context=context)
