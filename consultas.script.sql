--1. Listar las pistas (tabla Track) con precio mayor o igual a 1€
SELECT * FROM dbo.Track
WHERE UnitPrice >= 1;

--2. Listar las pistas de más de 4 minutos de duración
SELECT * FROM dbo.Track
WHERE Milliseconds > 240000;

--3. Listar las pistas que tengan entre 2 y 3 minutos de duración
SELECT * FROM dbo.Track
WHERE Milliseconds BETWEEN 120000 AND 180000;

--4. Listar las pistas que uno de sus compositores (columna Composer) sea Mercury
SELECT * FROM dbo.Track
WHERE Composer LIKE '%Mercury%';

--5. Calcular la media de duración de las pistas (Track) de la plataforma
SELECT AVG(Milliseconds) AS MediaDuration 
FROM dbo.Track;

--6. Listar los clientes (tabla Customer) de USA, Canada y Brazil
SELECT * FROM dbo.Customer
WHERE Country IN ('USA', 'Canada', 'Brazil')

--7. Listar todas las pistas del artista 'Queen' (Artist.Name = 'Queen')
SELECT Track.* FROM dbo.Track
JOIN dbo.Album ON Track.AlbumId = Album.AlbumId
JOIN dbo.Artist ON Album.ArtistId = Artist.ArtistId
WHERE Artist.Name = 'Queen';

--8. Listar las pistas del artista 'Queen' en las que haya participado como compositor David Bowie
SELECT Track.* FROM dbo.Track
JOIN dbo.Album ON Track.AlbumId = Album.AlbumId
JOIN dbo.Artist ON Album.ArtistId = Artist.ArtistId
WHERE Artist.Name = 'Queen' AND Composer LIKE '%David Bowie%';

--9. Listar las pistas de la playlist 'Heavy Metal Classic'
SELECT Track.* FROM dbo.Track
JOIN dbo.PlaylistTrack ON Track.TrackId = PlaylistTrack.TrackId
JOIN dbo.Playlist ON PlaylistTrack.PlaylistId = Playlist.PlaylistId
WHERE Playlist.Name = 'Heavy Metal Classic';

--10. Listar las playlist junto con el número de pistas que contienen
SELECT Playlist.Name, COUNT(PlaylistTrack.TrackId) AS NumeroDePistas FROM dbo.Playlist
JOIN dbo.PlaylistTrack ON Playlist.PlaylistId = PlaylistTrack.PlaylistId GROUP BY Playlist.Name;

--11. Listar las playlist (sin repetir ninguna) que tienen alguna canción de AC/DC
SELECT DISTINCT Playlist.Name FROM dbo.Playlist
JOIN dbo.PlaylistTrack ON Playlist.PlaylistId = PlaylistTrack.PlaylistId
JOIN dbo.Track ON PlaylistTrack.TrackId = Track.TrackId
JOIN dbo.Album ON Track.AlbumId = Album.AlbumId
JOIN dbo.Artist ON Album.AlbumId = Artist.ArtistId
WHERE Artist.Name = 'AC/DC';

--12. Listar las playlist que tienen alguna canción del artista Queen, junto con la cantidad que tienen
SELECT Playlist.Name, COUNT(Track.TrackId) AS CantidadCancionesQueen FROM dbo.Playlist
JOIN dbo.PlaylistTrack ON Playlist.PlaylistId = PlaylistTrack.PlaylistId
JOIN dbo.Track ON PlaylistTrack.TrackId = Track.TrackId
JOIN dbo.Album ON Track.AlbumId = Album.AlbumId
JOIN dbo.Artist ON Album.AlbumId = Artist.ArtistId
WHERE Artist.Name = 'Queen' GROUP BY Playlist.Name

--13. Listar las pistas que no están en ninguna playlist
SELECT * FROM  dbo.Track
WHERE TrackId NOT IN (SELECT TrackId FROM dbo.PlaylistTrack);

--14. Listar los artistas que no tienen album
SELECT * FROM dbo.Artist
WHERE ArtistId NOT IN (SELECT ArtistId FROM dbo.Album);

--15. Listar los artistas con el número de albums que tienen
SELECT Artist.Name, COUNT(Album.AlbumId) AS TotalAlbunes
FROM dbo.Artist LEFT JOIN dbo.Album ON Artist.ArtistId = Album.ArtistId
GROUP BY Artist.Name;

--EXTRAS

--16. Listar las pistas ordenadas por el número de veces que aparecen en playlists de forma descendente
SELECT Track.Name, COUNT(PlaylistTrack.PlaylistId) AS VecesEnPlaylist
FROM dbo.Track JOIN dbo.PlaylistTrack ON Track.TrackId = PlaylistTrack.TrackId
GROUP BY Track.Name ORDER BY VecesEnPlaylist;

--17. Listar las pistas más compradas (la tabla InvoiceLine tiene los registros de compras)
SELECT Track.Name, COUNT(InvoiceLine.InvoiceLineId) AS Ventas FROM dbo.Track
JOIN dbo.InvoiceLine ON Track.TrackId = InvoiceLine.TrackId 
GROUP BY Track.Name ORDER BY Ventas DESC;

--18. Listar los artistas más comprados
SELECT Artist.Name, COUNT(InvoiceLine.InvoiceLineId) AS VentasTotales
FROM dbo.Artist JOIN dbo.Album ON Artist.ArtistId = Album.ArtistId
JOIN dbo.Track ON Album.AlbumId = Track.AlbumId
JOIN dbo.InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Artist.Name ORDER BY VentasTotales 

--19. Listar las pistas que aún no han sido compradas por nadie
SELECT * FROM dbo.Track
WHERE TrackId NOT IN (SELECT DISTINCT TrackId FROM dbo.InvoiceLine);

--20. Listar los artistas que aún no han vendido ninguna pista
SELECT * FROM dbo.Artist
WHERE ArtistId NOT IN (SELECT DISTINCT Album.ArtistId
FROM dbo.Album JOIN dbo.Track ON Album.AlbumId = Track.AlbumId
JOIN dbo.InvoiceLine ON Track.TrackId = InvoiceLine.TrackId);