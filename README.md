# Surveillance des Positions des Véhicules

Ce projet met en place un serveur Node.js avec Express pour surveiller et gérer les positions en temps réel des véhicules. Il utilise MongoDB avec Mongoose comme base de données, et intègre Socket.IO pour la communication en temps réel.

## Accès au Répertoire du Projet

```bash
cd backend

# Installez les dépendances

installation des dependances du projet Node.js : npm install

# lancez le server:

Pour démarrer le serveur, exécutez la commande: npm start

le serveur sera accessible sur le port 5000

# Etapes pour tester avec Postman:

1.  Ouvrir Postman après l'avoir téléchargé:
    Lancez l'application Postman sur votre ordinateur

2.  Créez une nouvelle requête:
    Cliquez sur le bouton 'New' en haut à gauche et sélectionnez HTTP


   4. Configurez les requêtes:
      - Pour la requête user registration par exemple:
      # Sélectionnez POST comme requête HTTP et entrez l'URL: http://localhost:5000/api/auth/register
      # Ajoutez les entêtes : Dans l'onglet 'Headers', ajoutez en entête 'Content type' avec la valeur 'application/json'
      # Ajoutez le corps de la requête : Allez dans l'onglet 'Body', sélectionnez 'raw' et choisissez 'JSON' dans le menu déroulant
      # Ajoutez un exemple de corps de requête JSON avec les champs requis, par exemple:
          {
            "usermane": "testuser",
            "password": "votre_mot_de_passe",
            "role": "user"
          }
      # Envoyez la requête: 
      Cliquez le bouton 'Send' à l'eXtrême droite
      Vous devriez recevoir une réponse avec le statut 201 Created et un message de succès,
      par exemple :
      {
          "message": "Utilisateur créé avec succès"
      }

       - Pour la requête user authentification par exemple:
      # Sélectionnez POST comme requête HTTP et entrez l'URL: http://localhost:5000/api/auth/login
      # Ajoutez les entêtes : Dans l'onglet 'Headers', ajoutez en entête 'Content type' avec la valeur 'application/json'
      # Ajoutez le corps de la requête : Allez dans l'onglet 'Body', sélectionnez 'raw' et choisissez 'JSON' dans le menu déroulant
      # Ajoutez un exemple de corps de requête JSON avec les champs requis, par exemple:
          {
            "user": "usertest",
            "password": "votre_mot_de_passe"
          }

       - Pour la requête user logout par exemple:
      # Sélectionnez POST comme requête HTTP et entrez l'URL: http://localhost:5000/api/auth/logout
      # Envoyez la requête:
      Cliquez le bouton 'Send' à l'eXtrême droite
      Vous devriez recevoir une réponse avec le statut 200 OK et un message de succès,
      par exemple :
      {
            "message": "Utilisateur déconnecté avec succès"
      }
    
       - Pour la requête get vehicle position par exemple:
      # Sélectionnez requête Socket io et entrez l'URL: ws://localhost:5000
       # aller dans l onglet event et ajouter les evenements position et alert 
      # appuyer sur le boutton connect



# Application desktop de Surveillance des Positions des Véhicules

Cette application desktop vous permet de surveiller en temps réel les positions des véhicules enregistrés sur le serveur backend.

## Installation et Configuration

Pour utiliser cette application, suivez les étapes ci-dessous pour l'installation et la configuration.

### Prérequis

Assurez-vous d'avoir Flutter installé sur votre machine. Consultez la documentation Flutter pour les instructions d'installation : [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

```bash
cd front-end

Installation des Dépendances
Assurez-vous que votre simulateur iOS ou Android est prêt ou connecté.

Installez les dépendances nécessaires en exécutant la commande suivante :

```bash
flutter pub get
Lancement de l'Application
Pour lancer l'application sur votre simulateur ou périphérique connecté, utilisez la commande suivante :

```bash
flutter run
Assurez-vous que votre simulateur ou périphérique est correctement configuré et connecté.

# Utilisation de l'Application
L'application desktop se connecte au serveur backend pour afficher les positions des véhicules enregistrés. Vous devez vous assurer que le serveur backend est en cours d'exécution et accessible.

#Connexion à l'Application
Lors du premier lancement, vous serez invité à vous connecter. Utilisez vos identifiants utilisateur enregistrés sur le serveur backend.

# Affichage des Positions des Véhicules
Une fois connecté, l'application affiche une carte interactive montrant les positions actuelles des véhicules enregistrés. Les données sont mises à jour en temps réel à partir du serveur backend.

# Notifications d'Alertes
L'application envoie des notifications lorsque des alertes sont générées par le serveur backend. Ces alertes peuvent inclure des informations importantes sur les véhicules, telles que des alertes de vitesse excessive, de géolocalisation inconnue, etc.

# Interaction avec les Véhicules
Vous pouvez interagir avec les véhicules en sélectionnant un véhicule sur la carte pour afficher des détails supplémentaires ou effectuer des actions spécifiques.