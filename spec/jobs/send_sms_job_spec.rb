require 'rails_helper'

RSpec.describe SendTextMessageJob, type: :job do
  it "queues the job properly" do
    ActiveJob::Base.queue_adapter = :test    
    expect { SendTextMessageJob.perform_later("Hey!") }
      .to have_enqueued_job.with("Hey!")
      .on_queue("default")
  end
end
