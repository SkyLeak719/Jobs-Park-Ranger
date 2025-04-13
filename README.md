INSERT INTO jobs (name, label, whitelisted) VALUES
('parkranger', 'Garde Forestier', 1);

INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
('parkranger', 0, 'recruit', 'Recrue', 1200, '{}', '{}'),
('parkranger', 1, 'officer', 'Agent', 1400, '{}', '{}'),
('parkranger', 2, 'sergeant', 'Sergent', 1600, '{}', '{}'),
('parkranger', 3, 'lieutenant', 'Lieutenant', 1800, '{}', '{}'),
('parkranger', 4, 'boss', 'Capitaine', 2000, '{}', '{}');
INSERT INTO addon_account (name, label, shared) VALUES
('society_parkranger', 'Park Ranger', 1);

INSERT INTO addon_account_data (account_name, money, owner) VALUES
('society_parkranger', 0, NULL);

INSERT INTO datastore (name, label, shared) VALUES
('society_parkranger', 'Park Ranger', 1);

INSERT INTO datastore_data (name, owner, data) VALUES
('society_parkranger', NULL, '{}');
