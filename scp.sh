#!/bin/bash

# Function to upload a file to the EC2 instance
upload_file() {
    read -p "Enter the EC2 server name: " server_name

    read -p "Enter the EC2 instance IP address: " ip_address

    read -p "Enter the name of the file you want to upload: " local_file

    echo "Enter the destination directory on the EC2 instance:"
    read remote_directory

    echo "Searching for the key pair (.pem file) in your Users directory..."
    key_pair=$(find /c/Users -iname "Amalitech_Training.pem" )
    var=$(find /c/Users -iname "$local_file")

    if [ -z "$key_pair" ]; then
        echo "No key pair (.pem) file found. Please ensure it is downloaded in the Users directory."
        exit 1
    fi

    echo "Using key pair: $key_pair"
    chmod 400"$key_pair"
    echo "Uploading $local_file to $server_name@$ip_address:$remote_directory"
    scp -i "$key_pair" "$var" "$server_name@$ip_address:$remote_directory"

    echo "File uploaded successfully!"
}

# Function to download a file from the EC2 instance
download_file() {
    read -p "Enter the EC2 server name: " server_name
    read -p "Enter the EC2 instance IP address: "ip_address

    echo "Enter the full path to the file on the EC2 instance (e.g., /home/ubuntu/myfile.txt):"
    read remote_file

    echo "Enter the destination directory on your local machine (e.g., /c/Users/YourUsername/Documents/):"
    read local_directory

    echo "Searching for the key pair (.pem file) in your Users directory..."
    key_pair=$(find /c/Users -iname "Amalitech_Training.pem")

    if [ -z "$key_pair" ]; then
        echo "No key pair (.pem) file found. Please ensure it is downloaded in the Users directory."
        exit 1
    fi

    echo "Using key pair: $key_pair"
    chmod 400"$key_pair"
    echo "Downloading $remote_file from $server_name@$ip_address to $local_directory"
    scp -i "$key_pair"  "$server_name@$ip_address:$remote_file" "$local_directory"

    echo "File downloaded successfully!"
}

# Main logic: Ask the user if they want to upload or download
echo "Do you want to upload or download a file? (u for upload, d for download)"
read action

if [ "$action" = "u" ]; then
    upload_file
elif [ "$action" = "d" ]; then
    download_file
else
    echo "Invalid option. Please choose 'u' to upload or 'd' to download."
    exit 1
fi
