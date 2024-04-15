# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  def create
    # Initialize the SQS client
    sqs = Aws::SQS::Client.new(
        region: 'us-east-1',
        access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
        secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
    )
    

    # Specify the URL of the SQS queue
    queue_url = 'https://sqs.us-east-1.amazonaws.com/064371329171/test-stripe-queue'

    # Create a message to send to the queue
    message_body = { name: params[:message_body] }

    # Convert the hash to a JSON string
    message_body_json = message_body.to_json

    puts "Sending message: #{message_body_json} to queue: #{queue_url}"

    sqs.send_message(queue_url: queue_url, message_body: message_body_json)

    # Redirect back to the root path after enqueuing the message
    redirect_to root_path, notice: 'Message enqueued successfully!'
  end
end
