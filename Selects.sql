-- 1)
-- SELECT AVG(Evenement.fraisInscription) AS 'Frais moyens'
--  FROM Evenement INNER JOIN Federation
-- 	ON Evenement.idFederation = Federation.id AND Federation.nom = 'BRITISH GYMNASTICS' 

-- 2)
-- SELECT vgymnaste.id, vgymnaste.nom, vgymnaste.prenom 
-- FROM vgymnaste 
-- INNER JOIN gymnaste_discipline
-- 	ON vgymnaste.id = gymnaste_discipline.idGymnaste
-- INNER JOIN vcoach 
-- 	ON vcoach.id = vgymnaste.idCoach
-- WHERE vcoach.codeDiscipline = gymnaste_discipline.codeDiscipline AND vcoach.idPays = vgymnaste.idPays

-- 3)
-- SELECT vgymnaste.id, vgymnaste.nom, vgymnaste.prenom, 
-- 	   federation.nom AS 'nom de la fédération', 
--        DATE_FORMAT(vgymnaste.dateNaissance, "%d.%m.%Y") AS 'date de naissance'
-- FROM vgymnaste
-- INNER JOIN federation
-- 	ON vgymnaste.idFederation = federation.id
-- INNER JOIN gymnaste_discipline
-- 	ON vgymnaste.id = gymnaste_discipline.idGymnaste
-- WHERE gymnaste_discipline.codeDiscipline = 'GFA'
-- ORDER BY federation.nom, vgymnaste.dateNaissance

-- 4)
-- SELECT DISTINCT vcoach.id, vcoach.nom, vcoach.prenom
-- FROM vcoach
-- INNER JOIN vgymnaste
-- 	ON vgymnaste.idCoach = vcoach.id
-- WHERE (vcoach.dateNaissance BETWEEN '1981-01-01' AND '1996-12-31') AND vcoach.dateNaissance > vgymnaste.dateNaissance

-- 5)
-- SELECT DISTINCT vcoach.id, vcoach.nom, vcoach.prenom
-- FROM vcoach
-- INNER JOIN vgymnaste
-- 	ON vcoach.id = vgymnaste.idCoach
-- INNER JOIN inscription
-- 	ON vgymnaste.id = inscription.idGymnaste
-- GROUP BY vcoach.id
-- HAVING COUNT(DISTINCT inscription.idGymnaste) > 2

-- 6)
-- SELECT vgymnaste.id, vgymnaste.nom, vgymnaste.prenom, MAX(evenement.fraisInscription) - MIN(evenement.fraisInscription) AS 'écart des frais d\'inscription'
-- FROM vgymnaste
-- INNER JOIN inscription
-- 	ON vgymnaste.id = inscription.idGymnaste
-- INNER JOIN evenement
-- 	ON evenement.id = inscription.idEvenement
-- GROUP BY vgymnaste.id
-- HAVING COUNT(*) > 2
-- ORDER BY vgymnaste.nom, vgymnaste.prenom

-- 7)
-- SELECT vgymnaste.id, vgymnaste.nom, vgymnaste.prenom,
--        evenement.nom AS 'évènement', inscription.date AS 'inscription',
--        DATEDIFF(inscription.date, evenement.dateOuverture) AS 'nbJours de retard'
-- FROM vgymnaste
-- INNER JOIN inscription
-- 	ON vgymnaste.id = inscription.idGymnaste
-- INNER JOIN evenement
-- 	ON inscription.idEvenement = evenement.id
-- WHERE inscription.date > evenement.dateOuverture

-- 8)
-- SELECT evenement.nom AS 'évènement', federation.nom 'organisé par'
-- FROM evenement
-- INNER JOIN inscription
-- 	ON inscription.idEvenement = evenement.id
-- INNER JOIN federation
-- 	ON federation.id = evenement.idFederation
-- WHERE evenement.fraisInscription < (SELECT AVG(evenement.fraisInscription) FROM evenement)
-- GROUP BY evenement.nom
-- HAVING COUNT(*) > 3

