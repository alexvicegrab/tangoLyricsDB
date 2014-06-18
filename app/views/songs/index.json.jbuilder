json.array!(@songs) do |song|
  json.extract! song, :id
  json.url song_url(song, format: :json)
end
