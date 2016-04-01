class CreateJobNotifierJobs < ActiveRecord::Migration
  def change
    create_table :job_notifier_jobs do |t|
      t.string :identifier
      t.string :status
      t.text :result

      t.timestamps null: false
    end
  end
end
