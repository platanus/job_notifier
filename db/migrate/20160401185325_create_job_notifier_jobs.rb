class CreateJobNotifierJobs < ActiveRecord::Migration
  def change
    create_table :job_notifier_jobs do |t|
      t.string :identifier, index: true
      t.string :job_id, index: true
      t.string :status
      t.text :result

      t.timestamps null: false
    end
  end
end
