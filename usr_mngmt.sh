#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

# Function to display the menu
show_menu() {
    echo "========== User and Group Management Script =========="
    echo "1) Add a User"
    echo "2) Delete a User"
    echo "3) Modify a User"
    echo "4) Create a Group"
    echo "5) Add User to a Group"
    echo "6) Delete a Group"
    echo "7) Backup and Archive a Directory"
    echo "8) Exit"
    echo "======================================================"
}

# Function to add a user
add_user() {
    read -p "Enter username to add: " username
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists."
    else
        read -p "Enter home directory (default: /home/$username): " home_dir
        home_dir=${home_dir:-/home/$username}
        useradd -m -d "$home_dir" "$username" && echo "User '$username' created successfully."
    fi
}

# Function to delete a user
delete_user() {
    read -p "Enter username to delete: " username
    if id "$username" &>/dev/null; then
        userdel -r "$username" && echo "User '$username' deleted successfully."
    else
        echo "User '$username' does not exist."
    fi
}

# Function to modify a user
modify_user() {
    read -p "Enter username to modify: " username
    if id "$username" &>/dev/null; then
        read -p "Enter new home directory (leave empty to skip): " new_home
        read -p "Enter new shell (leave empty to skip): " new_shell
        [ -n "$new_home" ] && usermod -d "$new_home" "$username" && echo "Updated home directory to '$new_home'."
        [ -n "$new_shell" ] && usermod -s "$new_shell" "$username" && echo "Updated shell to '$new_shell'."
    else
        echo "User '$username' does not exist."
    fi
}

# Function to create a group
create_group() {
    read -p "Enter group name to create: " groupname
    if getent group "$groupname" &>/dev/null; then
        echo "Group '$groupname' already exists."
    else
        groupadd "$groupname" && echo "Group '$groupname' created successfully."
    fi
}

# Function to add a user to a group
add_user_to_group() {
    read -p "Enter username: " username
    read -p "Enter group name: " groupname
    if id "$username" &>/dev/null && getent group "$groupname" &>/dev/null; then
        usermod -aG "$groupname" "$username" && echo "User '$username' added to group '$groupname'."
    else
        echo "Invalid username or group name."
    fi
}

# Function to delete a group
delete_group() {
    read -p "Enter group name to delete: " groupname
    if getent group "$groupname" &>/dev/null; then
        groupdel "$groupname" && echo "Group '$groupname' deleted successfully."
    else
        echo "Group '$groupname' does not exist."
    fi
}

# Function to backup and archive a directory
backup_directory() {
    read -p "Enter directory to backup: " dir_to_backup
    if [ -d "$dir_to_backup" ]; then
        timestamp=$(date +%Y%m%d_%H%M%S)
        tar_file="backup_${timestamp}.tar.gz"
        tar -czf "$tar_file" "$dir_to_backup" && echo "Directory backed up to '$tar_file'."
    else
        echo "Directory '$dir_to_backup' does not exist."
    fi
}

# Main loop
while true; do
    show_menu
    read -p "Choose an option: " choice
    case $choice in
        1) add_user ;;
        2) delete_user ;;
        3) modify_user ;;
        4) create_group ;;
        5) add_user_to_group ;;
        6) delete_group ;;
        7) backup_directory ;;
        8) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
    echo "======================================================"
done
