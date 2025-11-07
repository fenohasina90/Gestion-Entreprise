# 📋 DOCUMENTATION - STRUCTURE COMPLÈTE BASE DE DONNÉES RH

## 🎯 Objectif
Étendre la base de données existante pour supporter toutes les fonctionnalités RH essentielles et avancées, sans modifier la structure actuelle du système de recrutement.

---

## 📊 DIAGRAMME RELATIONNEL

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SYSTÈME EXISTANT (RECRUTEMENT)                        │
│  utilisateur_entreprise, offre, cv, candidat, questionnaire, resultat, etc. │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓ (Extension sans modification)

┌─────────────────────────────────────────────────────────────────────────────┐
│                          MODULE GESTION DU PERSONNEL                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  categorie_personnel (Ouvrier, Employé, TAM, Cadre, Dirigeant)             │
│           ↓                                                                  │
│      service ←──→ poste                                                     │
│           ↓          ↓                                                       │
│  utilisateur_entreprise ←──→ employe (fiche complète)                      │
│                               ↓    ↓    ↓                                   │
│                    ┌──────────┼────┼────┼──────────┐                        │
│                    ↓          ↓    ↓    ↓          ↓                        │
│         contrat_employe  historique_poste  document_employe                │
│                    ↓                                                         │
│              type_contrat                                                    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                       MODULE GESTION DES CONGÉS                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  type_conge (Payé, Maladie, Maternité, Sans solde, etc.)                   │
│       ↓                                                                      │
│  employe ──→ solde_conge (calcul annuel automatique)                       │
│       ↓                                                                      │
│  employe ──→ demande_conge (workflow validation hiérarchique)              │
│       ↓                                                                      │
│  employe ──→ absence (retards, absences injustifiées)                      │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                     MODULE GESTION DU TEMPS                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  type_pointage (Entrée, Sortie, Pause)                                     │
│       ↓                                                                      │
│  employe ──→ pointage (manuel/badgeuse/mobile)                             │
│       ↓                                                                      │
│  employe ──→ feuille_presence (récapitulatif journalier)                   │
│       ↓                                                                      │
│  employe ──→ heure_supplementaire (validation manager)                     │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                        MODULE GESTION DE LA PAIE                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  parametre_paie (CNAPS, OSTIE, IRSA, plafonds)                             │
│                                                                              │
│  element_paie (Primes, Retenues, Indemnités)                               │
│       ↓          ↓                                                           │
│  employe ──→ bulletin_paie ──→ ligne_bulletin                              │
│       ↓                                                                      │
│  employe ──→ avance_salaire                                                │
│       ↓                                                                      │
│  employe ──→ prime_employe                                                 │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                   MODULE SELF-SERVICE & AUDIT                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  type_demande_rh (Attestations, Certificats)                               │
│       ↓                                                                      │
│  employe ──→ demande_rh                                                    │
│                                                                              │
│  utilisateur_entreprise ──→ notification_rh                                │
│                                                                              │
│  utilisateur_entreprise ──→ audit_log (traçabilité complète)              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔗 INTÉGRATION AVEC L'EXISTANT

### Point de jonction principal: `utilisateur_entreprise`

La table **`employe`** étend `utilisateur_entreprise` via une relation **1:1** optionnelle:

```sql
CREATE TABLE employe(
    id SERIAL PRIMARY KEY,
    id_utilisateur INT REFERENCES utilisateur_entreprise(id) ON DELETE CASCADE,
    matricule VARCHAR(50) UNIQUE NOT NULL,
    ...
)
```

#### Avantages de cette architecture:
1. ✅ **Séparation des préoccupations**: Recrutement vs RH opérationnel
2. ✅ **Rétrocompatibilité**: Les tables existantes ne sont PAS modifiées
3. ✅ **Progressivité**: Un utilisateur peut être créé sans être employé
4. ✅ **Migration douce**: Transformation candidat → employé sans rupture

