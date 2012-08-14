desc "Posts random photo tagged with TAG to LJ_JOURNAL (using LJ_LOGIN, LJ_PASSWORD, FLICKR_API_KEY and FLICKR_SECRET)"
task :lj_rnd_photo do

  FlickRaw.api_key=ENV['FLICKR_API_KEY']
  FlickRaw.shared_secret=ENV['FLICKR_SECRET']

  begin
    photo = flickr.photos.search(:tags => ENV['TAG'], :per_page => 1, :page => rand(4001)+1)[0]
  rescue
    retry
  end

  user = LiveJournal::User.new(ENV['LJ_LOGIN'], ENV['LJ_PASSWORD'])
  login = LiveJournal::Request::Login.new(user)
  
  begin
    login.run
  rescue
    retry
  end

  user.usejournal = ENV['LJ_JOURNAL']

  entry = LiveJournal::Entry.new
  entry.subject = ''
  entry.event = "<img src='#{FlickRaw.url_b(photo)}' width='100%'>"
  request = LiveJournal::Request::PostEvent.new user, entry

  begin
    request.run
  rescue
    retry
  end

end