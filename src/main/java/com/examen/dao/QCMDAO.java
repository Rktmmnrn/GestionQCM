package com.examen.dao;

import com.examen.model.QCM;
import com.examen.util.DBConnexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des questions QCM
 */
public class QCMDAO {

    private Connection connection;

    public QCMDAO() {
        this.connection = DBConnexion.getInstance().getConnection();
    }

    /**
     * Crée une nouvelle question QCM
     * NB : num_quest est AUTO_INCREMENT, on ne l'insère pas
     */
    public boolean create(QCM qcm) {
        String sql = "INSERT INTO QCM (question, reponse1, reponse2, reponse3, reponse4, bonne_rep) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, qcm.getQuestion());
            pstmt.setString(2, qcm.getReponse1());
            pstmt.setString(3, qcm.getReponse2());
            pstmt.setString(4, qcm.getReponse3());
            pstmt.setString(5, qcm.getReponse4());
            pstmt.setInt(6, qcm.getBonneRep());

            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                ResultSet keys = pstmt.getGeneratedKeys();
                if (keys.next()) qcm.setNumQuest(keys.getInt(1));
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la création de la question : " + e.getMessage());
            return false;
        }
    }

    /**
     * Récupère toutes les questions QCM
     */
    public List<QCM> findAll() {
        List<QCM> questions = new ArrayList<>();
        String sql = "SELECT * FROM QCM ORDER BY num_quest";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                questions.add(extractQCMFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des questions : " + e.getMessage());
        }
        return questions;
    }

    /**
     * Trouve une question par son ID
     */
    public QCM findById(int numQuest) {
        String sql = "SELECT * FROM QCM WHERE num_quest = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, numQuest);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return extractQCMFromResultSet(rs);
        } catch (SQLException e) {
            System.err.println("Erreur findById QCM : " + e.getMessage());
        }
        return null;
    }

    /**
     * Met à jour une question QCM
     */
    public boolean update(QCM qcm) {
        String sql = "UPDATE QCM SET question = ?, reponse1 = ?, reponse2 = ?, " +
                     "reponse3 = ?, reponse4 = ?, bonne_rep = ? WHERE num_quest = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, qcm.getQuestion());
            pstmt.setString(2, qcm.getReponse1());
            pstmt.setString(3, qcm.getReponse2());
            pstmt.setString(4, qcm.getReponse3());
            pstmt.setString(5, qcm.getReponse4());
            pstmt.setInt(6, qcm.getBonneRep());
            pstmt.setInt(7, qcm.getNumQuest());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la mise à jour de la question : " + e.getMessage());
            return false;
        }
    }

    /**
     * Supprime une question QCM
     */
    public boolean delete(int numQuest) {
        String sql = "DELETE FROM QCM WHERE num_quest = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, numQuest);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la suppression de la question : " + e.getMessage());
            return false;
        }
    }

    /**
     * Récupère 10 questions aléatoires pour un examen
     */
    public List<QCM> get10Random() {
        List<QCM> questions = new ArrayList<>();
        String sql = "SELECT * FROM QCM ORDER BY RAND() LIMIT 10";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                questions.add(extractQCMFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la sélection aléatoire des questions : " + e.getMessage());
        }
        return questions;
    }

    /**
     * Compte le nombre total de questions
     */
    public int count() {
        String sql = "SELECT COUNT(*) FROM QCM";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Erreur count QCM : " + e.getMessage());
        }
        return 0;
    }

    private QCM extractQCMFromResultSet(ResultSet rs) throws SQLException {
        QCM qcm = new QCM();
        qcm.setNumQuest(rs.getInt("num_quest"));
        qcm.setQuestion(rs.getString("question"));
        qcm.setReponse1(rs.getString("reponse1"));
        qcm.setReponse2(rs.getString("reponse2"));
        qcm.setReponse3(rs.getString("reponse3"));
        qcm.setReponse4(rs.getString("reponse4"));
        qcm.setBonneRep(rs.getInt("bonne_rep"));
        return qcm;
    }
}
