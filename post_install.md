Le script post_install.sh permet de finaliser l'installation de Proxmox Virtual Environement 7.

Ce script finalise l'installation de PVE7.

Ce script est la version francisé du script de tteckster.

Script original disponible à l'adresse : https://github.com/tteck

Merci à lui pour ce travail magnifique.



 - Désactiver les dépots Enterprise qui sont payant.
 - Ajouter/Corriger les sources pour PVE7 (sources.list) base debian
 - Activer dépot No-Subscription
 - Désactive l'affichage Subscription
 - Mettre à jour Proxmox VE 7
 - Et enfin redémarre la machine


Commande à taper dans la console de Proxmox :
post_install.sh
