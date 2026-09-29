CREATE TABLE IF NOT EXISTS player_pcs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    pc_id INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES players(id)
);

CREATE TABLE IF NOT EXISTS scam_attempts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    scam_type VARCHAR(50) NOT NULL,
    success BOOLEAN NOT NULL,
    reward INT,
    FOREIGN KEY (player_id) REFERENCES players(id)
);