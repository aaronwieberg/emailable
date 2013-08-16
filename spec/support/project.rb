class Project
  MAILBOX = "bcc@example.org"

  include Emailable

  emailable do
    mailing_list do
      to :principal_contact
      cc ->(project) { project.secondary_contact }
      bcc Project::MAILBOX
    end

    mailing_list :admins do
      bcc ->(project) { project.admins }
    end
  end


  def principal_contact
    "to@example.org"
  end
  

  def secondary_contact
    "cc@example.org"
  end


  def admins
    ["a1@example.org", "a2@example.org"]
  end
end
