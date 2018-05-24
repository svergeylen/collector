 atom_feed do |feed|
    feed.title("Vergeylen.eu > La Une")
    feed.updated(@posts[0].updated_at) if @posts.length > 0

    @posts.each do |post|
      feed.entry(post) do |entry|
        entry.created_at(post.created_at)
        entry.updated_at(post.updated_at)

        entry.title(truncate( post.user.name+ " : "+ post.message, length: 30) )
        entry.author do |author|
          author.name(post.user.name)
          author.id(post.user.id)
        end

        # Contenu amélioré du post
        whole_content = post.message

        # Ajouts des photos attachés au post
        if post.attachments.present?
          whole_content += "<div class=post-photo-gallery'> "
          post.attachments.each do |a|
            entry.attachements do |attachment|
                whole_content += image_tag "/" + a.image(:thumb)
                whole_content += " &nbsp; "
            end  
          end
          whole_content += "</div>"
        end

        # Ajout du lien vers une page externe
        if post.preview_url  
          whole_content += "<div class='post-preview'>"
          whole_content += "<a href='"+post.preview_url+"'>" + post.preview_title + "</a><br />"
          whole_content += post.preview_description
          whole_content += "</div>"
        end

        entry.content(whole_content, :type => 'html')

      end
    end
  end
