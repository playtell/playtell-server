class Api::ContactsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  
  # Pass a list of contacts
  def create_list
    # First delete all current contacts for this user (no overlapping contacts)
    current_user.contacts.delete_all
    
    # Parse the list (json encoded) and create individual contact entries
    if params[:contacts].nil? || params[:contacts].empty?
      return render :status => 170, :json => {:message => 'Contacts are missing.'}
    end
    # contacts = ActiveSupport::JSON.decode(params[:contacts])
    
    total_saved = 0
    puts(contacts.inspect)
    # contacts.each do |contact|
    #       # Verify this contact has all required params
    #       next if (!contact.key?('name') || !contact.key?('email') || !contact.key?('source'))
    #       
    #       # Create new contact entry
    #       Contact.create({
    #         :user_id => current_user.id,
    #         :name    => contact['name'],
    #         :email   => contact['email'],
    #         :source  => contact['source']
    #       })
    #       
    #       total_saved += 1
    #     end

    render :status => 200, :json => {:message => "Contacts saved successfully (#{total_saved} of #{contacts.size})."}
  end

  def show
    current_friends = current_user.allFriends.map!{|user| user.id}
    contacts = []
    current_user.contacts.each do |contact|
      # Rehash contact
      currentContact = {
        :name      => contact.name,
        :email     => contact.email,
        :source    => contact.source,
        :user_id   => nil,
        :is_friend => false
      }
      
      # Check if contact is already a registered user
      users = User.where(:email => contact.email).limit(1)
      if users.size > 0
        # Pass along user_id instead of email
        currentContact[:user_id] = users.first.id
        currentContact[:email] = nil

        # Check if contact is already a friend
        currentContact[:is_friend] = current_friends.include?(users.first.id)
      end
      
      # Add to contacts list
      contacts << currentContact
    end
    render :status => 200, :json => {:contacts => contacts, :total_contacts => contacts.size}
  end
end