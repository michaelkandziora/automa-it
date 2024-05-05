from flask import Flask, request, make_response
import tarfile
import base64
import io
import os
from config import Config

app = Flask(__name__)
config = Config()

@app.route('/install.sh', methods=['POST', 'GET'])
def send_scripts():
    if request.method == 'POST':
        data = request.get_json(silent=True) or {}
    else:  # For GET requests
        data = {}
    
    tag = data.get('tag', 'default')
    
    with io.BytesIO() as tar_buffer:
        with tarfile.open(fileobj=tar_buffer, mode='w') as tar:
            for filepath in config.filepaths.get(tag, config.filepaths['default']):
                full_path = filepath
                tar.add(full_path, arcname=os.path.basename(filepath))
        tar_base64 = base64.b64encode(tar_buffer.getvalue()).decode('utf-8')

    # Lesen Sie die Datei "install.sh" in die Variable "install_script" ein
    with open("./Scripts/install.sh", "r") as file:
        install_script = file.read()
        
    # Ersetzen Sie den Platzhalter "{{TAR_ARCHIVE_BASE64}}" durch "tar_base64"
    install_script = install_script.replace("{{TAR_ARCHIVE_BASE64}}", tar_base64)
    
    response = make_response(install_script, 200)
    response.mimetype = "text/plain"
    return response

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
