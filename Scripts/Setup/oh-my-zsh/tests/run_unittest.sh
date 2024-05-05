#!/bin/bash

# Include your utilities script
source ./utils.sh

# Test setup
test_section="zsh.test"
test_file="config.toml"
backup_file="config.unittest.toml"
declare -A test_array

# Helper function to echo test results
function echo_test() {
    if [[ $1 == true ]]; then
        echo "+ $2 ...[OK]"
    else
        echo "+ $2 ...[FAIL]"
    fi
}

# Create test array
test_array[theme]="powerlevel10k/powerlevel10k"
test_array[editor]="vim"
echo_test true "Erzeuge Array test_array"

# Write initial content
echo "+ Schreibe Array nach '$test_section'"
write_config "$test_section" test_array

# Check if file exists
if [[ -f "$test_file" ]]; then
    echo_test true "Prüfe ob Datei $test_file erzeugt wurde"
else
    echo_test false "Prüfe ob Datei $test_file erzeugt wurde"
fi

# Backup the original TOML file for comparison later
cp "$test_file" "$backup_file"
echo_test true "Erzeuge Sicherheitskopie $backup_file"

# Testing unchanged write operation
echo "+ Schreibe unverändertes Array nach '$test_section'"
write_config "$test_section" test_array

# Check file change
if diff "$test_file" "$backup_file" &> /dev/null; then
    echo_test true "Prüfe ob Datei $test_file unverändert blieb"
else
    echo_test false "Prüfe ob Datei $test_file unverändert blieb"
fi

# Modify the array
test_array[theme]="agnoster"
echo "+ Ändere Array test_array[theme] von 'powerlevel10k/powerlevel10k' zu 'agnoster'"
write_config "$test_section" test_array

# Check for update
new_value=$(awk -F' = ' '/theme/ {gsub(/"/, "", $2); print $2}' "$test_file")
if [[ "$new_value" == "agnoster" ]]; then
    echo_test true "Prüfe Änderung in $test_file für theme"
else
    echo_test false "Prüfe Änderung in $test_file für theme"
fi

# Clean up
rm "$test_file" "$backup_file"  # Optional, uncomment to clean up after test

