#!/bin/bash

# Run the install_dependencies.sh script
if [ -f ./kasm_dependencies.sh ]; then
  chmod +x kasm_dependencies.sh
  ./kasm_dependencies.sh
else
  echo "kasm_dependencies.sh script not found!"
  exit 1
fi
sleep 2
clear

# Function to display file contents slowly
slow_cat() {
  local filename="$1"
  local delay="$2"

  # Check if the file exists
  if [ ! -f "$filename" ]; then
    echo "File not found!"
    return 1
  fi

  # Display the file contents line by line with a delay
  while IFS= read -r line || [[ -n "$line" ]]; do
    echo "$line"
    sleep "$delay" # Adjust the delay (in seconds) as needed
  done < "$filename"
}

# Function to display the menu
show_menu() {
  echo "Menu"
  echo "1. Install Kasm"
  echo "2. Start Kasm"
  echo "3. Stop Kasm"
  echo "4. Restart Kasm"
  echo "5. Update Kasm"
  echo "6. Uninstall Kasm"
  echo "7. Exit"
  echo ""
  echo -n "Select: "
}

# Main script execution

# Print each line of the ASCII art slowly
ascii_art_file="ascii_launch"  # Store your ASCII art in this file
delay="0.5"  # Adjust the delay (in seconds) as needed

slow_cat "$ascii_art_file" "$delay"

echo ""

# Display the menu and handle user input
while true; do
  show_menu
  read choice
  case $choice in
    1)
      echo "Install Kasm"
      echo "Make sure that docker is installed on all images, otherwise ctrl-c to escape"
      echo "Make sure the inventory file has init_remote_db: false for scaling"
      sleep 20
      ansible-playbook -i inventory install_kasm.yml
      ;;
    2)
      echo "Start Kasm"
      ansible-playbook -i inventory start_kasm.yml
      ;;
    3)
      echo "Stop Kasm"
      ansible-playbook -i inventory stop_kasm.yml
      ;;
    4)
      echo "Restart Kasm"
      ansible-playbook -i inventory restart_kasm.yml
      ;;
    5)
      echo "Update Kasm"
      echo "Please update the inventory file as needed and press Enter to continue..."
      read -r
      ansible-playbook -i inventory install_kasm.yml
      ;;
    6)
      echo "Uninstall Kasm"
      ansible-playbook -i inventory uninstall_kasm.yml
      ;;
    7)
      echo "Exiting..."
      break
      ;;
    *)
      echo "Invalid choice, please try again."
      ;;
  esac
done