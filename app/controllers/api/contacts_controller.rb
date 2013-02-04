class Api::ContactsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!
  respond_to :json
  require 'cgi'
  require 'digest/md5'
  
  # Pass a list of contacts
  def create_list
    # First delete all current contacts for this user (no overlapping contacts)
    Contact.delete_all("user_id = #{current_user.id}")
    
    # Parse the list (json encoded) and create individual contact entries
    if params[:contacts].nil? || params[:contacts].empty?
      return render :status => 170, :json => {:message => 'Contacts are missing.'}
    end
    contacts = ActiveSupport::JSON.decode(CGI::unescape(params[:contacts]))
    
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

  # Show all contacts
  def show
    approved_friends = current_user.allFriends.map!{|user| user.id}
    pending_friends = current_user.allPendingFriends.map!{|user| user.id}
    contacts = []
    current_user.contacts.each do |contact|
      # Rehash contact
      currentContact = {
        :uid                 => Digest::MD5.hexdigest(contact.id.to_s),
        :name                => contact.name,
        :email               => contact.email,
        :source              => contact.source,
        :user_id             => nil,
        :is_confirmed_friend => false,
        :is_pending_friend   => false,
        :profile_photo       => nil
      }
      
      # Check if contact is already a registered user
      users = User.where(:email => contact.email).limit(1)
      if users.size > 0
        # Verify current user isn't that contact!
        next if users.first.id == current_user.id
        
        # Pass along user_id instead of email
        currentContact[:user_id] = users.first.id
        currentContact[:email] = nil

        # Check if contact is already a friend (confirmed or pending)
        currentContact[:is_confirmed_friend] = approved_friends.include?(users.first.id)
        currentContact[:is_pending_friend] = pending_friends.include?(users.first.id)
        
        # Load profile photo
        currentContact[:profile_photo] = users.first.profile_photo
      end
      
      # Add to contacts list
      contacts << currentContact
    end
    render :status => 200, :json => {:contacts => contacts, :total_contacts => contacts.size}
  end
  
  # Show only related contacts (based on last name match)
  def show_related
    approved_friends = current_user.allFriends.map!{|user| user.id}
    pending_friends = current_user.allPendingFriends.map!{|user| user.id}
    contacts = []
    filtered_contacts = current_user.contacts.where("contacts.name ilike '%#{current_user.lastname}%'").joins('inner join users on users.email = contacts.email')
    filtered_contacts.each do |contact|
      user = User.find_by_email(contact.email)

      # Verify current user isn't that contact!
      next if user.id == current_user.id

      # Rehash contact
      currentContact = {
        :uid                 => Digest::MD5.hexdigest(contact.id.to_s),
        :name                => contact.name,
        :email               => contact.email,
        :source              => contact.source,
        :user_id             => user.id,
        :is_confirmed_friend => approved_friends.include?(user.id),
        :is_pending_friend   => pending_friends.include?(user.id),
        :profile_photo       => user.profile_photo
      }

      # Add to contacts list
      contacts << currentContact
    end
    render :status => 200, :json => {:contacts => contacts, :total_contacts => contacts.size}
  end

  # Send invite message to a list of contacts
  # params: message, emails
  def notify
    # Parse the message to send
    if params[:message].nil? || params[:message].empty?
      return render :status => 172, :json => {:message => 'Invitation message is missing.'}
    end
    message = CGI::unescape(params[:message])
    
    # Parse the list of emails (json encoded)
    if params[:emails].nil? || params[:emails].empty?
      return render :status => 171, :json => {:message => 'Contact emails are missing.'}
    end
    emails = ActiveSupport::JSON.decode(CGI::unescape(params[:emails]))

    # Notify each
    emails_sent = 0
    emails.each do |email|
      # Find the contact by email
      contact = Contact.find_by_email(email)
      next if contact.nil?

      # Check if already notified recently by the same user. If so, skip!
      next if current_user.contact_notifications.where(:email => email).count > 0

      # Save a record that we emailed them
      ContactNotification.create({
        :user_id => current_user.id,
        :email   => email
      })
    
      # Send the actual email
      UserMailer.contact_invitation(current_user, contact, message).deliver

      emails_sent += 1
    end
    
    render :status => 200, :json => {:message => "Contacts notified successfully (#{emails_sent} of #{emails.size})."}
  end
  
  # expected params "search_string"
  def search
    approved_friends = current_user.allFriends.map!{|user| user.id}
    pending_friends = current_user.allPendingFriends.map!{|user| user.id}
    
    matches = []
    s = params[:search_string].split.map{ |term| "%#{term}%" }
    s.each do |str|
      if str =~ /@/i 
        @users = User.where("email LIKE ?", str)
        @users.each do |u|
          next if u.id == current_user.id
          current_match = { 
              :name                => u.username,
              :email               => u.email,
              :user_id             => u.id,
              :is_confirmed_friend => approved_friends.include?(u.id),
              :is_pending_friend   => pending_friends.include?(u.id),
              :profile_photo       => u.profile_photo
            }
          matches << current_match
        end
      # search usernames    
      else
        @users = User.where("username LIKE ?", str)
        @emails = User.where("email LIKE ?", "%#{str.split('@').first}%")
        (@users | @emails).each do |u|
          next if u.id == current_user.id
          current_match = { 
              :name                => u.username,
              :email               => u.email,
              :user_id             => u.id,
              :is_confirmed_friend => approved_friends.include?(u.id),
              :is_pending_friend   => pending_friends.include?(u.id),
              :profile_photo       => u.profile_photo
            }
          matches << current_match
          end
      end  
    end
    
    render :status => 200, :json => {:matches => matches.uniq, :search_string => params[:search_string]}
  end
end