-- 9)
-- SELECT vcoach.codeDiscipline
-- FROM vcoach
-- GROUP BY vcoach.codeDiscipline
-- HAVING COUNT(*) >= 2
-- UNION
-- SELECT gymnaste_discipline.codeDiscipline
-- FROM gymnaste_discipline
-- GROUP BY gymnaste_discipline.codeDiscipline
-- HAVING COUNT(*) >= 10

-- 10)
-- SELECT vcoach.id, vcoach.nom, vcoach.prenom, SUM(evenement.fraisInscription) AS fraisTotaux
-- FROM vcoach
-- INNER JOIN vgymnaste
-- 	ON vcoach.id = vgymnaste.idCoach
-- INNER JOIN inscription
-- 	ON vgymnaste.id = inscription.idGymnaste
-- INNER JOIN evenement
-- 	ON evenement.id = inscription.idEvenement
-- WHERE TIMESTAMPDIFF(YEAR, vgymnaste.dateNaissance, evenement.dateOuverture) < 16
-- GROUP BY vcoach.id
-- ORDER BY fraisTotaux DESC, vcoach.nom 

-- 11) 
-- SELECT federation.nom AS nom_federation, 
-- 	   (SELECT COUNT(*)
--        FROM federation AS federation2
--        INNER JOIN vgymnaste
-- 			ON vgymnaste.idFederation = federation.id 
--             AND nom_federation = federation2.nom 
--             AND vgymnaste.idPays = federation.idPays) AS nb_adherant_compatriotes,
-- 	   (SELECT COUNT(*)
--        FROM federation AS federation2
--        INNER JOIN vgymnaste
-- 			ON vgymnaste.idFederation = federation.id 
--             AND nom_federation = federation2.nom 
--             AND vgymnaste.idPays <> federation.idPays) AS nb_adherant_etrangers
-- FROM federation
-- GROUP BY federation.nom
-- HAVING COUNT(*) >= 1

-- 12)
-- SELECT vgymnaste.id, vgymnaste.nom, vgymnaste.prenom, COUNT(*) AS nb_evenement_a_venir
-- FROM vgymnaste
-- INNER JOIN inscription
--     ON inscription.idGymnaste = vgymnaste.id
-- INNER JOIN evenement
--     ON inscription.idEvenement = evenement.id
-- WHERE evenement.dateOuverture > CURDATE()
-- GROUP BY vgymnaste.nom 

-- 13) 
-- SELECT vgymnaste.id, vgymnaste.nom, vgymnaste.prenom, IF(vgymnaste.idFederation = evenement.idFederation, 0.8, 1) * 
-- 													  IF(inscription.date > evenement.dateOuverture, 2, 1) * evenement.fraisInscription 
--                                                       AS frais_reels
-- FROM vgymnaste
-- INNER JOIN inscription
-- 	ON vgymnaste.id = inscription.idGymnaste
-- INNER JOIN evenement
-- 	ON evenement.id = inscription.idEvenement
-- WHERE evenement.nom = 'TRA RGI World Cup 2018' 

-- 14)
-- SELECT vgymnaste.id, vgymnaste.nom, vgymnaste.prenom
-- FROM vgymnaste
-- WHERE EXISTS ( SELECT inscription.idGymnaste
-- 			  FROM inscription
--               INNER JOIN evenement
-- 				ON evenement.id = inscription.idEvenement
-- 			  WHERE inscription.idGymnaste = vgymnaste.id
--               GROUP BY inscription.idGymnaste
--               HAVING TIMESTAMPDIFF(YEAR, MIN(evenement.dateOuverture), MAX(evenement.dateOuverture)) >= 5)

-- 15)
-- SELECT DISTINCT vgymnaste.id, vgymnaste.nom, vgymnaste.prenom
-- FROM vgymnaste
-- INNER JOIN inscription
-- 	ON vgymnaste.id = inscription.idGymnaste
-- WHERE NOT EXISTS ( SELECT inscription.idGymnaste
--                    FROM inscription
--                    INNER JOIN evenement
-- 					 ON inscription.idEvenement = evenement.id
-- 				   WHERE vgymnaste.idFederation <> evenement.idFederation AND inscription.idGymnaste = vgymnaste.id)




            

    