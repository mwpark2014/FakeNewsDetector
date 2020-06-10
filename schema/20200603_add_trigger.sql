CREATE OR REPLACE FUNCTION update_last_modified_column()   
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified = now();
    RETURN NEW;   
END;
$$ language 'plpgsql';

CREATE TRIGGER update_last_modified_time BEFORE UPDATE ON sources FOR EACH ROW EXECUTE PROCEDURE update_last_modified_column();
