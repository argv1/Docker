#!/bin/bash

set -x  # Debugging aktivieren

backup_root="/mnt/media/Backup"
backup_date="$1"
backup_folder="${backup_root}/${backup_date}"

# Überprüfen, ob das Backup-Verzeichnis existiert
if [ ! -d "${backup_folder}" ]; then
    echo "Backup-Verzeichnis ${backup_folder} existiert nicht."
    exit 1
fi

# Alle Unterverzeichnisse durchlaufen
for dir in "${backup_folder}"/*/; do
    if [ -d "$dir" ]; then
        # Finde die .tar.gz-Datei im Unterverzeichnis
        for archive in "${dir}"*.tar.gz; do
            if [ -f "$archive" ]; then
                volume_name=$(basename "$dir")
                echo "Stelle Volume: $volume_name wieder her aus $archive"

                # Volume erstellen, falls es nicht existiert
                docker volume create "$volume_name"
                if [ $? -eq 0 ]; then
                    echo "Volume $volume_name erstellt."
                else
                    echo "Fehler beim Erstellen des Volumes $volume_name."
                fi

                # Wiederherstellen des Volumes
                docker run --rm \
                    -v "$volume_name:/data" \
                    -v "${backup_folder}:/backup" \
                    debian:buster-slim bash -c "tar -xzvf /backup/$(basename "$archive") -C /data"
            else
                echo "Keine .tar.gz-Datei gefunden in $dir"
            fi
        done
    fi
done
