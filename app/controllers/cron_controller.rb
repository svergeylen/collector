class CronController < ApplicationController

	# Réalise les taches de cron.
	# Doit être invoqué par le cron du système
	def jobs
		@user_ids = Job.where(done: false).select(:user_id).distinct.map{ |job| job.user_id }

		# Traitement différent pour chaque utilisateur
		@user_ids.each do |user_id|
			user = User.find(user_id)

			# Add_item
			add_item_jobs = Job.where(done: false).where(user_id: user_id).where(action: "add_item").order(created_at: :asc)
			if add_item_jobs.present?
		
				# On vérifie que le dernier job a été ajouté il y a un certain temps (sinon on attend)
				if (add_item_jobs.last.updated_at + 5.minutes < Time.now )
					
					element_ids = add_item_jobs.map(&:element_id)
					data = { items: Item.find(element_ids),
							 user: user }
					logger.debug data.inspect
					message = render_to_string partial: "shared/add_item", locals: { data: data} 
					@post = Post.create!(message: message, user_id: user_id, updated_at: add_item_jobs.last.updated_at, created_at: add_item_jobs.last.created_at)
					
					# Marque les job comme terminés pour ne plus les traiter une seconde fois
					add_item_jobs.update_all(done: true)
				end
			end

			# Nouvelle photo de profil
			


		end
		




		@jobs = Job.all
		render template: "cron/jobs"
	end
end
