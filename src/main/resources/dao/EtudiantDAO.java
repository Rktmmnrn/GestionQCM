package com.examen.dao;

import com.examen.model.Etudiant;
import com.examen.util.DBConnexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des étudiants
 */
public class EtudiantDAO {
    
    private Connection connection;
    
    public EtudiantDAO() {
        this.connection = DBConnexion.getInstance().getConnection();
    }
    
    /**
     * Crée un nouvel étudiant dans la base de données
     * @param etudiant l'étudiant à créer
     * @return true si création réussie, false sinon
     */
    public boolean create(Etudiant etudiant) {
        String sql = "INSERT INTO etudiants (num_etudiant, nom, prenoms, niveau, adr_email) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, etudiant.getNumEtudiant());
            pstmt.setString(2, etudiant.getNom());
            pstmt.setString(3, etudiant.getPrenoms());
            pstmt.setString(4, etudiant.getNiveau());
            pstmt.setString(5, etudiant.getAdrEmail());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la création de l'étudiant : " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Récupère tous les étudiants
     * @return liste de tous les étudiants
     */
    public List<Etudiant> findAll() {
        List<Etudiant> etudiants = new ArrayList<>();
        String sql = "SELECT * FROM etudiants ORDER BY nom, prenoms";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                etudiants.add(extractEtudiantFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des étudiants : " + e.getMessage());
        }
        return etudiants;
    }
    
    /**
     * Trouve un étudiant par son numéro
     * @param numEtudiant numéro de l'étudiant
     * @return l'étudiant trouvé ou null
     */
    public Etudiant findById(String numEtudiant) {
        String sql = "SELECT * FROM etudiants WHERE num_etudiant = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, numEtudiant);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractEtudiantFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche de l'étudiant : " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Recherche des étudiants par nom (recherche partielle)
     * @param nom nom ou partie du nom à rechercher
     * @return liste des étudiants correspondants
     */
    public List<Etudiant> findByNom(String nom) {
        List<Etudiant> etudiants = new ArrayList<>();
        String sql = "SELECT * FROM etudiants WHERE nom LIKE ? ORDER BY nom, prenoms";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, "%" + nom + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                etudiants.add(extractEtudiantFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche par nom : " + e.getMessage());
        }
        return etudiants;
    }
    
    /**
     * Recherche des étudiants par niveau
     * @param niveau niveau des étudiants
     * @return liste des étudiants du niveau spécifié
     */
    public List<Etudiant> findByNiveau(String niveau) {
        List<Etudiant> etudiants = new ArrayList<>();
        String sql = "SELECT * FROM etudiants WHERE niveau = ? ORDER BY nom, prenoms";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, niveau);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                etudiants.add(extractEtudiantFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche par niveau : " + e.getMessage());
        }
        return etudiants;
    }
    
    /**
     * Met à jour les informations d'un étudiant
     * @param etudiant étudiant avec les nouvelles informations
     * @return true si mise à jour réussie, false sinon
     */
    public boolean update(Etudiant etudiant) {
        String sql = "UPDATE etudiants SET nom = ?, prenoms = ?, niveau = ?, adr_email = ? WHERE num_etudiant = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, etudiant.getNom());
            pstmt.setString(2, etudiant.getPrenoms());
            pstmt.setString(3, etudiant.getNiveau());
            pstmt.setString(4, etudiant.getAdrEmail());
            pstmt.setString(5, etudiant.getNumEtudiant());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la mise à jour de l'étudiant : " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Supprime un étudiant
     * @param numEtudiant numéro de l'étudiant à supprimer
     * @return true si suppression réussie, false sinon
     */
    public boolean delete(String numEtudiant) {
        String sql = "DELETE FROM etudiants WHERE num_etudiant = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, numEtudiant);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la suppression de l'étudiant : " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Extrait un objet Etudiant d'un ResultSet
     */
    private Etudiant extractEtudiantFromResultSet(ResultSet rs) throws SQLException {
        Etudiant etudiant = new Etudiant();
        etudiant.setNumEtudiant(rs.getString("num_etudiant"));
        etudiant.setNom(rs.getString("nom"));
        etudiant.setPrenoms(rs.getString("prenoms"));
        etudiant.setNiveau(rs.getString("niveau"));
        etudiant.setAdrEmail(rs.getString("adr_email"));
        return etudiant;
    }
}