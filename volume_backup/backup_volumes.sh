			#!/bin/bash
			
			# Verzeichnis für Backups erstellen (falls nicht vorhanden)
			backup_root="/mnt/media/Backup"
			backup_folder="${backup_root}/$(date +"%Y%m%d")"
			mkdir -p "${backup_folder}"
			
			# Alle Docker-Volumes sichern
			for volume in $(docker volume ls --quiet); do
			    volume_name=$(docker volume inspect --format '{{.Name}}' "$volume")
			    echo "Sichere Volume: $volume_name"
			
			    # Verzeichnis für das aktuelle Volume erstellen
			    volume_backup_folder="${backup_folder}/${volume_name}"
			    mkdir -p "${volume_backup_folder}"
			
			    # Backup erstellen
			    docker run --rm \
			        -v "${volume_backup_folder}:/backup" \
			        -v "$volume:/data:ro" \
			        debian:buster-slim bash -c "cd /data && tar -czvf /backup/${volume_name}_$(date +"%Y%m%d%H%M%S").tar.gz ."
done
