 atom_feed do |feed|
    feed.title("Vergeylen.eu > News")
    feed.updated(@posts[0].updated_at) if @posts.length > 0

    @posts.each do |post|
      feed.entry(post) do |entry|
        entry.title(post.user.name)
        entry.content(post.message, :type => 'html')
        entry.updated_at(post.updated_at)

        entry.author do |author|
          author.name(post.user.name)
        end
      end
    end
  end