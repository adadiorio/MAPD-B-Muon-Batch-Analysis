
PASSWORD="----"

cd /usr/local/spark || { echo "Directory /usr/local/spark non trovata"; exit 1; }

echo "$PASSWORD" | sudo -S rm -rf logs/* || { echo "Errore nella rimozione dei file in /usr/local/spark/logs"; exit 1; }

echo "$PASSWORD" | sudo -S rm -rf work/* || { echo "Errore nella rimozione dei file in /usr/local/spark/work"; exit 1; }

for slave in slave-1 slave-2; do
    echo "Pulizia su $slave"
    ssh "$slave" << EOF
        echo "$PASSWORD" | sudo -S rm -rf /usr/local/spark/logs/*
        echo "$PASSWORD" | sudo -S rm -rf /usr/local/spark/work/*
        echo "$PASSWORD" | sudo -S rm -rf /tmp/*
        echo "$PASSWORD" | sudo -S rm -rf /var/tmp/*
        echo "$PASSWORD" | sudo -S rm -rf /var/cache/*
        echo "$PASSWORD" | sudo -S apt-get clean
        echo "$PASSWORD" | sudo -S apt-get autoremove -y
EOF
done

cd /usr/local/spark || { echo "Directory /usr/local/spark non trovata"; exit 1; }

echo "$PASSWORD" | sudo -S apt-get clean || { echo "Errore nella pulizia della cache di sistema"; exit 1; }
echo "$PASSWORD" | sudo -S apt-get autoremove -y || { echo "Errore nella rimozione dei pacchetti non necessari"; exit 1; }

echo "Now starting the cluster"

./sbin/start-all.sh || { echo "Errore nell'avvio di Spark"; exit 1; }


cd /usr/local/spark/Project 

echo "Script completed succesfully, cluster has been started"

