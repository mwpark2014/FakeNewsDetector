CREATE TABLE IF NOT EXISTS author_types (
	author_type_id SMALLSERIAL PRIMARY KEY,
    author_type TEXT CHECK (char_length(author_type) <= 63) NOT NULL
);

CREATE TABLE IF NOT EXISTS authors (
	author_id SERIAL PRIMARY KEY,
    author TEXT CHECK (char_length(author) <= 63) NOT NULL,
    author_type_id SMALLINT REFERENCES author_types NOT NULL
);

CREATE TABLE IF NOT EXISTS types (
	type_id SMALLSERIAL PRIMARY KEY,
    type TEXT CHECK (char_length(type) <= 31) NOT NULL,
    description TEXT CHECK (char_length(description) <= 255)
);

CREATE TABLE IF NOT EXISTS statuses (
	status_id SMALLSERIAL PRIMARY KEY,
    status TEXT CHECK (char_length(status) <= 31) NOT NULL,
    description TEXT CHECK (char_length(description) <= 255)
);

CREATE TABLE IF NOT EXISTS claim_rejection_reasons (
	claim_rejection_reason_id SMALLSERIAL PRIMARY KEY,
    claim_rejection_reason TEXT CHECK (char_length(claim_rejection_reason) < 32) NOT NULL,
    description TEXT CHECK (char_length(description) <= 255)
);

CREATE TABLE IF NOT EXISTS source_rejection_reasons (
	source_rejection_reason_id SMALLSERIAL PRIMARY KEY,
    source_rejection_reason TEXT CHECK (char_length(source_rejection_reason) < 32) NOT NULL,
    description TEXT CHECK (char_length(description) <= 255)
);

CREATE TABLE IF NOT EXISTS subject_matters (
	subject_matter_id SMALLSERIAL PRIMARY KEY,
    subject TEXT CHECK (char_length(subject) <= 63) NOT NULL
);

CREATE TABLE IF NOT EXISTS claim_sources (
	claim_source_id SMALLSERIAL PRIMARY KEY,
    claim_source TEXT CHECK (char_length(claim_source) <= 31) NOT NULL
);

CREATE TABLE IF NOT EXISTS notes (
	note_id SERIAL PRIMARY KEY,
    text TEXT CHECK (char_length(text) <= 255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS claims (
	claim_id SERIAL PRIMARY KEY,
    claim_source_id SMALLINT REFERENCES claim_sources NOT NULL,
    status_id SMALLINT REFERENCES statuses NOT NULL,
    note_id INT REFERENCES notes,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sources (
	source_id SERIAL PRIMARY KEY,
    type_id SMALLINT REFERENCES types NOT NULL,
    author_id INT REFERENCES authors NOT NULL,
    status_id SMALLINT REFERENCES statuses NOT NULL,
    excerpt TEXT CHECK (char_length(excerpt) <= 255) NOT NULL,
    title TEXT CHECK (char_length(title) <= 255),
    metadata TEXT CHECK (char_length(metadata) <= 255),
    domain TEXT CHECK (char_length(domain) <= 127),
    url TEXT CHECK (char_length(url) <= 255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS source_snippets (
	source_snippet_id SERIAL PRIMARY KEY,
    claim_id INT REFERENCES claims NOT NULL,
    source_id INT REFERENCES sources NOT NULL,
    excerpt TEXT CHECK (char_length(excerpt) <= 255) NOT NULL,
    snippet_page TEXT CHECK (char_length(excerpt) < 16) NOT NULL,
    snippet_timestamp TEXT CHECK (char_length(excerpt) < 16) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS source_subject_matter_map (
	source_id INT REFERENCES sources NOT NULL,
    subject_matter_id SMALLINT REFERENCES subject_matters NOT NULL,
    CONSTRAINT source_subject_matter_pkey PRIMARY KEY (claim_id, subject_matter_id)
);

CREATE TABLE IF NOT EXISTS claim_rejection_reason_map (
	claim_id INTEGER REFERENCES claims,
    claim_rejection_reason_id SMALLINT REFERENCES claim_rejection_reasons,
    CONSTRAINT claim_rejection_reason_pkey PRIMARY KEY (source_id, claim_rejection_reason_id)
);

CREATE TABLE IF NOT EXISTS source_rejection_reason_map (
	source_id INTEGER REFERENCES sources,
    source_rejection_reason_id SMALLINT REFERENCES source_rejection_reasons,
    CONSTRAINT source_rejection_reason_pkey PRIMARY KEY (source_id, source_rejection_reason_id)
);

CREATE OR REPLACE FUNCTION update_last_modified_column()   
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified = now();
    RETURN NEW;   
END;
$$ language 'plpgsql';

CREATE TRIGGER update_last_modified_time BEFORE UPDATE ON claims FOR EACH ROW EXECUTE PROCEDURE update_last_modified_column();
CREATE TRIGGER update_last_modified_time BEFORE UPDATE ON sources FOR EACH ROW EXECUTE PROCEDURE update_last_modified_column();
