
CREATE TABLE IF NOT EXISTS author_types (
	author_type_id SMALLSERIAL PRIMARY KEY,
    author_type TEXT CHECK (char_length(author_type) <= 63) NOT NULL
);

CREATE TABLE IF NOT EXISTS authors (
	author_id SERIAL PRIMARY KEY,
    author TEXT CHECK (char_length(author) <= 63) NOT NULL,
    author_type_id SMALLSERIAL REFERENCES author_types NOT NULL
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

CREATE TABLE IF NOT EXISTS rejection_reasons (
	rejection_reason_id SMALLSERIAL PRIMARY KEY,
    rejection_reason TEXT CHECK (char_length(rejection_reason) <= 31) NOT NULL,
    description TEXT CHECK (char_length(description) <= 255)
);

CREATE TABLE IF NOT EXISTS subject_matters (
	subject_matter_id SMALLSERIAL PRIMARY KEY,
    subject TEXT CHECK (char_length(subject) <= 63) NOT NULL
);

CREATE TABLE IF NOT EXISTS data_sources (
	data_source_id SMALLSERIAL PRIMARY KEY,
    data_source TEXT CHECK (char_length(data_source) <= 31) NOT NULL
);

CREATE TABLE IF NOT EXISTS sources (
	source_id SERIAL PRIMARY KEY,
    type_id SMALLSERIAL REFERENCES types NOT NULL,
    author_id SERIAL REFERENCES authors NOT NULL,
    data_source_id SMALLSERIAL REFERENCES data_sources NOT NULL,
    status_id SMALLSERIAL REFERENCES statuses NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    excerpt TEXT CHECK (char_length(excerpt) <= 255) NOT NULL,
    title TEXT CHECK (char_length(title) <= 255),
    metadata TEXT CHECK (char_length(metadata) <= 255),
    domain TEXT CHECK (char_length(domain) <= 127),
    url TEXT CHECK (char_length(url) <= 255)
);

CREATE TABLE IF NOT EXISTS source_subject_matter_map (
	source_id SERIAL REFERENCES sources,
    subject_matter_id SMALLSERIAL REFERENCES subject_matters,
    CONSTRAINT source_subject_matter_pkey PRIMARY KEY (source_id, subject_matter_id)
);

CREATE TABLE IF NOT EXISTS notes (
	note_id SERIAL PRIMARY KEY,
    source_id SERIAL REFERENCES sources,
    text TEXT CHECK (char_length(text) <= 255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
