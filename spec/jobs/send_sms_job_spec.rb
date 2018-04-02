require 'rails_helper'

RSpec.describe SendTextMessageJob, type: :job do
  it "queues the job properly" do
    ActiveJob::Base.queue_adapter = :test    
    expect { SendTextMessageJob.perform_later(message: "Hey!") }
      .to have_enqueued_job.with(message: "Hey!")
      .on_queue("default")
  end
end
