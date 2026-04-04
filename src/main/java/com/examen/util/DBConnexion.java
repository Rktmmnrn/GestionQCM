package com.examen.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe utilitaire pour la connexion à la base de données MySQL
 * Pattern Singleton pour garantir une unique instance de connexion
 */
public class DBConnexion {
    
    // Instance unique de la classe (Singleton)
    private static DBConnexion instance;
    
    // Paramètres de connexion à la base de données
    private static final String URL = "jdbc:mysql://localhost:3306/gestion_qcm?useSSL=false&serverTimezone=UTC";
    private static final String USER = "fenohery";
    private static final String PASSWORD = "admin";
    
    // Objet Connection
    private Connection connection;
    
    /**
     * Constructeur privé pour le pattern Singleton
     * Initialise la connexion à la base de données
     */
    private DBConnexion() {
        try {
            // Chargement du driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Établissement de la connexion
            this.connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connexion à la base de données établie avec succès !");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur : Driver MySQL non trouvé !");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Erreur de connexion à la base de données !");
            e.printStackTrace();
        }
    }
    
    /**
     * Méthode statique pour obtenir l'instance unique de DBConnexion
     * @return instance unique de DBConnexion
     */
    public static synchronized DBConnexion getInstance() {
        if (instance == null) {
            instance = new DBConnexion();
        }
        return instance;
    }
    
    /**
     * Récupère l'objet Connection actif
     * @return objet Connection
     */
    public Connection getConnection() {
        try {
            // Vérifie si la connexion est toujours valide
            if (connection == null || connection.isClosed()) {
                reconnect();
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la vérification de la connexion !");
            reconnect();
        }
        return connection;
    }
    
    /**
     * Reconnecte à la base de données en cas de perte de connexion
     */
    private void reconnect() {
        try {
            this.connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Reconnexion réussie !");
        } catch (SQLException e) {
            System.err.println("Échec de la reconnexion !");
            e.printStackTrace();
        }
    }
    
    /**
     * Ferme la connexion à la base de données
     */
    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Connexion fermée avec succès !");
            } catch (SQLException e) {
                System.err.println("Erreur lors de la fermeture de la connexion !");
                e.printStackTrace();
            }
        }
    }
}   