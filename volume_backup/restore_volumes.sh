#!/bin/bash

# Verzeichnis für Backups
backup_root="/mnt/media/Backup"
backup_date="$1"  # Datum als Argument übergeben
backup_folder="${backup_root}/${backup_date}"

# Überprüfen, ob das Backup-Verzeichnis existiert
if [ ! -d "${backup_folder}" ]; then
    echo "Backup-Verzeichnis ${backup_folder} existiert nicht."
    exit 1
fi

# Alle Tar-Archive im Backup-Verzeichnis wiederherstellen
for archive in "${backup_folder}"/*.tar.gz; do
    if [ -f "$archive" ]; then
        volume_name=$(basename "$archive" | cut -d'_' -f1)
        echo "Stelle Volume: $volume_name wieder her aus $archive"

        # Volume erstellen, falls es nicht existiert
        docker volume create "$volume_name"

        # Wiederherstellen des Volumes
        docker run --rm \
            -v "$volume_name:/data" \
            -v "${backup_folder}:/backup" \
            debian:buster-slim bash -c "tar -xzvf /backup/$(basename "$archive") -C /data"
    fi
done
