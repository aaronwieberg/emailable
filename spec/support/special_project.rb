class SpecialProject < Project
  emailable do
    mailing_list do
      to :principal_contact
      bcc ->(project) { project.secondary_contact }
    end

    mailing_list :special do
      to 'someone@special.example'
    end
  end
end
