class CronController < ApplicationController

	skip_before_action :authenticate_user!

	# Réalise les taches de cron.
	# Doit être invoqué par le cron du système ou manuellement /cron/run
	def run
		@jobs_done = 0
		possible_actions = ["add_item", "add_pictures", "new_profile_picture", "new_profile_name"]
		user_ids = Job.where(done: false).select(:user_id).distinct.map{ |job| job.user_id }

		# Traitement distint pour chaque utilisateur
		user_ids.each do |user_id|

			# On itère sur les types d'actions connues (çàd dont la template existe dans le dosier "app/views/cron" )
			possible_actions.each do |action|

				jobs = Job.where(done: false).where(user_id: user_id).where(action: action).order(created_at: :asc)
				if jobs.present?
					#logger.debug "------------->>"+ jobs.inspect

					# On vérifie que le dernier job a été ajouté il y a un certain temps (sinon on attend)
					if (jobs.last.created_at + 15.minutes < Time.now )
						user = User.find(user_id)
						item_ids = []
						
						# On élimine les items qui auraient déjà été supprimés depuis la création du job.
						jobs.each { |job|
						 	if Item.exists?(job.element_id) 
							 	item_ids << job.element_id
							end
						 }
						items = Item.includes(:folder).find( item_ids )
						
						data = { jobs: jobs,
								 items: items,
								 quantity: item_ids.length,
								 user: user }
						
						message = render_to_string partial: "cron/#{action}", locals: { data: data} 
						post = Post.create!(message: message, user_id: user_id, updated_at: jobs.last.updated_at, created_at: jobs.last.created_at)
						
						# Marque les jobs comme terminés pour ne plus les traiter une seconde fois
						@jobs_done += jobs.count
						jobs.update_all(done: true)
						
					end
				end # jobs present
				
			end # each action
		end # each user

		# Supprime les vieux jobs
		@jobs_deleted = Job.where(done: true).where("created_at < ?", (Date.today - 60) ).delete_all

		render plain: "#{@jobs_done} jobs réalisés. #{@jobs_deleted} anciens jobs supprimés."
	end

	# Liste les jobs dans la table
	def jobs
		@jobs = Job.all.order(created_at: :desc)
	end
end
