namespace :db do
  desc "Filling statuses and subjects tables"
  
  task supportilla_seed: :environment do
    make_subjects
    make_statuses
  end
  
  task :fake_tickets, [:count] => :environment do |t, args|
    args[:count].to_i.times do |n|
      ticket = Supportilla::Ticket.create!(name: "Ticket#{n}", 
        email: "fake#{n}@fake.com", subject: Supportilla::Subject.all.sample,
        question: "Its fake!")
      ticket.status = Supportilla::Status.find_by_identify("unassigned")
      ticket.save
    end
  end
  
  task :supportilla_admin,
    [:password, :password_confirmation] => :environment do |t, args|
    Supportilla::Staff.create!(username: "administrator", admin: true,
      password: args[:password], 
      password_confirmation: args[:password_confirmation])
  end    
end

def make_subjects
  subjects = ["Account", "Site content", "Site bugs"]
  subjects.count.times do |n|
    Supportilla::Subject.create!(description: subjects[n], activity: true)
  end
end

def make_statuses
  status_count = 6
  identifiers = %w(unassigned open customer hold cancelled completed)
  role = ["New unassigned", "Open", "On hold", "On hold", "Closed", "Closed"]
  descriptions = ["Waiting for staff responce", "Waiting for staff responce",
    "Waiting for customer", "On hold", "Cancelled", "Completed"]
  status_count.times do |n|
    status = Supportilla::Status.new(identify: identifiers[n], role: role[n],
      description: descriptions[n])
    status.basic = true
    status.save   
  end                                                                         
end