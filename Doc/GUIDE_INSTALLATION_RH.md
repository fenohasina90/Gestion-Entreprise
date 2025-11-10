# 🚀 GUIDE D'INSTALLATION - SYSTÈME RH COMPLET

## 📋 Table des matières
1. [Prérequis](#prérequis)
2. [Installation étape par étape](#installation-étape-par-étape)
3. [Vérifications](#vérifications)
4. [Premiers pas](#premiers-pas)
5. [Dépannage](#dépannage)

---

## ✅ Prérequis

### Logiciels requis
- PostgreSQL 12 ou supérieur
- psql (client PostgreSQL)
- Accès administrateur à la base de données

### Base existante
- ✔️ Base `gestion_entreprise` déjà créée
- ✔️ Tables de recrutement déjà en place (utilisateur_entreprise, offre, cv, etc.)

---

## 📦 Installation étape par étape

### Étape 1: Vérifier la structure existante

```bash
# Connexion à la base
psql -U postgres -d gestion_entreprise

# Lister les tables existantes
\dt

# Compter les tables
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';

# Sortir de psql
\q
```

**✅ Résultat attendu:** ~17-20 tables existantes (système de recrutement)

---

### Étape 2: Appliquer la structure RH complète

```bash
# Exécuter le script principal
psql -U postgres -d gestion_entreprise -f src/main/resources/sql/BD_RH_COMPLETE.sql

# Vérifier l'exécution
echo $?
# Résultat attendu: 0 (succès)
```

**✅ Ce script crée:**
- 40 nouvelles tables RH
- Données de référence (catégories, types de contrats, congés, etc.)
- Index pour optimisation
- Contraintes d'intégrité

**⏱️ Durée:** ~10-15 secondes

---

### Étape 3: Ajouter les vues et automatisations

```bash
# Exécuter le script des vues et triggers
psql -U postgres -d gestion_entreprise -f src/main/resources/sql/VUES_ET_TRIGGERS_RH.sql
```

**✅ Ce script crée:**
- 8 vues métier (v_employe_complet, v_soldes_conges_actuels, etc.)
- 6 triggers automatiques (calculs, notifications, audit)
- 4 fonctions utilitaires

**⏱️ Durée:** ~5 secondes

---

### Étape 4: Installer les fonctions de migration

```bash
# Exécuter le script de migration
psql -U postgres -d gestion_entreprise -f src/main/resources/sql/MIGRATION_CANDIDAT_VERS_EMPLOYE.sql
```

**✅ Ce script crée:**
- Fonction `migrate_candidat_to_employe()` pour migration unitaire
- Fonction `migrate_candidats_valides_batch()` pour migration en masse
- Fonction `rollback_employe()` pour annulation

**⏱️ Durée:** ~3 secondes

---

## 🔍 Vérifications

### Vérification 1: Tables créées

```sql
-- Connexion
psql -U postgres -d gestion_entreprise

-- Compter toutes les tables
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
-- Résultat attendu: ~60 tables
```

### Vérification 2: Données de référence

```sql
-- Catégories de personnel
SELECT * FROM categorie_personnel ORDER BY niveau_hierarchique;
-- Résultat attendu: 5 lignes (Ouvrier à Dirigeant)

-- Types de contrats
SELECT * FROM type_contrat;
-- Résultat attendu: 6 lignes (CDI, CDD, Stage, etc.)

-- Types de congés
SELECT * FROM type_conge;
-- Résultat attendu: 8 lignes (Payé, Maladie, Maternité, etc.)

-- Paramètres de paie
SELECT * FROM parametre_paie;
-- Résultat attendu: 5 lignes (CNAPS, OSTIE, IRSA, etc.)
```

### Vérification 3: Vues créées

```sql
-- Lister les vues
SELECT table_name FROM information_schema.views 
WHERE table_schema = 'public' AND table_name LIKE 'v_%'
ORDER BY table_name;
-- Résultat attendu: 8 vues
```

### Vérification 4: Triggers créés

```sql
-- Lister les triggers
SELECT trigger_name, event_object_table 
FROM information_schema.triggers
WHERE trigger_schema = 'public' AND trigger_name LIKE 'trg_%'
ORDER BY event_object_table;
-- Résultat attendu: 6 triggers
```

### Vérification 5: Fonctions créées

```sql
-- Lister les fonctions personnalisées
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_type = 'FUNCTION'
  AND routine_name IN (
    'migrate_candidat_to_employe',
    'calculate_monthly_conge_acquisition',
    'generate_feuille_presence',
    'notify_expiring_contracts'
  );
-- Résultat attendu: 4+ fonctions
```

---

## 🎯 Premiers pas

### 1️⃣ Créer votre premier service

```sql
INSERT INTO service (nom, description) 
VALUES ('Direction Générale', 'Direction de l''entreprise')
RETURNING id, nom;
```

### 2️⃣ Créer votre premier poste

```sql
INSERT INTO poste (titre, description, id_service, id_categorie, salaire_min, salaire_max)
SELECT 
    'Directeur des Ressources Humaines',
    'Responsable de la gestion du personnel',
    s.id,
    cp.id,
    5000000,
    8000000
FROM service s
CROSS JOIN categorie_personnel cp
WHERE s.nom = 'Direction Générale'
  AND cp.nom = 'Dirigeant'
RETURNING id, titre;
```

### 3️⃣ Transformer un utilisateur RH existant en employé

```sql
-- Créer un employé depuis un utilisateur_entreprise existant
INSERT INTO employe (
    id_utilisateur,
    matricule,
    date_embauche,
    id_service,
    id_poste,
    id_categorie,
    statut
)
SELECT 
    ue.id,
    'EMP000001',
    '2024-01-01',
    (SELECT id FROM service WHERE nom = 'Direction Générale'),
    (SELECT id FROM poste WHERE titre = 'Directeur des Ressources Humaines'),
    (SELECT id FROM categorie_personnel WHERE nom = 'Dirigeant'),
    'Actif'
FROM utilisateur_entreprise ue
WHERE ue.est_rh = TRUE
LIMIT 1
RETURNING id, matricule;
```

### 4️⃣ Créer le contrat de cet employé

```sql
-- Supposons que l'employé créé a l'ID 1
INSERT INTO contrat_employe (
    id_employe,
    id_type_contrat,
    date_debut,
    salaire_brut,
    est_actif
)
VALUES (
    1,  -- ID de l'employé créé ci-dessus
    (SELECT id FROM type_contrat WHERE libelle = 'CDI'),
    '2024-01-01',
    6500000,
    TRUE
)
RETURNING id;
```

### 5️⃣ Vérifier la fiche complète

```sql
-- Vue complète de l'employé
SELECT * FROM v_employe_complet WHERE matricule = 'EMP000001';

-- Vérifier ses soldes de congés (créés automatiquement par trigger)
SELECT * FROM v_soldes_conges_actuels WHERE matricule = 'EMP000001';
```

---

## 📊 Cas d'usage avancés

### Migrer un candidat recruté

```sql
-- Supposons qu'un candidat a été validé (id_evaluation = 5)
-- Créer les services/postes nécessaires d'abord, puis:

SELECT * FROM migrate_candidat_to_employe(
    p_id_evaluation := 5,
    p_id_service := 1,
    p_id_poste := 2,
    p_id_categorie := 3,  -- TAM
    p_id_type_contrat := 1,  -- CDI
    p_salaire_brut := 1800000.00,
    p_date_embauche := CURRENT_DATE,
    p_duree_periode_essai := 90
);
```

### Créer une demande de congé

```sql
-- L'employé ID 1 demande un congé
INSERT INTO demande_conge (
    id_employe,
    id_type_conge,
    date_debut,
    date_fin,
    motif,
    statut
)
VALUES (
    1,
    (SELECT id FROM type_conge WHERE libelle = 'Congé payé'),
    '2024-12-20',
    '2024-12-27',
    'Congés de fin d''année',
    'En attente'
)
RETURNING id;
```

### Valider une demande de congé

```sql
-- Le manager valide la demande ID 1
UPDATE demande_conge
SET statut = 'Validée',
    id_validateur = 1,  -- ID du manager
    date_validation = CURRENT_TIMESTAMP,
    commentaire_validation = 'Approuvé'
WHERE id = 1;

-- Le trigger met automatiquement à jour le solde de congés
-- et envoie une notification à l'employé
```

### Enregistrer un pointage

```sql
-- Entrée du matin
INSERT INTO pointage (id_employe, date_pointage, heure_pointage, id_type_pointage, methode)
VALUES (
    1,
    CURRENT_DATE,
    '08:15:00',
    (SELECT id FROM type_pointage WHERE libelle = 'Entrée'),
    'Badgeuse'
);

-- Sortie du soir
INSERT INTO pointage (id_employe, date_pointage, heure_pointage, id_type_pointage, methode)
VALUES (
    1,
    CURRENT_DATE,
    '17:30:00',
    (SELECT id FROM type_pointage WHERE libelle = 'Sortie'),
    'Badgeuse'
);

-- Générer la feuille de présence
SELECT generate_feuille_presence(CURRENT_DATE);

-- Voir le résultat
SELECT * FROM v_presences_aujourdhui;
```

### Générer un bulletin de paie

```sql
-- Créer le bulletin pour l'employé ID 1 pour le mois en cours
INSERT INTO bulletin_paie (
    id_employe,
    mois,
    annee,
    salaire_brut,
    jours_travailles,
    statut
)
VALUES (
    1,
    EXTRACT(MONTH FROM CURRENT_DATE),
    EXTRACT(YEAR FROM CURRENT_DATE),
    6500000,
    22,
    'Brouillon'
);

-- Ajouter une prime
INSERT INTO ligne_bulletin (id_bulletin, id_element_paie, montant, type_ligne)
VALUES (
    (SELECT id FROM bulletin_paie WHERE id_employe = 1 AND mois = EXTRACT(MONTH FROM CURRENT_DATE)),
    (SELECT id FROM element_paie WHERE code = 'PRIME_TRANSPORT'),
    150000,
    'Gain'
);

-- Calculer les cotisations (exemple simplifié)
UPDATE bulletin_paie
SET cotisation_cnaps = salaire_brut * 0.01,
    cotisation_ostie = salaire_brut * 0.05,
    impot_irsa = (salaire_brut - (salaire_brut * 0.06)) * 0.20,
    salaire_net = salaire_brut + total_primes - (salaire_brut * 0.01) - (salaire_brut * 0.05) - ((salaire_brut - (salaire_brut * 0.06)) * 0.20)
WHERE id_employe = 1 
  AND mois = EXTRACT(MONTH FROM CURRENT_DATE)
  AND annee = EXTRACT(YEAR FROM CURRENT_DATE);
```

---

## 🔄 Maintenance mensuelle

### Script à exécuter le 1er de chaque mois

```sql
-- 1. Calculer l'acquisition mensuelle de congés (2,5 jours)
SELECT calculate_monthly_conge_acquisition();

-- 2. Notifier les contrats qui expirent dans 30 jours
SELECT notify_expiring_contracts();

-- 3. Vérifier les congés non pris
SELECT * FROM v_alertes_rh WHERE type_alerte = 'Congés non pris';
```

### Script à exécuter quotidiennement en fin de journée

```sql
-- Générer les feuilles de présence depuis les pointages
SELECT generate_feuille_presence(CURRENT_DATE);

-- Vérifier les absences
SELECT * FROM v_presences_aujourdhui 
WHERE statut = 'Absent' OR retard_minutes > 15;
```

---

## ⚠️ Dépannage

### Problème: Erreur lors de l'insertion d'un employé

**Symptôme:** `ERROR: null value in column "matricule"`

**Solution:**
```sql
-- Vérifier que la séquence existe
SELECT last_value FROM employe_id_seq;

-- Si erreur, créer la séquence
CREATE SEQUENCE IF NOT EXISTS employe_id_seq START 1;
```

### Problème: Trigger ne se déclenche pas

**Symptôme:** Soldes de congés non créés automatiquement

**Solution:**
```sql
-- Vérifier que le trigger existe
SELECT * FROM information_schema.triggers 
WHERE trigger_name = 'trg_create_solde_conges';

-- Si absent, recréer:
-- Relancer VUES_ET_TRIGGERS_RH.sql
```

### Problème: Erreur de FK lors de la création d'un employé

**Symptôme:** `ERROR: insert or update on table "employe" violates foreign key constraint`

**Solution:**
```sql
-- Vérifier que les données de référence existent
SELECT * FROM categorie_personnel;
SELECT * FROM service;
SELECT * FROM poste;

-- Si vides, relancer BD_RH_COMPLETE.sql section 8
```

### Problème: Calcul de paie incorrect

**Symptôme:** Salaire net négatif ou incohérent

**Solution:**
```sql
-- Vérifier les paramètres de paie
SELECT * FROM parametre_paie WHERE date_fin IS NULL OR date_fin > CURRENT_DATE;

-- Vérifier les taux
-- CNAPS employé: 1%
-- OSTIE: 5%
-- IRSA: ~20% (progressif)
```

---

## 📚 Documentation complémentaire

### Fichiers créés

| Fichier | Description |
|---------|-------------|
| `BD_RH_COMPLETE.sql` | Structure complète (tables, index, données) |
| `VUES_ET_TRIGGERS_RH.sql` | Vues métier et automatisations |
| `MIGRATION_CANDIDAT_VERS_EMPLOYE.sql` | Fonctions de migration |
| `EXPLICATION_STRUCTURE_RH.md` | Documentation technique détaillée |
| `GUIDE_INSTALLATION_RH.md` | Ce fichier |

### Ordre de lecture recommandé

1. ✅ **GUIDE_INSTALLATION_RH.md** (vous êtes ici) - Démarrage rapide
2. 📖 **EXPLICATION_STRUCTURE_RH.md** - Comprendre l'architecture
3. 🔧 **BD_RH_COMPLETE.sql** - Consulter la structure
4. ⚙️ **VUES_ET_TRIGGERS_RH.sql** - Comprendre les automatisations
5. 🔄 **MIGRATION_CANDIDAT_VERS_EMPLOYE.sql** - Migration avancée

---

## 🎓 Formation et support

### Compétences requises pour l'administrateur

- ✅ SQL basique (SELECT, INSERT, UPDATE)
- ✅ Compréhension des relations (FK, JOIN)
- ⚠️ Avancé: Triggers et fonctions PL/pgSQL (optionnel)

### Formation utilisateurs

**RH/Administrateurs:**
- Création et gestion des employés
- Validation des demandes (congés, demandes RH)
- Génération des bulletins de paie
- Consultation des tableaux de bord

**Managers:**
- Consultation de l'équipe
- Validation des congés et absences
- Suivi des présences

**Employés:**
- Consultation du profil
- Demandes de congés
- Consultation des bulletins de paie
- Demandes RH (attestations)

---

## ✅ Checklist finale

Avant de passer en production:

- [ ] Toutes les tables créées (vérification 1)
- [ ] Données de référence présentes (vérification 2)
- [ ] Vues accessibles (vérification 3)
- [ ] Triggers actifs (vérification 4)
- [ ] Fonctions testées (vérification 5)
- [ ] Au moins 1 employé créé avec succès
- [ ] Test de demande de congé effectué
- [ ] Test de pointage effectué
- [ ] Test de génération de bulletin effectué
- [ ] Backup de la base effectué

---

## 🚀 Conclusion

Votre système RH est maintenant opérationnel! Vous pouvez:
- ✅ Gérer les fiches employés complètes
- ✅ Suivre les contrats et carrières
- ✅ Automatiser la gestion des congés
- ✅ Enregistrer les présences
- ✅ Générer les bulletins de paie
- ✅ Avoir une traçabilité complète

**Prochaines étapes recommandées:**
1. Créer vos services et postes
2. Migrer vos employés existants
3. Former les utilisateurs
4. Mettre en place les sauvegardes automatiques
5. Développer l'interface utilisateur (web/desktop)

**Support:** Consultez `EXPLICATION_STRUCTURE_RH.md` pour la documentation technique complète.

---

*Guide créé le: 2024*  
*Version: 1.0*  
*Système: PostgreSQL 12+*
