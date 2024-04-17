# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  def create
    # Initialize the SQS client
    sqs = Aws::SQS::Client.new(
        region: 'us-east-1',
        access_key_id: 'your-access-key',
        secret_access_key: 'your-secret-key'
    )
    

    # Specify the URL of the SQS queue
    queue_url = 'https://sqs.us-east-1.amazonaws.com/064371329171/test-stripe-queue'

    
    # Create n messages to send to the queue
    messages = 300.times.map do |i|
      {
        id: i.to_s,
        message_body: { name: "#{params[:message_body]}_#{i}" }.to_json
      }
    end


    puts "Sending messages to queue: #{queue_url}"
  
    # Send the messages in batches of up to 10
    messages.each_slice(5) do |message_batch|
      sqs.send_message_batch(queue_url: queue_url, entries: message_batch)
    end

    # Redirect back to the root path after enqueuing the message
    redirect_to root_path, notice: 'Message enqueued successfully!'
  end
end
