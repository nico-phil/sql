--Converting text to tsvector data
SELECT to_tsvector('english', 'I am walking across the sitting room to sit with you.');

--Converting search terms to tsquery data
SELECT to_tsquery('english', 'walking & sitting');


--Querying a tsvector type with a tsquery, @@ - match oprerator
SELECT to_tsvector('english', 'I am walking across the sitting room') @@
       to_tsquery('english', 'walking & sitting');

SELECT to_tsvector('english', 'I am walking across the sitting room') @@ 
       to_tsquery('english', 'walking & running');


CREATE TABLE president_speeches (
    president text NOT NULL,
    title text NOT NULL,
    speech_date date NOT NULL,
    speech_text text NOT NULL,
    search_speech_text tsvector,
    CONSTRAINT speech_key PRIMARY KEY (president, speech_date)
);

\COPY president_speeches (president, title, speech_date, speech_text)
FROM 'C:\YourDirectory\president_speeches.csv'
WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@');


--Converting speeches to tsvector in the search_speech_text column
UPDATE president_speeches
SET search_speech_text = to_tsvector('english', speech_text);


-- Listing 14-20: Creating a GIN index for text search
CREATE INDEX search_idx ON president_speeches USING gin(search_speech_text);


-- Listing 14-21: Finding speeches containing the word "Vietnam"
SELECT president, speech_date
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'Vietnam')
ORDER BY speech_date;

-- Displaying search results with ts_headline()
--
SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('english', 'tax'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'tax')
ORDER BY speech_date;


-- Finding speeches with the word "transportation" but not "roads"

SELECT president,
       speech_date,
       ts_headline(speech_text,
                   to_tsquery('english', 'transportation & !roads'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@
      to_tsquery('english', 'transportation & !roads')
ORDER BY speech_date;


-- Finding speeches where "defense" follows "military"
SELECT president,
       speech_date,
       ts_headline(speech_text, 
                   to_tsquery('english', 'military <-> defense'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ 
      to_tsquery('english', 'military <-> defense')
ORDER BY speech_date;



-- Example with a distance of 2:
SELECT president,
       speech_date,
       ts_headline(speech_text, 
                   to_tsquery('english', 'military <2> defense'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=2')
FROM president_speeches
WHERE search_speech_text @@ 
      to_tsquery('english', 'military <2> defense')
ORDER BY speech_date;



-- Scoring relevance with ts_rank()
SELECT president,
       speech_date,
       ts_rank(search_speech_text,
               to_tsquery('english', 'war & security & threat & enemy'))
               AS score
FROM president_speeches
WHERE search_speech_text @@ 
      to_tsquery('english', 'war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5;


-- Normalizing ts_rank() by speech length

SELECT president,
       speech_date,
       ts_rank(search_speech_text,
               to_tsquery('english', 'war & security & threat & enemy'), 2)::numeric 
               AS score
FROM president_speeches
WHERE search_speech_text @@ 
      to_tsquery('english', 'war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5;


