ALTER TABLE sources 
  RENAME COLUMN excerpt TO claim,
  ADD COLUMN excerpt TEXT CHECK (char_length(excerpt) < 512);

ALTER TABLE authors
  ALTER COLUMN author_type_id SET DEFAULT NULL;

ALTER TABLE sources
  ALTER type_id SET DEFAULT NULL,
  ALTER author_id SET DEFAULT NULL,
  ALTER data_source_id SET DEFAULT NULL,
  ALTER status_id SET DEFAULT NULL,
  DROP COLUMN rejection_reason_id;

ALTER TABLE source_subject_matter_map
  ALTER source_id SET DEFAULT NULL,
  ALTER subject_matter_id SET DEFAULT NULL,
  ALTER source_id SET NOT NULL,
  ALTER subject_matter_id SET NOT NULL;

ALTER TABLE notes
  ALTER source_id SET DEFAULT NULL,
  ALTER source_id SET NOT NULL;
