require_relative 'load_environment.rb'
require 'byebug'

def main
  loop do
    puts '1) - Activities'
    puts '2) - Reports'
    number = gets.chomp.to_i
    case number
    when 0
      puts 'Bye!'
      break
    when 1
      manage_activities
    when 2
      show_reports
    else
      puts 'Not implemented yet'
    end
  end
end

def show_reports
  loop do
    puts '1) - Minutedock'
    puts '2) - Email'
    puts '3) - Slack'
    number = gets.chomp.to_i
    case number
    when 0
      break
    when 1
      configure_or_report_to_minutedock
    when 2
      configure_or_report_to_email
    else
      puts 'Not implemented yet'
    end
  end
end

def configure_or_report_to_email
  puts 'Not implemented yet'
end

def configure_or_report_to_minutedock
  if EntryLogger.minutedock_configured?
    report_to_minutedock
  else
    configure_minutedock
  end
end

def manage_activities
  loop do
    today_activities
    puts '1) - Log'
    puts "2) - Remove"
    number = gets.chomp.to_i
    case number
    when 0
      break
    when 1
      log_activity
    when 2
      remove_activity
    end
  end
end

def log_activity
  project_id = ask_for_project
  project = EntryLogger.list_projects[project_id]
  duration = ask_for_duration
  description = ask_for_description
  category_id = ask_for_category
  category = EntryLogger.list_categories[category_id]
  EntryLogger.create_entry({
    date: Date.today,
    project: project['project'],
    project_id: project['minutedock_id'],
    category: category['category'],
    category_id: category['minutedock_id'],
    duration: duration.try(:hours),
    description: description
  })
end

def ask_for_project
  loop do
    projects = EntryLogger.list_projects
    projects_to_select = projects.keys
    projects_to_select.each_with_index do |k, i|
      puts "#{i+1} - #{projects[k]['project']}"
    end
    puts 'Select Project Number:'
    selected_number = gets.chomp.to_i
    if selected_number == 0
      puts 'No project selected'
      break
    elsif (1..projects.count).include?(selected_number)
      project_id = projects_to_select[selected_number-1]
      return project_id
    else
      puts "Wrong number, select again"
    end
  end
end

def ask_for_duration
  puts 'Duration (hours):'
  loop do
    number = gets.chomp.to_i
    if number == 0
      puts 'no duration given'
      break
    elsif (1..24).include?(number)
      return number
    else
      puts 'Introduce number of hours for the task'
    end
  end
end

def ask_for_description
  puts 'Description:'
  description = gets.chomp
  puts "You introduced #{description}"
  description
end

def ask_for_category
  loop do
    categories = EntryLogger.list_categories
    categories_to_select = categories.keys
    categories_to_select.each_with_index do |k, i|
      puts "#{i+1} - #{categories[k]['category']}"
    end
    puts 'Select Category Number:'
    selected_number = gets.chomp.to_i
    if selected_number == 0
      puts 'No category selected'
      break
    elsif (1..categories.count).include?(selected_number)
      category_id = categories_to_select[selected_number-1]
      return category_id
    else
      puts "Wrong number, select again"
    end
  end
end

def today_activities
  entries = EntryLogger.list_entries_for_today

  title = "Today's activities"
  spacer_count = (ActivitiesPrinter.table_header.length - title.length)/2
  spacer = '-'*spacer_count
  puts "#{spacer} #{title} #{spacer}"

  ActivitiesPrinter.print(entries)
end

def remove_activity
  entries = EntryLogger.list_entries_for_today
  loop do
    puts 'Number of entry to delete:'
    number = gets.chomp.to_i

    break if number == 0

    if number <= entries.length
      entry_id = entries[number - 1].id
      EntryLogger.remove_entry(entry_id)
      puts 'Activity removed'
      break
    else
      puts 'Number not valid'
    end
  end
  puts 'not implemented yet'
end

def report_to_minutedock
  EntryLogger.report_pending_to_minutedock
  puts 'No pending entries to report'
end

def configure_minutedock
  puts 'Paste your api key from minutedock profile'
  api_key = gets.chomp
  EntryLogger.setup_minutedock(api_key)
  EntryLogger.import_projects_from_minutedock
  EntryLogger.import_categories_from_minutedock
rescue MinuteDock::InvalidCredentialsError => e
  puts "API key seems to be invalid, try again"
end

class ActivitiesPrinter
  NUMBER_LENGTH, PROJECT_LENGTH, DESC_LENGTH, DURATION_LENGTH = 5, 15, 50, 10

  def self.print(entries)
    print_activities_header
    entries.each_with_index do |entry, index|
      print_formatted_activity(index + 1, entry)
    end
    puts
  end

  def self.table_header
    "%-#{NUMBER_LENGTH}s | %-#{PROJECT_LENGTH}s | %-#{DESC_LENGTH}s | %-#{DURATION_LENGTH}s" %
    ['Number', 'Project', 'Description', 'Duration']
  end

  def self.print_activities_header
    puts
    puts table_header
    puts "-" * (table_header.length)
  end

  def self.print_formatted_activity(index, entry)
    formatted_output =
      "%-#{NUMBER_LENGTH}s | %-#{PROJECT_LENGTH}s | %-#{DESC_LENGTH}s | %-#{DURATION_LENGTH}s" %
    [ cut_text_at(index.to_s, NUMBER_LENGTH),
      cut_text_at(entry.project, PROJECT_LENGTH),
      cut_text_at(entry.description, DESC_LENGTH),
      cut_text_at("#{entry.duration.to_i/60/60} hs", DURATION_LENGTH) ]
    puts formatted_output
  end

  def self.cut_text_at(text, num)
    return '' unless text.present?
    text[0..(num-1)]
  end
end

main