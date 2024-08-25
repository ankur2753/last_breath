CREATE TABLE IF NOT EXISTS stage (
    stage_id INTEGER PRIMARY KEY,
    duration INTEGER NOT NULL,
    workoutType INT NOT NULL
);

CREATE TABLE IF NOT EXISTS workout_set (
    set_id INTEGER PRIMARY KEY,
    workout_id INTEGER NOT NULL,
    no_of_times INTEGER DEFAULT 0,
    FOREIGN KEY (workout_id) REFERENCES workout(workout_id)
);

CREATE TABLE IF NOT EXISTS set_stage_mapping (
    set_id INTEGER NOT NULL,
    stage_id INTEGER NOT NULL,
    PRIMARY KEY (set_id, stage_id),
    FOREIGN KEY (set_id) REFERENCES workout_set(set_id),
    FOREIGN KEY (stage_id) REFERENCES stage(stage_id)
);
CREATE TABLE IF NOT EXISTS workout (
    workout_id INTEGER PRIMARY KEY,
    workout_name TEXT NOT NULL,
);

---- SCHEMA ---
CREATE TABLE Exercises (
    exercise_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);



CREATE TABLE WorkoutSets (
    set_id INT PRIMARY KEY AUTO_INCREMENT,
    exercise_id INT,
    set_number INT NOT NULL,
    FOREIGN KEY (exercise_id) REFERENCES Exercises(exercise_id)
);

CREATE TABLE SetPhases (
    phase_id INT PRIMARY KEY AUTO_INCREMENT,
    set_id INT,
    type VARCHAR(10) CHECK (type IN ('work', 'rest')),
    duration INT NOT NULL,
    FOREIGN KEY (set_id) REFERENCES WorkoutSets(set_id)
);