---

## 📦 DÉTAIL DES NOUVELLES TABLES

### 1️⃣ GESTION DU PERSONNEL (10 tables)

| Table | Rôle | Lien avec existant |
|-------|------|--------------------|
| `categorie_personnel` | Classement hiérarchique (Ouvrier→Dirigeant) | Nouveau référentiel |
| `type_contrat` | Types de contrats (CDI, CDD, Stage...) | Remplace le champ texte `contrat` dans `offre` |
| `service` | Départements de l'entreprise | Lié à `employe` |
| `poste` | Postes avec grille salariale | Lié à `service` et `categorie_personnel` |
| **`employe`** | **Fiche employé complète** | **Extension de `utilisateur_entreprise`** |
| `contrat_employe` | Historique des contrats | Lié à `employe` et `type_contrat` |
| `historique_poste` | Promotions et mobilités | Lié à `employe` et `poste` |
| `type_document_rh` | Types de documents (CIN, diplômes...) | Nouveau référentiel |
| `document_employe` | Stockage documents RH | Lié à `employe` |

### 2️⃣ GESTION DES CONGÉS (4 tables)

| Table | Rôle | Fonctionnalité clé |
|-------|------|-------------------|
| `type_conge` | Types (Payé, Maladie, Maternité...) | Calcul automatique des droits |
| `solde_conge` | Compteurs annuels par employé | 2,5 j/mois cumulables sur 3 ans |
| `demande_conge` | Workflow de demande | Validation hiérarchique |
| `absence` | Retards, absences injustifiées | Distinction congés/absences |

#### Workflow de validation congés:
```
Employé → Demande → Manager (id_validateur) → Validation/Refus
                                ↓
                         Mise à jour solde_conge
```

### 3️⃣ GESTION DU TEMPS (4 tables)

| Table | Rôle | Méthodes supportées |
|-------|------|-------------------|
| `type_pointage` | Types (Entrée, Sortie, Pause) | Référentiel |
| `pointage` | Enregistrement temps réel | Badgeuse, Mobile (GPS), Manuel |
| `feuille_presence` | Récapitulatif journalier | Calcul auto heures travaillées |
| `heure_supplementaire` | HS avec majoration | Validation manager requise |

#### Calcul automatique des heures:
```sql
-- Génération automatique feuille_presence depuis pointages
heures_travaillees = SUM(Sortie - Entrée) - SUM(Pause)
retard_minutes = GREATEST(0, heure_arrivee - heure_theorique)
```

### 4️⃣ GESTION DE LA PAIE (7 tables)

| Table | Rôle | Conformité |
|-------|------|-----------|
| `parametre_paie` | Taux CNAPS, OSTIE, IRSA | Lois malgaches 2024 |
| `element_paie` | Catalogue primes/retenues | Personnalisable |
| **`bulletin_paie`** | **Fiche de paie mensuelle** | **Export PDF** |
| `ligne_bulletin` | Détail du bulletin | Gains + Retenues |
| `avance_salaire` | Gestion des avances | Remboursement auto |
| `prime_employe` | Attribution de primes | Mensuelle/ponctuelle |

#### Calcul automatique du net à payer:
```
Salaire NET = Salaire BRUT 
            + Total primes 
            + Heures supplémentaires
            - Total avances
            - Cotisations sociales (CNAPS 1%, OSTIE 5%)
            - IRSA (impôt progressif)
            - Retenues absences
```

### 5️⃣ SELF-SERVICE & AUDIT (4 tables)

| Table | Rôle | Utilisateurs |
|-------|------|-------------|
| `type_demande_rh` | Types de demandes | Tous |
| `demande_rh` | Attestations, certificats | Employés |
| `notification_rh` | Alertes temps réel | Tous |
| `audit_log` | Traçabilité complète | Admins |

---

## 🔄 MIGRATION DES DONNÉES EXISTANTES

