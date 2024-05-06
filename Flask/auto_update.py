import os
import time
import subprocess
import sys

def get_remote_sha():
    result = subprocess.run(['git', 'rev-parse', 'origin/main'], stdout=subprocess.PIPE)
    return result.stdout.decode('utf-8').strip()

def get_local_sha():
    result = subprocess.run(['git', 'rev-parse', 'main'], stdout=subprocess.PIPE)
    return result.stdout.decode('utf-8').strip()

def main():
    os.chdir("/root/automa-it")  # Change to the directory of the Git repository

    previous_sha = get_local_sha()

    while True:
        time.sleep(60)  # Wait for 60 seconds before checking again
        subprocess.run(['git', 'fetch', 'origin', 'main'])  # Fetch the latest changes
        remote_sha = get_remote_sha()
        local_sha = get_local_sha()

        if remote_sha != local_sha:
            print("Change detected. Updating...")
            subprocess.run(['docker', 'compose', 'down'])  # Stop the current container
            subprocess.run(['docker', 'rm', '-f', 'scriptusmaximus'])  # Remove the container
            subprocess.run(['docker', 'compose', 'up', '-d'])  # Start the container again
            subprocess.run(['git', 'pull', 'origin', 'main'])  # Pull the latest changes
            previous_sha = remote_sha
        else:
            print("No changes detected.")

if __name__ == "__main__":
    main()