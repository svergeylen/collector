class CronController < ApplicationController

	# Réalise les taches de cron.
	# Doit être invoqué par le cron du système ou manuellement /cron/run
	def run
		possible_actions = ["add_item", "new_profile_picture", "new_profile_name"]
		@user_ids = Job.where(done: false).select(:user_id).distinct.map{ |job| job.user_id }

		# Traitement distint pour chaque utilisateur
		@user_ids.each do |user_id|

			# On itère sur les types d'actions connues (çàd dont la template existe dans le dosier "shared" )
			possible_actions.each do |action|

				jobs = Job.where(done: false).where(user_id: user_id).where(action: action).order(created_at: :asc)
				if jobs.present?
					logger.debug jobs.inspect

					# On vérifie que le dernier job a été ajouté il y a un certain temps (sinon on attend)
					if (jobs.last.updated_at + 15.minutes < Time.now )
						
						data = { jobs: jobs,
								 item_ids: jobs.map(&:element_id),
								 user_id: user_id }
						message = render_to_string partial: "shared/#{action}", locals: { data: data} 
						@post = Post.create!(message: message, user_id: user_id, updated_at: jobs.last.updated_at, created_at: jobs.last.created_at)
						
						# Marque les jobs comme terminés pour ne plus les traiter une seconde fois
						jobs.update_all(done: true)
						# TODO supprimer les jobs finalisés au lieu de les marqués "done" si tout marche bien
					end
				end # jobs present
				
			end # each action
		end # each user
	end

	# Liste les jobs dans la table
	def jobs
		@jobs = Job.all
	end
end