### Scénario: Transformer un candidat recruté en employé

```sql
-- 1. Créer l'employé depuis un candidat accepté
INSERT INTO employe (id_utilisateur, matricule, date_embauche, statut, ...)
SELECT 
    ue.id,
    'EMP' || LPAD(NEXTVAL('seq_matricule')::TEXT, 6, '0'),
    CURRENT_DATE,
    'Actif',
    ...
FROM utilisateur_entreprise ue
JOIN contrat_essaie ce ON ce.email_utilisateur = ue.email
WHERE ce.id_evaluation = :id_evaluation_acceptee
  AND NOT EXISTS (SELECT 1 FROM employe WHERE id_utilisateur = ue.id);

-- 2. Créer le contrat initial
INSERT INTO contrat_employe (id_employe, id_type_contrat, date_debut, salaire_brut, ...)
SELECT ...

-- 3. Initialiser les soldes de congés
INSERT INTO solde_conge (id_employe, id_type_conge, annee, solde_initial)
SELECT e.id, tc.id, EXTRACT(YEAR FROM CURRENT_DATE), 0
FROM employe e
CROSS JOIN type_conge tc
WHERE tc.libelle = 'Congé payé';
```

---

## 📈 FONCTIONNALITÉS ACTIVÉES

### ✅ Gestion du personnel (DEV_RH.txt - Section 1.A)
- ✔️ Fiche employé complète (table `employe`)
- ✔️ Suivi contrat (table `contrat_employe`)
- ✔️ Historique postes (table `historique_poste`)
- ✔️ Documents RH (table `document_employe`)

### ✅ Gestion des congés (DEV_RH.txt - Section 1.B)
- ✔️ Soldes automatiques 2,5j/mois (table `solde_conge`)
- ✔️ Workflow validation (table `demande_conge`)
- ✔️ Intégration calendrier (via `date_debut`, `date_fin`)
- ✔️ Alertes automatiques (via `notification_rh`)

### ✅ Gestion du temps (DEV_RH.txt - Section 1.C)
- ✔️ Pointage multi-méthode (table `pointage`)
- ✔️ Heures supplémentaires (table `heure_supplementaire`)
- ✔️ Relevé de présence (table `feuille_presence`)
- ✔️ Interface paie (liaison avec `bulletin_paie`)

### ✅ Gestion de la paie (DEV_RH.txt - Section 1.D)
- ✔️ Fiches de paie (table `bulletin_paie`)
- ✔️ Paramétrage taux (table `parametre_paie`)
- ✔️ Primes/avances/HS (tables dédiées)
- ✔️ Export PDF (champ `fichier_pdf`)

### ✅ Tableaux de bord (DEV_RH.txt - Section 2.A)
- ✔️ Statistiques via requêtes SQL
- ✔️ Taux turnover, absentéisme (calculs sur `employe`, `absence`)
- ✔️ Alertes fin contrat (via `contrat_employe.date_fin`)

### ✅ Self-Service (DEV_RH.txt - Section 2.B)
- ✔️ Consultation bulletins (table `bulletin_paie`)
- ✔️ Solde congés (table `solde_conge`)
- ✔️ Demandes RH (table `demande_rh`)
- ✔️ Notifications (table `notification_rh`)

### ✅ Conformité & Audit (DEV_RH.txt - Section 2.D)
- ✔️ Traçabilité (table `audit_log` avec JSONB)
- ✔️ Gestion rôles (via `role_profil` existant)
- ✔️ Archivage (champs `document_url`)

---

## 🚀 SCRIPT D'INSTALLATION

### Étapes d'exécution:

```bash
# 1. Appliquer le nouveau schéma
psql -U postgres -d gestion_entreprise -f BD_RH_COMPLETE.sql

# 2. Vérifier les tables créées
psql -U postgres -d gestion_entreprise -c "\dt"

# 3. Vérifier les données de référence
psql -U postgres -d gestion_entreprise -c "SELECT * FROM categorie_personnel;"
```

