require 'net/http'

# Lengthen timeout in Net::HTTP
module Net
    class HTTP
        alias old_initialize initialize

        def initialize(*args)
            old_initialize(*args)
            @read_timeout = 5*60 # 5 minutes
        end
    end
end

desc "Posts random photo tagged with TAG to LJ_JOURNAL (using LJ_LOGIN, LJ_PASSWORD, FLICKR_API_KEY and FLICKR_SECRET)"
task :lj_rnd_photo do

  def retryable
    begin
      return yield
    rescue
      sleep 5
      retry
    end
  end

  FlickRaw.api_key=ENV['FLICKR_API_KEY']
  FlickRaw.shared_secret=ENV['FLICKR_SECRET']

  photo = retryable do
    flickr.photos.search(:tags => ENV['TAG'], :per_page => 1, :page => rand(4001)+1)[0]
  end

  user = LiveJournal::User.new(ENV['LJ_LOGIN'], ENV['LJ_PASSWORD'])

  retryable do
    LiveJournal::Request::Login.new(user).run
  end

  user.usejournal = ENV['LJ_JOURNAL']

  entry = LiveJournal::Entry.new
  entry.subject = ''
  entry.event = "<img src='#{FlickRaw.url_b(photo)}' width='100%'>"

  retryable do
    LiveJournal::Request::PostEvent.new(user, entry).run
  end

end