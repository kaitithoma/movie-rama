SELECT
  movies.id movie_id,
  movies.user_id user_id,
  movies.created_at created_at,
  COUNT(votes.id) FILTER (WHERE vote_type = 'like') likes_count,
  COUNT(votes.id) FILTER (WHERE vote_type = 'hate') hates_count
FROM
  movies
  FULL OUTER JOIN votes ON movies.id = votes.movie_id
GROUP BY
  movies.id, movies.user_id, movies.created_at