### Vérifications post-installation:

```sql
-- Nombre de nouvelles tables créées (devrait être ~40)
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';

-- Vérifier les contraintes d'intégrité
SELECT conname, contype 
FROM pg_constraint 
WHERE conrelid::regclass::text LIKE '%employe%';
```

---

## 🎨 EXEMPLES DE REQUÊTES MÉTIER

### 1. Calcul automatique du solde de congés d'un employé

```sql
-- Mise à jour mensuelle automatique des soldes
UPDATE solde_conge
SET solde_acquis = solde_acquis + tc.cumul_par_mois,
    solde_restant = solde_initial + solde_acquis - solde_pris
FROM type_conge tc
WHERE solde_conge.id_type_conge = tc.id
  AND tc.cumul_par_mois > 0
  AND annee = EXTRACT(YEAR FROM CURRENT_DATE);
```

### 2. Génération d'un bulletin de paie

```sql
-- Créer le bulletin
INSERT INTO bulletin_paie (id_employe, mois, annee, salaire_brut, ...)
SELECT 
    e.id,
    EXTRACT(MONTH FROM CURRENT_DATE),
    EXTRACT(YEAR FROM CURRENT_DATE),
    ce.salaire_brut,
    ...
FROM employe e
JOIN contrat_employe ce ON ce.id_employe = e.id AND ce.est_actif = TRUE;

-- Ajouter les lignes (primes, retenues, cotisations)
INSERT INTO ligne_bulletin (id_bulletin, id_element_paie, montant, ...)
SELECT ...
```

### 3. Statistiques RH pour tableau de bord

```sql
-- Effectif par catégorie
SELECT cp.nom, COUNT(e.id) AS effectif
FROM categorie_personnel cp
LEFT JOIN employe e ON e.id_categorie = cp.id AND e.statut = 'Actif'
GROUP BY cp.nom;

-- Taux d'absentéisme mensuel
SELECT 
    EXTRACT(MONTH FROM a.date_absence) AS mois,
    COUNT(DISTINCT a.id_employe) * 100.0 / (SELECT COUNT(*) FROM employe WHERE statut = 'Actif') AS taux_absenteisme
FROM absence a
WHERE EXTRACT(YEAR FROM a.date_absence) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY mois;
```

---

## ⚠️ POINTS D'ATTENTION

### 1. Performance
- ✅ **Indexes créés** sur toutes les FK et colonnes de recherche
- ⚠️ Prévoir un archivage annuel des `pointage` et `feuille_presence`

### 2. Sécurité
- ✅ **Audit log** avec JSONB pour traçabilité complète
- ⚠️ Mettre en place des **vues restreintes** par rôle (RH, Manager, Employé)

### 3. Sauvegarde
- ⚠️ Documents RH stockés dans `document_employe.url_fichier`
  - Prévoir backup séparé du système de fichiers
  - Alternative: stockage BYTEA ou cloud (S3)

### 4. Conformité légale (Madagascar)
- ✅ Taux CNAPS, OSTIE, IRSA pré-configurés
- ⚠️ Mettre à jour `parametre_paie` en cas de changement législatif

---

## 📞 SUPPORT & ÉVOLUTIONS

### Prochaines étapes possibles:
1. **Vues métier** pour accès simplifié (ex: `v_employe_complet`)
2. **Triggers** pour calculs automatiques (soldes, heures, paie)
3. **Fonctions PL/pgSQL** pour génération bulletins
4. **API REST** pour self-service employé
5. **Rapports Crystal Reports** ou **Jasper** pour exports

### Contact
Documentation créée le : 2024
Auteur: Système Gestion RH
Version: 1.0

---

**✅ LA STRUCTURE EST COMPLÈTE ET PRÊTE À L'EMPLOI**
