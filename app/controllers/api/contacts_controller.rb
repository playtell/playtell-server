class Api::ContactsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  
  # Pass a list of contacts
  def create_list
    # First delete all current contacts for this user (no overlapping contacts)
    current_user.contacts.delete
    
    # Parse the list (json encoded) and create individual contact entries
    if params[:contacts].nil? || params[:contacts].empty?
      return render :status => 170, :json => {:message => 'Contacts are missing.'}
    end
    contacts = ActiveSupport::JSON.decode(params[:contacts])
    
    total_saved = 0
    contacts.each do |contact|
      # Verify this contact has all required params
      next if (!contact.key?('name') || !contact.key?('email') || !contact.key?('source'))
      
      # Create new contact entry
      Contact.create({
        :user_id => current_user.id,
        :name    => contact['name'],
        :email   => contact['email'],
        :source  => contact['source']
      })
      
      total_saved += 1
    end

    render :status => 200, :json => {:message => "Contacts saved successfully (#{total_saved} of #{contacts.size})."}
  end

  def show
    contacts = []
    current_user.contacts.each do |contact|
      contacts << {
        :name   => contact.name,
        :email  => contact.email,
        :source => contact.source
      }
    end
    render :status => 200, :json => {:contacts => contacts, :total_contacts => contacts.size}
  end
end